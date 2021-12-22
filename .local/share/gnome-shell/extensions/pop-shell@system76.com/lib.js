const Me = imports.misc.extensionUtils.getCurrentExtension();
const log = Me.imports.log;
const rectangle = Me.imports.rectangle;
const { Meta, St } = imports.gi;
var Orientation;
(function (Orientation) {
    Orientation[Orientation["HORIZONTAL"] = 0] = "HORIZONTAL";
    Orientation[Orientation["VERTICAL"] = 1] = "VERTICAL";
})(Orientation || (Orientation = {}));
function nth_rev(array, nth) {
    return array[array.length - nth - 1];
}
function ok(input, func) {
    return input ? func(input) : null;
}
function ok_or_else(input, ok_func, or_func) {
    return input ? ok_func(input) : or_func();
}
function or_else(input, func) {
    return input ? input : func();
}
function bench(name, callback) {
    const start = new Date().getMilliseconds();
    const value = callback();
    const end = new Date().getMilliseconds();
    log.info(`bench ${name}: ${end - start} ms elapsed`);
    return value;
}
function current_monitor() {
    return rectangle.Rectangle.from_meta(global.display.get_monitor_geometry(global.display.get_current_monitor()));
}
function cursor_rect() {
    let [x, y] = global.get_pointer();
    return new rectangle.Rectangle([x, y, 1, 1]);
}
function dbg(value) {
    log.debug(String(value));
    return value;
}
function* get_children(actor) {
    let nth = 0;
    let children = actor.get_n_children();
    while (nth < children) {
        const child = actor.get_child_at_index(nth);
        if (child)
            yield child;
        nth += 1;
    }
}
function join(iterator, next_func, between_func) {
    ok(iterator.next().value, (first) => {
        next_func(first);
        for (const item of iterator) {
            between_func();
            next_func(item);
        }
    });
}
function is_move_op(op) {
    return [
        Meta.GrabOp.WINDOW_BASE,
        Meta.GrabOp.MOVING,
        Meta.GrabOp.KEYBOARD_MOVING
    ].indexOf(op) > -1;
}
function orientation_as_str(value) {
    return value == 0 ? "Orientation::Horizontal" : "Orientation::Vertical";
}
function recursive_remove_children(actor) {
    for (const child of get_children(actor)) {
        recursive_remove_children(child);
    }
    actor.remove_all_children();
}
function round_increment(value, increment) {
    return Math.round(value / increment) * increment;
}
function round_to(n, digits) {
    let m = Math.pow(10, digits);
    n = parseFloat((n * m).toFixed(11));
    return Math.round(n) / m;
}
function separator() {
    return new St.BoxLayout({ styleClass: 'pop-shell-separator', x_expand: true });
}
