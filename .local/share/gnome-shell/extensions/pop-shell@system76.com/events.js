const Me = imports.misc.extensionUtils.getCurrentExtension();
var GlobalEvent;
(function (GlobalEvent) {
    GlobalEvent[GlobalEvent["GtkShellChanged"] = 0] = "GtkShellChanged";
    GlobalEvent[GlobalEvent["GtkThemeChanged"] = 1] = "GtkThemeChanged";
    GlobalEvent[GlobalEvent["MonitorsChanged"] = 2] = "MonitorsChanged";
    GlobalEvent[GlobalEvent["OverviewShown"] = 3] = "OverviewShown";
    GlobalEvent[GlobalEvent["OverviewHidden"] = 4] = "OverviewHidden";
})(GlobalEvent || (GlobalEvent = {}));
var WindowEvent;
(function (WindowEvent) {
    WindowEvent[WindowEvent["Size"] = 0] = "Size";
    WindowEvent[WindowEvent["Workspace"] = 1] = "Workspace";
    WindowEvent[WindowEvent["Minimize"] = 2] = "Minimize";
    WindowEvent[WindowEvent["Maximize"] = 3] = "Maximize";
    WindowEvent[WindowEvent["Fullscreen"] = 4] = "Fullscreen";
})(WindowEvent || (WindowEvent = {}));
function global(event) {
    return { tag: 4, event };
}
function window_move(ext, window, rect) {
    ext.movements.insert(window.entity, rect);
    return { tag: 2, window, kind: { tag: 1 } };
}
function window_event(window, event) {
    return { tag: 2, window, kind: { tag: 2, event } };
}
