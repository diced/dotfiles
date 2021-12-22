const { Gio, GLib } = imports.gi;
const CONF_DIR = GLib.get_user_config_dir() + "/pop-shell";
var CONF_FILE = CONF_DIR + "/config.json";
var DEFAULT_FLOAT_RULES = [
    { class: "Floating Window Exceptions" },
    { class: "Authy Desktop", },
    { class: "Enpass", title: "Enpass Assistant" },
    { class: "Zotero", title: "Quick Format Citation" },
    { class: "Com.github.donadigo.eddy", },
    { class: "Conky", },
    { class: "Guake", },
    { class: "Com.github.amezin.ddterm", },
    { class: "gnome-screenshot", },
    { class: "jetbrains-toolbox", },
    { class: "jetbrains-webstorm", title: "License Activation" },
    { class: "jetbrains-webstorm", title: "Customize WebStorm" },
    { class: "jetbrains-webstorm", title: "Welcome to WebStorm" },
    { class: "KotatogramDesktop", title: "Media viewer" },
    { class: "Steam", title: "^((?!Steam).)*$" },
    { class: "TelegramDesktop", title: "Media viewer" },
    { class: "tilda", },
    { class: "Solaar", },
    { class: "system76-driver", },
    { class: "zoom", },
    { class: "Gnome-terminal", title: "Preferences – General" },
    { class: "Gjs", title: "Settings" },
    { class: "Io.elementary.sideload", },
    { class: "Gnome-initial-setup" },
    { class: "Steam", title: "^.*(Guard|Login).*" },
    { class: "krunner" },
    { class: "ibus-.*" },
    { class: "gjs" }
];
var SKIPTASKBAR_EXCEPTIONS = [
    { class: "Conky", },
    { class: "Guake", },
    { class: "Com.github.amezin.ddterm", },
    { class: "plank", },
];
;
var DefaultPointerPosition;
(function (DefaultPointerPosition) {
    DefaultPointerPosition["TopLeft"] = "TOP_LEFT";
    DefaultPointerPosition["TopRight"] = "TOP_RIGHT";
    DefaultPointerPosition["BottomLeft"] = "BOTTOM_LEFT";
    DefaultPointerPosition["BottomRight"] = "BOTTOM_RIGHT";
    DefaultPointerPosition["Center"] = "CENTER";
})(DefaultPointerPosition || (DefaultPointerPosition = {}));
;
var Config = class Config {
    constructor() {
        this.float = [];
        this.skiptaskbarhidden = [];
        this.log_on_focus = false;
        this.move_pointer_on_switch = false;
        this.default_pointer_position = DefaultPointerPosition.TopLeft;
    }
    add_app_exception(wmclass) {
        for (const r of this.float) {
            if (r.class === wmclass && r.title === undefined)
                return;
        }
        this.float.push({ class: wmclass });
        this.sync_to_disk();
    }
    add_window_exception(wmclass, title) {
        for (const r of this.float) {
            if (r.class === wmclass && r.title === title)
                return;
        }
        this.float.push({ class: wmclass, title });
        this.sync_to_disk();
    }
    window_shall_float(wclass, title) {
        for (const rule of this.float.concat(DEFAULT_FLOAT_RULES)) {
            if (rule.class) {
                if (!new RegExp(rule.class, 'i').test(wclass)) {
                    continue;
                }
            }
            if (rule.title) {
                if (!new RegExp(rule.title, 'i').test(title)) {
                    continue;
                }
            }
            return rule.disabled ? false : true;
        }
        return false;
    }
    skiptaskbar_shall_hide(meta_window) {
        let wmclass = meta_window.get_wm_class();
        let wmtitle = meta_window.get_title();
        if (!meta_window.is_skip_taskbar())
            return false;
        for (const rule of this.skiptaskbarhidden.concat(SKIPTASKBAR_EXCEPTIONS)) {
            if (rule.class) {
                if (!new RegExp(rule.class, 'i').test(wmclass)) {
                    continue;
                }
            }
            if (rule.title) {
                if (!new RegExp(rule.title, 'i').test(wmtitle)) {
                    continue;
                }
            }
            return rule.disabled ? false : true;
        }
        return false;
    }
    reload() {
        const conf = Config.from_config();
        if (conf.tag === 0) {
            let c = conf.value;
            this.float = c.float;
            this.log_on_focus = c.log_on_focus;
            this.default_pointer_position = c.default_pointer_position;
            this.move_pointer_on_switch = c.move_pointer_on_switch;
        }
        else {
            log(`error loading conf: ${conf.why}`);
        }
    }
    rule_disabled(rule) {
        for (const value of this.float.values()) {
            if (value.disabled && rule.class === value.class && value.title === rule.title) {
                return true;
            }
        }
        return false;
    }
    to_json() {
        return JSON.stringify(this, set_to_json, 2);
    }
    toggle_system_exception(wmclass, wmtitle, disabled) {
        if (disabled) {
            for (const value of DEFAULT_FLOAT_RULES) {
                if (value.class === wmclass && value.title === wmtitle) {
                    value.disabled = disabled;
                    this.float.push(value);
                    this.sync_to_disk();
                    return;
                }
            }
        }
        let index = 0;
        let found = false;
        for (const value of this.float) {
            if (value.class === wmclass && value.title === wmtitle) {
                found = true;
                break;
            }
            index += 1;
        }
        if (found)
            swap_remove(this.float, index);
        this.sync_to_disk();
    }
    remove_user_exception(wmclass, wmtitle) {
        let index = 0;
        let found = new Array();
        for (const value of this.float.values()) {
            if (value.class === wmclass && value.title === wmtitle) {
                found.push(index);
            }
            index += 1;
        }
        if (found.length !== 0) {
            for (const idx of found)
                swap_remove(this.float, idx);
            this.sync_to_disk();
        }
    }
    static from_json(json) {
        try {
            return JSON.parse(json);
        }
        catch (error) {
            return new Config();
        }
    }
    static from_config() {
        const stream = Config.read();
        if (stream.tag === 1)
            return stream;
        let value = Config.from_json(stream.value);
        return { tag: 0, value };
    }
    static gio_file() {
        try {
            const conf = Gio.File.new_for_path(CONF_FILE);
            if (!conf.query_exists(null)) {
                const dir = Gio.File.new_for_path(CONF_DIR);
                if (!dir.query_exists(null) && !dir.make_directory(null)) {
                    return { tag: 1, why: 'failed to create pop-shell config directory' };
                }
                const example = new Config();
                example.float.push({ class: "pop-shell-example", title: "pop-shell-example" });
                conf.create(Gio.FileCreateFlags.NONE, null)
                    .write_all(JSON.stringify(example, undefined, 2), null);
            }
            return { tag: 0, value: conf };
        }
        catch (why) {
            return { tag: 1, why: `Gio.File I/O error: ${why}` };
        }
    }
    static read() {
        try {
            const file = Config.gio_file();
            if (file.tag === 1)
                return file;
            const [, buffer] = file.value.load_contents(null);
            return { tag: 0, value: imports.byteArray.toString(buffer) };
        }
        catch (why) {
            return { tag: 1, why: `failed to read pop-shell config: ${why}` };
        }
    }
    static write(data) {
        try {
            const file = Config.gio_file();
            if (file.tag === 1)
                return file;
            file.value.replace_contents(data, null, false, Gio.FileCreateFlags.NONE, null);
            return { tag: 0, value: file.value };
        }
        catch (why) {
            return { tag: 1, why: `failed to write to config: ${why}` };
        }
    }
    sync_to_disk() {
        Config.write(this.to_json());
    }
}
function set_to_json(_key, value) {
    if (typeof value === 'object' && value instanceof Set) {
        return [...value];
    }
    return value;
}
function swap_remove(array, index) {
    array[index] = array[array.length - 1];
    return array.pop();
}
