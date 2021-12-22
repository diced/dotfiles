const Me = imports.misc.extensionUtils.getCurrentExtension();
const arena = Me.imports.arena;
const Ecs = Me.imports.ecs;
const Lib = Me.imports.lib;
const log = Me.imports.log;
const movement = Me.imports.movement;
const Rect = Me.imports.rectangle;
const Node = Me.imports.node;
const Fork = Me.imports.fork;
const geom = Me.imports.geom;
const { Arena } = arena;
const { Meta } = imports.gi;
const { Movement } = movement;
const { DOWN, UP, LEFT, RIGHT } = Movement;
var Forest = class Forest extends Ecs.World {
    constructor() {
        super();
        this.toplevel = new Map();
        this.requested = new Map();
        this.stack_updates = new Array();
        this.forks = this.register_storage();
        this.parents = this.register_storage();
        this.string_reps = this.register_storage();
        this.stacks = new Arena();
        this.on_attach = () => { };
        this.on_detach = () => { };
    }
    measure(ext, fork, area) {
        fork.measure(this, ext, area, this.on_record());
    }
    tile(ext, fork, area, ignore_reset = true) {
        this.measure(ext, fork, area);
        this.arrange(ext, fork.workspace, ignore_reset);
    }
    arrange(ext, _workspace, _ignore_reset = false) {
        var _a;
        for (const [entity, r] of this.requested) {
            const window = ext.windows.get(entity);
            if (!window)
                continue;
            let on_complete = () => {
                if (!window.actor_exists())
                    return;
            };
            if (ext.tiler.window) {
                if (Ecs.entity_eq(ext.tiler.window, entity)) {
                    on_complete = () => {
                        ext.set_overlay(window.rect());
                        if (!window.actor_exists())
                            return;
                    };
                }
            }
            move_window(ext, window, r.rect, on_complete);
        }
        this.requested.clear();
        for (const [stack,] of this.stack_updates.splice(0)) {
            (_a = ext.auto_tiler) === null || _a === void 0 ? void 0 : _a.update_stack(ext, stack);
        }
    }
    attach_fork(ext, fork, window, is_left) {
        const node = Node.Node.window(window);
        if (is_left) {
            if (fork.right) {
                const new_fork = this.create_fork(fork.left, fork.right, fork.area_of_right(ext), fork.workspace, fork.monitor)[0];
                fork.right = Node.Node.fork(new_fork);
                this.parents.insert(new_fork, fork.entity);
                this.on_attach(new_fork, window);
            }
            else {
                this.on_attach(fork.entity, window);
                fork.right = fork.left;
            }
            fork.left = node;
        }
        else {
            if (fork.right) {
                const new_fork = this.create_fork(fork.left, fork.right, fork.area_of_left(ext), fork.workspace, fork.monitor)[0];
                fork.left = Node.Node.fork(new_fork);
                this.parents.insert(new_fork, fork.entity);
                this.on_attach(new_fork, window);
            }
            else {
                this.on_attach(fork.entity, window);
            }
            fork.right = node;
        }
        this.on_attach(fork.entity, window);
    }
    attach_stack(ext, stack, fork, new_entity, stack_from_left) {
        var _a;
        const container = this.stacks.get(stack.idx);
        if (container) {
            const window = ext.windows.get(new_entity);
            if (window) {
                window.stack = stack.idx;
                if (stack_from_left) {
                    stack.entities.push(new_entity);
                }
                else {
                    stack.entities.unshift(new_entity);
                }
                this.on_attach(fork.entity, new_entity);
                (_a = ext.auto_tiler) === null || _a === void 0 ? void 0 : _a.update_stack(ext, stack);
                if (window.meta.has_focus()) {
                    container.activate(new_entity);
                }
                return [fork.entity, fork];
            }
            else {
                log.warn('attempted to attach window to stack that does not exist');
            }
        }
        else {
            log.warn('attempted to attach to stack that does not exist');
        }
        return null;
    }
    attach_window(ext, onto_entity, new_entity, place_by, stack_from_left) {
        function place_by_keyboard(fork, src, left, right) {
            const from = [src.x + (src.width / 2), src.y + (src.height / 2)];
            const lside = geom.shortest_side(from, left);
            const rside = geom.shortest_side(from, right);
            if (lside < rside)
                fork.swap_branches();
        }
        function place(place_by, fork, left, right) {
            if ("swap" in place_by) {
                const { orientation, swap } = place_by;
                fork.set_orientation(orientation);
                if (swap)
                    fork.swap_branches();
            }
            else if ("src" in place_by) {
                place_by_keyboard(fork, place_by.src, left, right);
            }
        }
        function area_of_halves(fork) {
            const { x, y, width, height } = fork.area;
            const [left, right] = fork.is_horizontal()
                ? [[x, y, width / 2, height], [x + (width / 2), y, width / 2, height]]
                : [[x, y, width, height / 2], [x, y + (height / 2), width, height / 2]];
            return [new Rect.Rectangle(left), new Rect.Rectangle(right)];
        }
        const fork_and_place_on_left = (entity, fork) => {
            const area = fork.area_of_left(ext);
            const [fork_entity, new_fork] = this.create_fork(fork.left, right_node, area, fork.workspace, fork.monitor);
            fork.left = Node.Node.fork(fork_entity);
            this.parents.insert(fork_entity, entity);
            const [left, right] = area_of_halves(new_fork);
            place(place_by, new_fork, left, right);
            return this._attach(onto_entity, new_entity, this.on_attach, entity, fork, [fork_entity, new_fork]);
        };
        const fork_and_place_on_right = (entity, fork, right_branch) => {
            const area = fork.area_of_right(ext);
            const [fork_entity, new_fork] = this.create_fork(right_branch, right_node, area, fork.workspace, fork.monitor);
            fork.right = Node.Node.fork(fork_entity);
            this.parents.insert(fork_entity, entity);
            const [left, right] = area_of_halves(new_fork);
            place(place_by, new_fork, left, right);
            return this._attach(onto_entity, new_entity, this.on_attach, entity, fork, [fork_entity, new_fork]);
        };
        const right_node = Node.Node.window(new_entity);
        for (const [entity, fork] of this.forks.iter()) {
            if (fork.left.is_window(onto_entity)) {
                if (fork.right) {
                    return fork_and_place_on_left(entity, fork);
                }
                else {
                    fork.right = right_node;
                    fork.set_ratio(fork.length() / 2);
                    return this._attach(onto_entity, new_entity, this.on_attach, entity, fork, null);
                }
            }
            else if (fork.left.is_in_stack(onto_entity)) {
                const stack = fork.left.inner;
                return this.attach_stack(ext, stack, fork, new_entity, stack_from_left);
            }
            else if (fork.right) {
                if (fork.right.is_window(onto_entity)) {
                    return fork_and_place_on_right(entity, fork, fork.right);
                }
                else if (fork.right.is_in_stack(onto_entity)) {
                    const stack = fork.right.inner;
                    return this.attach_stack(ext, stack, fork, new_entity, stack_from_left);
                }
            }
        }
        return null;
    }
    connect_on_attach(callback) {
        this.on_attach = callback;
        return this;
    }
    connect_on_detach(callback) {
        this.on_detach = callback;
        return this;
    }
    create_entity() {
        const entity = super.create_entity();
        this.string_reps.insert(entity, `${entity}`);
        return entity;
    }
    create_fork(left, right, area, workspace, monitor) {
        const entity = this.create_entity();
        let orient = area.width > area.height ? Lib.Orientation.HORIZONTAL : Lib.Orientation.VERTICAL;
        let fork = new Fork.Fork(entity, left, right, area, workspace, monitor, orient);
        this.forks.insert(entity, fork);
        return [entity, fork];
    }
    create_toplevel(window, area, id) {
        const [entity, fork] = this.create_fork(Node.Node.window(window), null, area, id[1], id[0]);
        this.string_reps.with(entity, (sid) => {
            fork.set_toplevel(this, entity, sid, id);
        });
        return [entity, fork];
    }
    delete_entity(entity) {
        const fork = this.forks.remove(entity);
        if (fork && fork.is_toplevel) {
            const id = this.string_reps.get(entity);
            if (id)
                this.toplevel.delete(id);
        }
        super.delete_entity(entity);
    }
    detach(ext, fork_entity, window, destroy_stack = false) {
        const fork = this.forks.get(fork_entity);
        if (!fork)
            return null;
        let reflow_fork = null, stack_detach = false;
        const parent = this.parents.get(fork_entity);
        if (fork.left.is_window(window)) {
            if (parent && fork.right) {
                const pfork = this.reassign_child_to_parent(fork_entity, parent, fork.right);
                if (!pfork)
                    return null;
                reflow_fork = [parent, pfork];
            }
            else if (fork.right) {
                reflow_fork = [fork_entity, fork];
                switch (fork.right.inner.kind) {
                    case 1:
                        this.reassign_children_to_parent(fork_entity, fork.right.inner.entity, fork);
                        break;
                    default:
                        const detached = fork.right;
                        fork.left = detached;
                        fork.right = null;
                }
            }
            else {
                this.delete_entity(fork_entity);
            }
        }
        else if (fork.left.is_in_stack(window)) {
            reflow_fork = [fork_entity, fork];
            stack_detach = true;
            this.remove_from_stack(ext, fork.left.inner, window, destroy_stack, (window) => {
                if (window) {
                    fork.left = Node.Node.window(window);
                }
                else if (fork.right) {
                    fork.left = fork.right;
                    fork.right = null;
                    if (parent) {
                        const pfork = this.reassign_child_to_parent(fork_entity, parent, fork.left);
                        if (!pfork)
                            return null;
                        reflow_fork = [parent, pfork];
                    }
                }
                else {
                    this.delete_entity(fork.entity);
                }
            });
        }
        else if (fork.right) {
            if (fork.right.is_window(window)) {
                if (parent) {
                    const pfork = this.reassign_child_to_parent(fork_entity, parent, fork.left);
                    if (!pfork)
                        return null;
                    reflow_fork = [parent, pfork];
                }
                else {
                    reflow_fork = [fork_entity, fork];
                    switch (fork.left.inner.kind) {
                        case 1:
                            this.reassign_children_to_parent(fork_entity, fork.left.inner.entity, fork);
                            break;
                        default:
                            fork.right = null;
                            break;
                    }
                }
            }
            else if (fork.right.is_in_stack(window)) {
                reflow_fork = [fork_entity, fork];
                stack_detach = true;
                this.remove_from_stack(ext, fork.right.inner, window, destroy_stack, (window) => {
                    if (window) {
                        fork.right = Node.Node.window(window);
                    }
                    else {
                        fork.right = null;
                        this.reassign_to_parent(fork, fork.left);
                    }
                });
            }
        }
        if (stack_detach) {
            ext.windows.with(window, w => w.stack = null);
        }
        this.on_detach(window);
        if (reflow_fork && !stack_detach) {
            reflow_fork[1].rebalance_orientation();
        }
        return reflow_fork;
    }
    fmt(ext) {
        let fmt = '';
        for (const [entity,] of this.toplevel.values()) {
            const fork = this.forks.get(entity);
            fmt += ' ';
            if (fork) {
                fmt += this.display_fork(ext, entity, fork, 1) + '\n';
            }
            else {
                fmt += `Fork(${entity}) Invalid\n`;
            }
        }
        return fmt;
    }
    find_toplevel([src_mon, src_work]) {
        for (const [entity, fork] of this.forks.iter()) {
            if (!fork.is_toplevel)
                continue;
            const { monitor, workspace } = fork;
            if (monitor == src_mon && workspace == src_work) {
                return entity;
            }
        }
        return null;
    }
    grow_sibling(ext, fork_e, fork_c, is_left, movement, crect) {
        const resize_fork = () => this.resize_fork_(ext, fork_e, crect, movement, false);
        if (fork_c.is_horizontal()) {
            if ((movement & (DOWN | UP)) != 0) {
                resize_fork();
            }
            else if (is_left) {
                if ((movement & RIGHT) != 0) {
                    this.readjust_fork_ratio_by_left(ext, crect.width, fork_c);
                }
                else {
                    resize_fork();
                }
            }
            else if ((movement & RIGHT) != 0) {
                resize_fork();
            }
            else {
                this.readjust_fork_ratio_by_right(ext, crect.width, fork_c, fork_c.area.width);
            }
        }
        else {
            if ((movement & (LEFT | RIGHT)) != 0) {
                resize_fork();
            }
            else if (is_left) {
                if ((movement & DOWN) != 0) {
                    this.readjust_fork_ratio_by_left(ext, crect.height, fork_c);
                }
                else {
                    resize_fork();
                }
            }
            else if ((movement & DOWN) != 0) {
                resize_fork();
            }
            else {
                this.readjust_fork_ratio_by_right(ext, crect.height, fork_c, fork_c.area.height);
            }
        }
    }
    *iter(entity, kind = null) {
        let fork = this.forks.get(entity);
        let forks = new Array(2);
        while (fork) {
            if (fork.left.inner.kind === 1) {
                forks.push(this.forks.get(fork.left.inner.entity));
            }
            if (kind === null || fork.left.inner.kind === kind) {
                yield fork.left;
            }
            if (fork.right) {
                if (fork.right.inner.kind === 1) {
                    forks.push(this.forks.get(fork.right.inner.entity));
                }
                if (kind === null || fork.right.inner.kind == kind) {
                    yield fork.right;
                }
            }
            fork = forks.pop();
        }
    }
    largest_window_on(ext, entity) {
        let largest_window = null;
        let largest_size = 0;
        let window_compare = (entity) => {
            const window = ext.windows.get(entity);
            if (window && window.is_tilable(ext)) {
                const rect = window.rect();
                const size = rect.width * rect.height;
                if (size > largest_size) {
                    largest_size = size;
                    largest_window = window;
                }
            }
        };
        for (const node of this.iter(entity)) {
            switch (node.inner.kind) {
                case 2:
                    window_compare(node.inner.entity);
                    break;
                case 3:
                    window_compare(node.inner.entities[0]);
            }
        }
        return largest_window;
    }
    resize(ext, fork_e, fork_c, win_e, movement, crect) {
        const is_left = fork_c.left.is_window(win_e) || fork_c.left.is_in_stack(win_e);
        ((movement & Movement.SHRINK) != 0 ? this.shrink_sibling : this.grow_sibling)
            .call(this, ext, fork_e, fork_c, is_left, movement, crect);
    }
    on_record() {
        return (e, p, a) => this.record(e, p, a);
    }
    record(entity, parent, rect) {
        this.requested.set(entity, {
            parent: parent,
            rect: rect,
        });
    }
    reassign_child_to_parent(child_entity, parent_entity, branch) {
        const parent = this.forks.get(parent_entity);
        if (parent) {
            if (parent.left.is_fork(child_entity)) {
                parent.left = branch;
            }
            else {
                parent.right = branch;
            }
            this.reassign_sibling(branch, parent_entity);
            this.delete_entity(child_entity);
        }
        return parent;
    }
    reassign_to_parent(child, reassign) {
        const p = this.parents.get(child.entity);
        if (p) {
            const p_fork = this.forks.get(p);
            if (p_fork) {
                if (p_fork.left.is_fork(child.entity)) {
                    p_fork.left = reassign;
                }
                else {
                    p_fork.right = reassign;
                }
                const inner = reassign.inner;
                switch (inner.kind) {
                    case 1:
                        this.parents.insert(inner.entity, p);
                        break;
                    case 2:
                        this.on_attach(p, inner.entity);
                        break;
                    case 3:
                        for (const entity of inner.entities)
                            this.on_attach(p, entity);
                }
            }
            this.delete_entity(child.entity);
        }
    }
    reassign_sibling(sibling, parent) {
        switch (sibling.inner.kind) {
            case 1:
                this.parents.insert(sibling.inner.entity, parent);
                break;
            case 2:
                this.on_attach(parent, sibling.inner.entity);
                break;
            case 3:
                for (const entity of sibling.inner.entities) {
                    this.on_attach(parent, entity);
                }
        }
    }
    reassign_children_to_parent(parent_entity, child_entity, p_fork) {
        const c_fork = this.forks.get(child_entity);
        if (c_fork) {
            p_fork.left = c_fork.left;
            p_fork.right = c_fork.right;
            this.reassign_sibling(p_fork.left, parent_entity);
            if (p_fork.right)
                this.reassign_sibling(p_fork.right, parent_entity);
            this.delete_entity(child_entity);
        }
        else {
            log.error(`Fork(${child_entity}) does not exist`);
        }
    }
    readjust_fork_ratio_by_left(ext, left_length, fork) {
        fork.set_ratio(left_length).measure(this, ext, fork.area, this.on_record());
    }
    readjust_fork_ratio_by_right(ext, right_length, fork, fork_length) {
        this.readjust_fork_ratio_by_left(ext, fork_length - right_length, fork);
    }
    remove_from_stack(ext, stack, window, destroy_stack, on_last) {
        var _a, _b, _c;
        if (stack.entities.length === 1) {
            (_a = this.stacks.remove(stack.idx)) === null || _a === void 0 ? void 0 : _a.destroy();
            on_last();
        }
        else {
            const idx = Node.stack_remove(this, stack, window);
            if (idx !== null && idx > 0) {
                const focused = ext.focus_window();
                if (focused && !focused.meta.get_compositor_private() && Ecs.entity_eq(window, focused.entity)) {
                    (_b = ext.windows.get(stack.entities[idx - 1])) === null || _b === void 0 ? void 0 : _b.activate();
                }
            }
            if (destroy_stack && stack.entities.length === 1) {
                on_last(stack.entities[0]);
                (_c = this.stacks.remove(stack.idx)) === null || _c === void 0 ? void 0 : _c.destroy();
            }
        }
        const win = ext.windows.get(window);
        if (win) {
            win.stack = null;
        }
    }
    resize_fork_(ext, child_e, crect, mov, shrunk) {
        let parent = this.parents.get(child_e), child = this.forks.get(child_e);
        if (!parent) {
            child.measure(this, ext, child.area, this.on_record());
            return;
        }
        const src_node = this.forks.get(child_e);
        if (!src_node)
            return;
        let is_left = child.left.is_fork(child_e), length;
        while (parent !== null) {
            child = this.forks.get(parent);
            is_left = child.left.is_fork(child_e);
            if (child.area.contains(crect)) {
                if ((mov & UP) !== 0) {
                    if (shrunk) {
                        if (child.area.y + child.area.height > src_node.area.y + src_node.area.height) {
                            break;
                        }
                    }
                    else if (!child.is_horizontal() || !is_left) {
                        break;
                    }
                }
                else if ((mov & DOWN) !== 0) {
                    if (shrunk) {
                        if (child.area.y < src_node.area.y) {
                            break;
                        }
                    }
                    else if (child.is_horizontal() || is_left) {
                        break;
                    }
                }
                else if ((mov & LEFT) !== 0) {
                    if (shrunk) {
                        if (child.area.x + child.area.width > src_node.area.x + src_node.area.width) {
                            break;
                        }
                    }
                    else if (!child.is_horizontal() || !is_left) {
                        break;
                    }
                }
                else if ((mov & RIGHT) !== 0) {
                    if (shrunk) {
                        if (child.area.x < src_node.area.x) {
                            break;
                        }
                    }
                    else if (!child.is_horizontal() || is_left) {
                        break;
                    }
                }
            }
            child_e = parent;
            parent = this.parents.get(child_e);
        }
        if (child.is_horizontal()) {
            length = is_left
                ? crect.x + crect.width - child.area.x
                : crect.x - child.area.x;
        }
        else {
            length = is_left
                ? crect.y + crect.height - child.area.y
                : child.area.height - crect.height;
        }
        child.set_ratio(length);
        child.measure(this, ext, child.area, this.on_record());
    }
    shrink_sibling(ext, fork_e, fork_c, is_left, movement, crect) {
        const resize_fork = () => this.resize_fork_(ext, fork_e, crect, movement, true);
        if (fork_c.area) {
            if (fork_c.is_horizontal()) {
                if ((movement & (DOWN | UP)) != 0) {
                    resize_fork();
                }
                else if (is_left) {
                    if ((movement & LEFT) != 0) {
                        this.readjust_fork_ratio_by_left(ext, crect.width, fork_c);
                    }
                    else {
                        resize_fork();
                    }
                }
                else if ((movement & LEFT) != 0) {
                    resize_fork();
                }
                else {
                    this.readjust_fork_ratio_by_right(ext, crect.width, fork_c, fork_c.area.array[2]);
                }
            }
            else {
                if ((movement & (LEFT | RIGHT)) != 0) {
                    resize_fork();
                }
                else if (is_left) {
                    if ((movement & UP) != 0) {
                        this.readjust_fork_ratio_by_left(ext, crect.height, fork_c);
                    }
                    else {
                        resize_fork();
                    }
                }
                else if ((movement & UP) != 0) {
                    resize_fork();
                }
                else {
                    this.readjust_fork_ratio_by_right(ext, crect.height, fork_c, fork_c.area.array[3]);
                }
            }
        }
    }
    _attach(onto_entity, new_entity, assoc, entity, fork, result) {
        if (result) {
            assoc(result[0], onto_entity);
            assoc(result[0], new_entity);
        }
        else {
            assoc(entity, new_entity);
        }
        return [entity, fork];
    }
    display_branch(ext, branch, scope) {
        var _a;
        switch (branch.inner.kind) {
            case 1:
                const fork = this.forks.get(branch.inner.entity);
                return fork ? this.display_fork(ext, branch.inner.entity, fork, scope + 1) : "Missing Fork";
            case 2:
                const window = ext.windows.get(branch.inner.entity);
                return `Window(${branch.inner.entity}) (${window ? window.rect().fmt() : "unknown area"}; parent: ${(_a = ext.auto_tiler) === null || _a === void 0 ? void 0 : _a.attached.get(branch.inner.entity)})`;
            case 3:
                let fmt = 'Stack(';
                for (const entity of branch.inner.entities) {
                    const window = ext.windows.get(entity);
                    fmt += `Window(${entity}) (${window ? window.rect().fmt() : "unknown area"}), `;
                }
                return fmt + ')';
        }
    }
    display_fork(ext, entity, fork, scope) {
        let fmt = `Fork(${entity}) [${fork.area ? fork.area.array : "unknown"}]: {\n`;
        fmt += ' '.repeat((1 + scope) * 2) + `workspace: (${fork.workspace}),\n`;
        fmt += ' '.repeat((1 + scope) * 2) + 'left: ' + this.display_branch(ext, fork.left, scope) + ',\n';
        fmt += ' '.repeat((1 + scope) * 2) + 'parent: ' + this.parents.get(fork.entity) + ',\n';
        if (fork.right) {
            fmt += ' '.repeat((1 + scope) * 2) + 'right: ' + this.display_branch(ext, fork.right, scope) + ',\n';
        }
        fmt += ' '.repeat(scope * 2) + '}';
        return fmt;
    }
}
function move_window(ext, window, rect, on_complete) {
    if (!(window.meta instanceof Meta.Window)) {
        log.error(`attempting to a window entity in a tree which lacks a Meta.Window`);
        return;
    }
    const actor = window.meta.get_compositor_private();
    if (!actor) {
        log.warn(`Window(${window.entity}) does not have an actor, and therefore cannot be moved`);
        return;
    }
    ext.size_signals_block(window);
    window.move(ext, rect, () => {
        on_complete();
        ext.size_signals_unblock(window);
    }, false);
}
