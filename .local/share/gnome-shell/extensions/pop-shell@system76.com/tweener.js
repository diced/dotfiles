const GLib = imports.gi.GLib;
const { Clutter } = imports.gi;
function add(win, p) {
    let a = win.meta.get_compositor_private();
    if (!p.mode)
        p.mode = Clutter.AnimationMode.LINEAR;
    if (a) {
        remove(a);
        win.hide_border();
        win.update_border_layout();
        a.ease(p);
    }
}
function remove(a) {
    a.remove_all_transitions();
}
function is_tweening(a) {
    return a.get_transition('x')
        || a.get_transition('y')
        || a.get_transition('scale-x')
        || a.get_transition('scale-y');
}
function on_window_tweened(win, callback) {
    win.update_border_layout();
    win.hide_border();
    const tween_timeout = 20;
    return GLib.timeout_add(GLib.PRIORITY_DEFAULT, tween_timeout, () => {
        const actor = win.meta.get_compositor_private();
        if (actor) {
            if (is_tweening(actor)) {
                return true;
            }
            else {
                remove(actor);
                callback();
            }
        }
        return false;
    });
}
function on_actor_tweened(actor, callback) {
    return GLib.timeout_add(GLib.PRIORITY_DEFAULT, 100, () => {
        if (is_tweening(actor))
            return true;
        callback();
        return false;
    });
}
