const Me = imports.misc.extensionUtils.getCurrentExtension();
const { wm } = imports.ui.main;
const { Meta, Shell } = imports.gi;
var Keybindings = class Keybindings {
    constructor(ext) {
        this.ext = ext;
        this.global = {
            "activate-launcher": () => {
                ext.tiler.exit(ext);
                ext.window_search.load_desktop_files();
                ext.window_search.open(ext);
            },
            "tile-enter": () => ext.tiler.enter(ext)
        };
        this.window_focus = {
            "focus-left": () => ext.focus_left(),
            "focus-down": () => ext.focus_down(),
            "focus-up": () => ext.focus_up(),
            "focus-right": () => ext.focus_right(),
            "tile-orientation": () => {
                var _a;
                const win = ext.focus_window();
                if (win)
                    (_a = ext.auto_tiler) === null || _a === void 0 ? void 0 : _a.toggle_orientation(ext, win);
            },
            "toggle-floating": () => { var _a; return (_a = ext.auto_tiler) === null || _a === void 0 ? void 0 : _a.toggle_floating(ext); },
            "toggle-tiling": () => ext.toggle_tiling(),
            "toggle-stacking-global": () => { var _a; return (_a = ext.auto_tiler) === null || _a === void 0 ? void 0 : _a.toggle_stacking(ext); },
            "pop-monitor-left": () => ext.move_monitor(Meta.DisplayDirection.LEFT),
            "pop-monitor-right": () => ext.move_monitor(Meta.DisplayDirection.RIGHT),
            "pop-monitor-up": () => ext.move_monitor(Meta.DisplayDirection.UP),
            "pop-monitor-down": () => ext.move_monitor(Meta.DisplayDirection.DOWN),
            "pop-workspace-up": () => ext.move_workspace(Meta.DisplayDirection.UP),
            "pop-workspace-down": () => ext.move_workspace(Meta.DisplayDirection.DOWN)
        };
    }
    enable(keybindings) {
        for (const name in keybindings) {
            wm.addKeybinding(name, this.ext.settings.ext, Meta.KeyBindingFlags.NONE, Shell.ActionMode.NORMAL, keybindings[name]);
        }
        return this;
    }
    disable(keybindings) {
        for (const name in keybindings) {
            wm.removeKeybinding(name);
        }
        return this;
    }
}
