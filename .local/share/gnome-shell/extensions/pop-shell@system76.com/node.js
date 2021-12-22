const Me = imports.misc.extensionUtils.getCurrentExtension();
const Ecs = Me.imports.ecs;
var NodeKind;
(function (NodeKind) {
    NodeKind[NodeKind["FORK"] = 1] = "FORK";
    NodeKind[NodeKind["WINDOW"] = 2] = "WINDOW";
    NodeKind[NodeKind["STACK"] = 3] = "STACK";
})(NodeKind || (NodeKind = {}));
function node_variant_as_string(value) {
    return value == NodeKind.FORK ? "NodeVariant::Fork" : "NodeVariant::Window";
}
function stack_detach(node, stack, idx) {
    node.entities.splice(idx, 1);
    stack.remove_by_pos(idx);
}
function stack_find(node, entity) {
    let idx = 0;
    while (idx < node.entities.length) {
        if (Ecs.entity_eq(entity, node.entities[idx])) {
            return idx;
        }
        idx += 1;
    }
    return null;
}
function stack_move_left(ext, forest, node, entity) {
    var _a;
    const stack = forest.stacks.get(node.idx);
    if (!stack)
        return false;
    let idx = 0;
    for (const cmp of node.entities) {
        if (Ecs.entity_eq(cmp, entity)) {
            if (idx === 0) {
                stack_detach(node, stack, 0);
                return false;
            }
            else {
                stack_swap(node, idx - 1, idx);
                stack.active_id -= 1;
                (_a = ext.auto_tiler) === null || _a === void 0 ? void 0 : _a.update_stack(ext, node);
                return true;
            }
        }
        idx += 1;
    }
    return false;
}
function stack_move_right(ext, forest, node, entity) {
    var _a;
    const stack = forest.stacks.get(node.idx);
    if (!stack)
        return false;
    let moved = false;
    let idx = 0;
    const max = node.entities.length - 1;
    for (const cmp of node.entities) {
        if (Ecs.entity_eq(cmp, entity)) {
            if (idx === max) {
                stack_detach(node, stack, idx);
                moved = false;
            }
            else {
                stack_swap(node, idx + 1, idx);
                stack.active_id += 1;
                (_a = ext.auto_tiler) === null || _a === void 0 ? void 0 : _a.update_stack(ext, node);
                moved = true;
            }
            break;
        }
        idx += 1;
    }
    return moved;
}
function stack_replace(ext, node, window) {
    if (!ext.auto_tiler)
        return;
    const stack = ext.auto_tiler.forest.stacks.get(node.idx);
    if (!stack)
        return;
    stack.replace(window);
}
function stack_remove(forest, node, entity) {
    const stack = forest.stacks.get(node.idx);
    if (!stack)
        return null;
    const idx = stack.remove_tab(entity);
    if (idx !== null)
        node.entities.splice(idx, 1);
    return idx;
}
function stack_swap(node, from, to) {
    const tmp = node.entities[from];
    node.entities[from] = node.entities[to];
    node.entities[to] = tmp;
}
var Node = class Node {
    constructor(inner) {
        this.inner = inner;
    }
    static fork(entity) {
        return new Node({ kind: NodeKind.FORK, entity });
    }
    static window(entity) {
        return new Node({ kind: NodeKind.WINDOW, entity });
    }
    static stacked(window, idx) {
        const node = new Node({
            kind: NodeKind.STACK,
            entities: [window],
            idx,
            rect: null
        });
        return node;
    }
    display(fmt) {
        fmt += `{\n    kind: ${node_variant_as_string(this.inner.kind)},\n    `;
        switch (this.inner.kind) {
            case 1:
            case 2:
                fmt += `entity: (${this.inner.entity})\n  }`;
                return fmt;
            case 3:
                fmt += `entities: ${this.inner.entities}\n  }`;
                return fmt;
        }
    }
    is_in_stack(entity) {
        if (this.inner.kind === 3) {
            for (const compare of this.inner.entities) {
                if (Ecs.entity_eq(entity, compare))
                    return true;
            }
        }
        return false;
    }
    is_fork(entity) {
        return this.inner.kind === 1 && Ecs.entity_eq(this.inner.entity, entity);
    }
    is_window(entity) {
        return this.inner.kind === 2 && Ecs.entity_eq(this.inner.entity, entity);
    }
    measure(tiler, ext, parent, area, record) {
        switch (this.inner.kind) {
            case 1:
                const fork = tiler.forks.get(this.inner.entity);
                if (fork) {
                    record;
                    fork.measure(tiler, ext, area, record);
                }
                break;
            case 2:
                record(this.inner.entity, parent, area.clone());
                break;
            case 3:
                const size = ext.dpi * 4;
                this.inner.rect = area.clone();
                this.inner.rect.y += size * 6;
                this.inner.rect.height -= size * 6;
                for (const entity of this.inner.entities) {
                    record(entity, parent, this.inner.rect);
                }
                if (ext.auto_tiler) {
                    ext.auto_tiler.forest.stack_updates.push([this.inner, parent]);
                }
        }
    }
}
