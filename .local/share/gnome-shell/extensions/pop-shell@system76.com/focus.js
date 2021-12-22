const Me = imports.misc.extensionUtils.getCurrentExtension();
const Geom = Me.imports.geom;
var FocusSelector = class FocusSelector {
    select(ext, direction, window) {
        window = window !== null && window !== void 0 ? window : ext.focus_window();
        if (window) {
            let window_list = ext.active_window_list();
            return select(direction, window, window_list);
        }
        return null;
    }
    down(ext, window) {
        return this.select(ext, window_down, window);
    }
    left(ext, window) {
        return this.select(ext, window_left, window);
    }
    right(ext, window) {
        return this.select(ext, window_right, window);
    }
    up(ext, window) {
        return this.select(ext, window_up, window);
    }
}
function select(windows, focused, window_list) {
    const array = windows(focused, window_list);
    return array.length > 0 ? array[0] : null;
}
function window_down(focused, windows) {
    return windows
        .filter((win) => !win.meta.minimized && win.meta.get_frame_rect().y > focused.meta.get_frame_rect().y)
        .sort((a, b) => Geom.downward_distance(a.meta, focused.meta) - Geom.downward_distance(b.meta, focused.meta));
}
function window_left(focused, windows) {
    return windows
        .filter((win) => !win.meta.minimized && win.meta.get_frame_rect().x < focused.meta.get_frame_rect().x)
        .sort((a, b) => Geom.leftward_distance(a.meta, focused.meta) - Geom.leftward_distance(b.meta, focused.meta));
}
function window_right(focused, windows) {
    return windows
        .filter((win) => !win.meta.minimized && win.meta.get_frame_rect().x > focused.meta.get_frame_rect().x)
        .sort((a, b) => Geom.rightward_distance(a.meta, focused.meta) - Geom.rightward_distance(b.meta, focused.meta));
}
function window_up(focused, windows) {
    return windows
        .filter((win) => !win.meta.minimized && win.meta.get_frame_rect().y < focused.meta.get_frame_rect().y)
        .sort((a, b) => Geom.upward_distance(a.meta, focused.meta) - Geom.upward_distance(b.meta, focused.meta));
}
