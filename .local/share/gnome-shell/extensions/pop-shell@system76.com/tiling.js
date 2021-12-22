const Me = imports.misc.extensionUtils.getCurrentExtension();
const GrabOp = Me.imports.grab_op;
const Lib = Me.imports.lib;
const Log = Me.imports.log;
const Node = Me.imports.node;
const Rect = Me.imports.rectangle;
const Tags = Me.imports.tags;
const Tweener = Me.imports.tweener;
const window = Me.imports.window;
const geom = Me.imports.geom;
const exec = Me.imports.executor;
const { Meta } = imports.gi;
const Main = imports.ui.main;
const { ShellWindow } = window;
var Direction;
(function (Direction) {
    Direction[Direction["Left"] = 0] = "Left";
    Direction[Direction["Up"] = 1] = "Up";
    Direction[Direction["Right"] = 2] = "Right";
    Direction[Direction["Down"] = 3] = "Down";
})(Direction || (Direction = {}));
var Tiler = class Tiler {
    constructor(ext) {
        this.window = null;
        this.moving = false;
        this.resizing_window = false;
        this.swap_window = null;
        this.queue = new exec.ChannelExecutor();
        this.keybindings = {
            "management-orientation": () => this.toggle_orientation(ext),
            "tile-move-left": () => this.move_left(ext),
            "tile-move-down": () => this.move_down(ext),
            "tile-move-up": () => this.move_up(ext),
            "tile-move-right": () => this.move_right(ext),
            "tile-resize-left": () => this.resize(ext, Direction.Left),
            "tile-resize-down": () => this.resize(ext, Direction.Down),
            "tile-resize-up": () => this.resize(ext, Direction.Up),
            "tile-resize-right": () => this.resize(ext, Direction.Right),
            "tile-swap-left": () => this.swap_left(ext),
            "tile-swap-down": () => this.swap_down(ext),
            "tile-swap-up": () => this.swap_up(ext),
            "tile-swap-right": () => this.swap_right(ext),
            "tile-accept": () => this.accept(ext),
            "tile-reject": () => this.exit(ext),
            "toggle-stacking": () => this.toggle_stacking(ext),
        };
    }
    toggle_orientation(ext) {
        var _a;
        const window = ext.focus_window();
        if (window)
            (_a = ext.auto_tiler) === null || _a === void 0 ? void 0 : _a.toggle_orientation(ext, window);
    }
    toggle_stacking(ext) {
        var _a;
        (_a = ext.auto_tiler) === null || _a === void 0 ? void 0 : _a.toggle_stacking(ext);
        const win = ext.focus_window();
        if (win)
            this.overlay_watch(ext, win);
    }
    rect(ext, monitor) {
        if (!ext.overlay.visible)
            return null;
        const columns = Math.floor(monitor.width / ext.column_size);
        const rows = Math.floor(monitor.height / ext.row_size);
        return monitor_rect(monitor, columns, rows);
    }
    change(overlay, rect, dx, dy, dw, dh) {
        let changed = new Rect.Rectangle([
            overlay.x + dx * rect.width,
            overlay.y + dy * rect.height,
            overlay.width + dw * rect.width,
            overlay.height + dh * rect.height,
        ]);
        changed.x = Lib.round_increment(changed.x - rect.x, rect.width) + rect.x;
        changed.y = Lib.round_increment(changed.y - rect.y, rect.height) + rect.y;
        changed.width = Lib.round_increment(changed.width, rect.width);
        changed.height = Lib.round_increment(changed.height, rect.height);
        if (changed.width < rect.width) {
            changed.width = rect.width;
        }
        if (changed.height < rect.height) {
            changed.height = rect.height;
        }
        let monitors = tile_monitors(changed);
        if (monitors.length == 0)
            return this;
        let min_x = null;
        let min_y = null;
        let max_x = null;
        let max_y = null;
        for (const monitor of monitors) {
            if (min_x === null || monitor.x < min_x) {
                min_x = monitor.x;
            }
            if (min_y === null || monitor.y < min_y) {
                min_y = monitor.y;
            }
            if (max_x === null || (monitor.x + monitor.width) > max_x) {
                max_x = monitor.x + monitor.width;
            }
            if (max_y === null || (monitor.y + monitor.height) < max_y) {
                max_y = monitor.y + monitor.height;
            }
        }
        if ((min_x === null || min_y === null || max_x === null || max_y === null)
            || changed.x < min_x
            || (changed.x + changed.width) > max_x
            || changed.y < min_y
            || (changed.y + changed.height) > max_y)
            return this;
        overlay.x = changed.x;
        overlay.y = changed.y;
        overlay.width = changed.width;
        overlay.height = changed.height;
        return this;
    }
    unstack_from_fork(ext, stack, focused, fork, left, right, is_left) {
        if (!ext.auto_tiler)
            return null;
        const forest = ext.auto_tiler.forest;
        const new_fork = forest.create_fork(left, right, fork.area, fork.workspace, fork.monitor);
        if (is_left) {
            fork.left = Node.Node.fork(new_fork[0]);
        }
        else {
            fork.right = Node.Node.fork(new_fork[0]);
        }
        ext.auto_tiler.forest.parents.insert(new_fork[0], fork.entity);
        forest.on_attach(new_fork[0], focused.entity);
        for (const e of stack.entities) {
            forest.on_attach(new_fork[0], e);
        }
        return new_fork[1];
    }
    move(ext, x, y, w, h, direction, focus) {
        if (!this.window)
            return;
        const win = ext.windows.get(this.window);
        if (!win)
            return;
        if (ext.auto_tiler && win.is_tilable(ext)) {
            if (this.queue.length === 2)
                return;
            this.queue.send(() => {
                const focused = ext.focus_window();
                if (focused) {
                    if (focused.meta.is_fullscreen()) {
                        focused.meta.unmake_fullscreen();
                    }
                    const move_to = focus();
                    this.moving = true;
                    if (ext.auto_tiler) {
                        const s = ext.auto_tiler.find_stack(focused.entity);
                        if (s) {
                            this.move_from_stack(ext, s, focused, direction);
                            this.moving = false;
                            return;
                        }
                    }
                    if (move_to !== null)
                        this.move_auto(ext, focused, move_to, direction === Direction.Left);
                    this.moving = false;
                }
            });
        }
        else {
            this.swap_window = null;
            this.rect_by_active_area(ext, (_monitor, rect) => {
                this.change(ext.overlay, rect, x, y, w, h)
                    .change(ext.overlay, rect, 0, 0, 0, 0);
            });
        }
    }
    move_alongside_stack(ext, [fork, branch, is_left], focused, direction) {
        let new_fork = null;
        if (fork.is_toplevel && fork.smart_gapped) {
            fork.smart_gapped = false;
            let rect = ext.monitor_work_area(fork.monitor);
            rect.x += ext.gap_outer;
            rect.y += ext.gap_outer;
            rect.width -= ext.gap_outer * 2;
            rect.height -= ext.gap_outer * 2;
            fork.set_area(rect);
        }
        let orientation, reverse;
        const { HORIZONTAL, VERTICAL } = Lib.Orientation;
        switch (direction) {
            case Direction.Left:
                orientation = HORIZONTAL;
                reverse = false;
                break;
            case Direction.Right:
                orientation = HORIZONTAL;
                reverse = true;
                break;
            case Direction.Up:
                orientation = VERTICAL;
                reverse = false;
                break;
            default:
                orientation = VERTICAL;
                reverse = true;
        }
        if (!ext.auto_tiler)
            return;
        const inner = branch.inner;
        Node.stack_remove(ext.auto_tiler.forest, inner, focused.entity);
        ext.auto_tiler.detach_window(ext, focused.entity);
        focused.stack = null;
        if (fork.right) {
            let left, right;
            if (reverse) {
                left = branch;
                right = Node.Node.window(focused.entity);
            }
            else {
                left = Node.Node.window(focused.entity);
                right = branch;
            }
            const inner = branch.inner;
            new_fork = this.unstack_from_fork(ext, inner, focused, fork, left, right, is_left);
        }
        else if (reverse) {
            fork.right = Node.Node.window(focused.entity);
        }
        else {
            fork.right = fork.left;
            fork.left = Node.Node.window(focused.entity);
        }
        let modifier = (new_fork !== null && new_fork !== void 0 ? new_fork : fork);
        modifier.set_orientation(orientation);
        ext.auto_tiler.forest.on_attach(modifier.entity, focused.entity);
        ext.auto_tiler.tile(ext, fork, fork.area);
        this.overlay_watch(ext, focused);
    }
    move_from_stack(ext, [fork, branch, is_left], focused, direction, force_detach = false) {
        if (!ext.auto_tiler)
            return;
        const inner = branch.inner;
        if (inner.entities.length === 1) {
            ext.auto_tiler.toggle_stacking(ext);
            this.overlay_watch(ext, focused);
            return;
        }
        let new_fork = null;
        if (fork.is_toplevel && fork.smart_gapped) {
            fork.smart_gapped = false;
            let rect = ext.monitor_work_area(fork.monitor);
            rect.x += ext.gap_outer;
            rect.y += ext.gap_outer;
            rect.width -= ext.gap_outer * 2;
            rect.height -= ext.gap_outer * 2;
            fork.set_area(rect);
        }
        const forest = ext.auto_tiler.forest;
        const fentity = focused.entity;
        const detach = (orient, reverse) => {
            if (!ext.auto_tiler)
                return;
            focused.stack = null;
            if (fork.right) {
                let left, right;
                if (reverse) {
                    left = branch;
                    right = Node.Node.window(fentity);
                }
                else {
                    left = Node.Node.window(fentity);
                    right = branch;
                }
                new_fork = this.unstack_from_fork(ext, inner, focused, fork, left, right, is_left);
            }
            else if (reverse) {
                fork.right = Node.Node.window(fentity);
            }
            else {
                fork.right = fork.left;
                fork.left = Node.Node.window(fentity);
            }
            let modifier = (new_fork !== null && new_fork !== void 0 ? new_fork : fork);
            modifier.set_orientation(orient);
            forest.on_attach(modifier.entity, fentity);
            ext.auto_tiler.tile(ext, fork, fork.area);
            this.overlay_watch(ext, focused);
        };
        switch (direction) {
            case Direction.Left:
                if (force_detach) {
                    Node.stack_remove(forest, inner, fentity);
                    detach(Lib.Orientation.HORIZONTAL, false);
                }
                else if (!Node.stack_move_left(ext, forest, inner, fentity)) {
                    detach(Lib.Orientation.HORIZONTAL, false);
                }
                ext.auto_tiler.update_stack(ext, inner);
                break;
            case Direction.Right:
                if (force_detach) {
                    Node.stack_remove(forest, inner, fentity);
                    detach(Lib.Orientation.HORIZONTAL, true);
                }
                else if (!Node.stack_move_right(ext, forest, inner, fentity)) {
                    detach(Lib.Orientation.HORIZONTAL, true);
                }
                ext.auto_tiler.update_stack(ext, inner);
                break;
            case Direction.Up:
                Node.stack_remove(forest, inner, fentity);
                detach(Lib.Orientation.VERTICAL, false);
                break;
            case Direction.Down:
                Node.stack_remove(forest, inner, fentity);
                detach(Lib.Orientation.VERTICAL, true);
                break;
        }
        if (ext.moved_by_mouse && inner.entities.length === 1) {
            const ent = inner.entities[0];
            const win = ext.windows.get(ent);
            const fork = ext.auto_tiler.get_parent_fork(ent);
            if (fork && win) {
                ext.auto_tiler.unstack(ext, fork, win);
                ext.auto_tiler.tile(ext, fork, fork.area);
            }
        }
    }
    move_auto_(ext, mov1, mov2, callback) {
        if (ext.auto_tiler && this.window) {
            const entity = ext.auto_tiler.attached.get(this.window);
            if (entity) {
                const fork = ext.auto_tiler.forest.forks.get(entity);
                const window = ext.windows.get(this.window);
                if (!fork || !window)
                    return;
                const workspace_id = ext.workspace_id(window);
                const toplevel = ext.auto_tiler.forest.find_toplevel(workspace_id);
                if (!toplevel)
                    return;
                const topfork = ext.auto_tiler.forest.forks.get(toplevel);
                if (!topfork)
                    return;
                const toparea = topfork.area;
                const before = window.rect();
                const grab_op = new GrabOp.GrabOp(this.window, before);
                let crect = grab_op.rect.clone();
                let resize = (mov, func) => {
                    if (func(toparea, crect, mov) || crect.eq(grab_op.rect))
                        return;
                    ext.auto_tiler.forest.resize(ext, entity, fork, this.window, grab_op.operation(crect), crect);
                    grab_op.rect = crect.clone();
                };
                resize(mov1, callback);
                resize(mov2, callback);
                ext.auto_tiler.forest.arrange(ext, fork.workspace);
                Tweener.on_window_tweened(window, () => {
                    ext.register_fn(() => ext.set_overlay(window.rect()));
                });
            }
        }
    }
    overlay_watch(ext, window) {
        Tweener.on_window_tweened(window, () => {
            ext.register_fn(() => {
                if (window) {
                    ext.set_overlay(window.rect());
                    window.activate(false);
                }
            });
        });
    }
    rect_by_active_area(ext, callback) {
        if (this.window) {
            const monitor_id = ext.monitors.get(this.window);
            if (monitor_id) {
                const monitor = ext.monitor_work_area(monitor_id[0]);
                let rect = this.rect(ext, monitor);
                if (rect) {
                    callback(monitor, rect);
                }
            }
        }
    }
    resize_auto(ext, direction) {
        let mov1, mov2;
        const hrow = 64;
        const hcolumn = 64;
        switch (direction) {
            case Direction.Left:
                mov1 = [hrow, 0, -hrow, 0];
                mov2 = [0, 0, -hrow, 0];
                break;
            case Direction.Right:
                mov1 = [0, 0, hrow, 0];
                mov2 = [-hrow, 0, hrow, 0];
                break;
            case Direction.Up:
                mov1 = [0, hcolumn, 0, -hcolumn];
                mov2 = [0, 0, 0, -hcolumn];
                break;
            default:
                mov1 = [0, 0, 0, hcolumn];
                mov2 = [0, -hcolumn, 0, hcolumn];
        }
        this.move_auto_(ext, new Rect.Rectangle(mov1), new Rect.Rectangle(mov2), (work_area, crect, mov) => {
            crect.apply(mov);
            let before = crect.clone();
            crect.clamp(work_area);
            const diff = before.diff(crect);
            crect.apply(new Rect.Rectangle([0, 0, -diff.x, -diff.y]));
            return false;
        });
    }
    move_auto(ext, focused, move_to, stack_from_left = true) {
        let watching = null;
        const at = ext.auto_tiler;
        if (at) {
            if (move_to instanceof ShellWindow) {
                const stack_info = at.find_stack(move_to.entity);
                if (stack_info) {
                    const [stack_fork, branch,] = stack_info;
                    const stack = branch.inner;
                    const placement = { auto: 0 };
                    focused.ignore_detach = true;
                    at.detach_window(ext, focused.entity);
                    at.forest.on_attach(stack_fork.entity, focused.entity);
                    at.update_stack(ext, stack);
                    at.tile(ext, stack_fork, stack_fork.area);
                    focused.ignore_detach = true;
                    at.detach_window(ext, focused.entity);
                    at.attach_to_window(ext, move_to, focused, placement, stack_from_left);
                    watching = focused;
                }
                else {
                    const parent = at.windows_are_siblings(focused.entity, move_to.entity);
                    if (parent) {
                        const fork = at.forest.forks.get(parent);
                        if (fork) {
                            if (!fork.right) {
                                Log.error('move_auto: detected as sibling, but fork lacks right branch');
                                return;
                            }
                            if (fork.left.inner.kind === 3) {
                                Node.stack_remove(at.forest, fork.left.inner, focused.entity);
                                focused.stack = null;
                            }
                            else {
                                const temp = fork.right;
                                fork.right = fork.left;
                                fork.left = temp;
                                at.tile(ext, fork, fork.area);
                                watching = focused;
                            }
                        }
                    }
                    if (!watching) {
                        let movement = { src: focused.meta.get_frame_rect() };
                        focused.ignore_detach = true;
                        at.detach_window(ext, focused.entity);
                        at.attach_to_window(ext, move_to, focused, movement, false);
                        watching = focused;
                    }
                }
            }
            else {
                focused.ignore_detach = true;
                at.detach_window(ext, focused.entity);
                at.attach_to_workspace(ext, focused, [move_to, ext.active_workspace()]);
                watching = focused;
            }
        }
        if (watching) {
            this.overlay_watch(ext, watching);
        }
        else {
            ext.set_overlay(focused.rect());
        }
    }
    move_left(ext) {
        this.move(ext, -1, 0, 0, 0, Direction.Left, move_window_or_monitor(ext, ext.focus_selector.left, Meta.DisplayDirection.LEFT));
    }
    move_down(ext) {
        this.move(ext, 0, 1, 0, 0, Direction.Down, move_window_or_monitor(ext, ext.focus_selector.down, Meta.DisplayDirection.DOWN));
    }
    move_up(ext) {
        this.move(ext, 0, -1, 0, 0, Direction.Up, move_window_or_monitor(ext, ext.focus_selector.up, Meta.DisplayDirection.UP));
    }
    move_right(ext) {
        this.move(ext, 1, 0, 0, 0, Direction.Right, move_window_or_monitor(ext, ext.focus_selector.right, Meta.DisplayDirection.RIGHT));
    }
    resize(ext, direction) {
        if (!this.window)
            return;
        this.resizing_window = true;
        if (ext.auto_tiler && !ext.contains_tag(this.window, Tags.Floating)) {
            this.resize_auto(ext, direction);
        }
        else {
            let array;
            switch (direction) {
                case Direction.Down:
                    array = [0, 0, 0, 1];
                    break;
                case Direction.Left:
                    array = [0, 0, -1, 0];
                    break;
                case Direction.Up:
                    array = [0, 0, 0, -1];
                    break;
                default:
                    array = [0, 0, 1, 0];
            }
            const [x, y, w, h] = array;
            this.swap_window = null;
            this.rect_by_active_area(ext, (_monitor, rect) => {
                this.change(ext.overlay, rect, x, y, w, h)
                    .change(ext.overlay, rect, 0, 0, 0, 0);
            });
        }
        this.resizing_window = false;
    }
    swap(ext, selector) {
        if (selector) {
            ext.set_overlay(selector.rect());
            this.swap_window = selector.entity;
        }
    }
    swap_left(ext) {
        if (this.swap_window) {
            ext.windows.with(this.swap_window, (window) => {
                this.swap(ext, ext.focus_selector.left(ext, window));
            });
        }
        else {
            this.swap(ext, ext.focus_selector.left(ext, null));
        }
    }
    swap_down(ext) {
        if (this.swap_window) {
            ext.windows.with(this.swap_window, (window) => {
                this.swap(ext, ext.focus_selector.down(ext, window));
            });
        }
        else {
            this.swap(ext, ext.focus_selector.down(ext, null));
        }
    }
    swap_up(ext) {
        if (this.swap_window) {
            ext.windows.with(this.swap_window, (window) => {
                this.swap(ext, ext.focus_selector.up(ext, window));
            });
        }
        else {
            this.swap(ext, ext.focus_selector.up(ext, null));
        }
    }
    swap_right(ext) {
        if (this.swap_window) {
            ext.windows.with(this.swap_window, (window) => {
                this.swap(ext, ext.focus_selector.right(ext, window));
            });
        }
        else {
            this.swap(ext, ext.focus_selector.right(ext, null));
        }
    }
    enter(ext) {
        if (!this.window) {
            const win = ext.focus_window();
            if (!win)
                return;
            this.window = win.entity;
            if (win.is_maximized()) {
                win.meta.unmaximize(Meta.MaximizeFlags.BOTH);
            }
            ext.set_overlay(win.rect());
            ext.overlay.visible = true;
            if (!ext.auto_tiler || ext.contains_tag(win.entity, Tags.Floating)) {
                this.rect_by_active_area(ext, (_monitor, rect) => {
                    this.change(ext.overlay, rect, 0, 0, 0, 0);
                });
            }
            ext.keybindings.disable(ext.keybindings.window_focus)
                .enable(this.keybindings);
        }
    }
    accept(ext) {
        if (this.window) {
            const meta = ext.windows.get(this.window);
            if (meta) {
                let tree_swapped = false;
                if (this.swap_window) {
                    const meta_swap = ext.windows.get(this.swap_window);
                    if (meta_swap) {
                        if (ext.auto_tiler) {
                            tree_swapped = true;
                            ext.auto_tiler.attach_swap(ext, this.swap_window, this.window);
                        }
                        else {
                            ext.size_signals_block(meta_swap);
                            meta_swap.move(ext, meta.rect(), () => {
                                ext.size_signals_unblock(meta_swap);
                            });
                        }
                    }
                }
                if (!tree_swapped) {
                    ext.size_signals_block(meta);
                    const meta_entity = this.window;
                    meta.move(ext, ext.overlay, () => {
                        ext.size_signals_unblock(meta);
                        ext.add_tag(meta_entity, Tags.Tiled);
                    });
                }
            }
        }
        this.swap_window = null;
        this.exit(ext);
    }
    exit(ext) {
        this.queue.clear();
        if (this.window) {
            this.window = null;
            ext.overlay.visible = false;
            ext.keybindings.disable(this.keybindings)
                .enable(ext.keybindings.window_focus);
        }
    }
    snap(ext, win) {
        let mon_geom = ext.monitor_work_area(win.meta.get_monitor());
        if (mon_geom) {
            let rect = win.rect();
            const columns = Math.floor(mon_geom.width / ext.column_size);
            const rows = Math.floor(mon_geom.height / ext.row_size);
            this.change(rect, monitor_rect(mon_geom, columns, rows), 0, 0, 0, 0);
            win.move(ext, rect);
            ext.snapped.insert(win.entity, true);
        }
    }
}
;
function locate_monitor(win, direction) {
    if (!win.actor_exists())
        return null;
    const from = win.meta.get_monitor();
    const ref = win.meta.get_work_area_for_monitor(from);
    const n_monitors = global.display.get_n_monitors();
    const { UP, DOWN, LEFT } = Meta.DisplayDirection;
    let origin;
    let exclude;
    if (direction === UP) {
        origin = [ref.x + ref.width / 2, ref.y];
        exclude = (rect) => {
            return rect.y > ref.y;
        };
    }
    else if (direction === DOWN) {
        origin = [ref.x + ref.width / 2, ref.y + ref.height];
        exclude = (rect) => rect.y < ref.y;
    }
    else if (direction === LEFT) {
        origin = [ref.x, ref.y + ref.height / 2];
        exclude = (rect) => rect.x > ref.x;
    }
    else {
        origin = [ref.x + ref.width, ref.y + ref.height / 2];
        exclude = (rect) => rect.x < ref.x;
    }
    let next = null;
    for (let mon = 0; mon < n_monitors; mon += 1) {
        if (mon === from)
            continue;
        const work_area = win.meta.get_work_area_for_monitor(mon);
        if (!work_area || exclude(work_area))
            continue;
        const weight = geom.shortest_side(origin, work_area);
        if (next === null || next[1] > weight) {
            next = [mon, weight];
        }
    }
    return next ? next[0] : null;
}
function monitor_rect(monitor, columns, rows) {
    let tile_width = monitor.width / columns;
    let tile_height = monitor.height / rows;
    if (monitor.width * 9 >= monitor.height * 21) {
        tile_width /= 2;
    }
    if (monitor.height * 9 >= monitor.width * 21) {
        tile_height /= 2;
    }
    return new Rect.Rectangle([monitor.x, monitor.y, tile_width, tile_height]);
}
function move_window_or_monitor(ext, method, direction) {
    return () => {
        const window = method.call(ext.focus_selector, ext, null);
        if (window)
            return window;
        const focus = ext.focus_window();
        return (!focus || !focus.actor_exists()) ? null : locate_monitor(focus, direction);
    };
}
function tile_monitors(rect) {
    let total_size = (a, b) => (a.width * a.height) - (b.width * b.height);
    let workspace = global.workspace_manager.get_active_workspace();
    return Main.layoutManager.monitors
        .map((_monitor, i) => workspace.get_work_area_for_monitor(i))
        .filter((monitor) => {
        return (rect.x + rect.width) > monitor.x &&
            (rect.y + rect.height) > monitor.y &&
            rect.x < (monitor.x + monitor.width) &&
            rect.y < (monitor.y + monitor.height);
    })
        .sort(total_size);
}
