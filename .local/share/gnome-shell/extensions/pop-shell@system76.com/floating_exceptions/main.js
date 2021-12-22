#!/usr/bin/gjs
imports.gi.versions.Gtk = '3.0';
const { Gio, GLib, Gtk, Pango } = imports.gi;
const SCRIPT_DIR = GLib.path_get_dirname(new Error().stack.split(':')[0].slice(1));
imports.searchPath.push(SCRIPT_DIR);
const { DEFAULT_FLOAT_RULES, Config } = imports.config;
const WM_CLASS_ID = "pop-shell-exceptions";
var ViewNum;
(function (ViewNum) {
    ViewNum[ViewNum["MainView"] = 0] = "MainView";
    ViewNum[ViewNum["Exceptions"] = 1] = "Exceptions";
})(ViewNum || (ViewNum = {}));
function exceptions_button() {
    let title = Gtk.Label.new("System Exceptions");
    title.set_xalign(0);
    let description = Gtk.Label.new("Updated based on validated user reports.");
    description.set_xalign(0);
    description.get_style_context().add_class("dim-label");
    let icon = Gtk.Image.new_from_icon_name("go-next-symbolic", Gtk.IconSize.BUTTON);
    icon.set_hexpand(true);
    icon.set_halign(Gtk.Align.END);
    let layout = Gtk.Grid.new();
    layout.set_row_spacing(4);
    layout.set_border_width(12);
    layout.attach(title, 0, 0, 1, 1);
    layout.attach(description, 0, 1, 1, 1);
    layout.attach(icon, 1, 0, 1, 2);
    let button = Gtk.Button.new();
    button.relief = Gtk.ReliefStyle.NONE;
    button.add(layout);
    return button;
}
var MainView = class MainView {
    constructor() {
        this.callback = () => { };
        let select = Gtk.Button.new_with_label("Select");
        select.set_halign(Gtk.Align.CENTER);
        select.connect("clicked", () => this.callback({ tag: 0 }));
        select.set_margin_bottom(12);
        let exceptions = exceptions_button();
        exceptions.connect("clicked", () => this.callback({ tag: 1, view: ViewNum.Exceptions }));
        this.list = Gtk.ListBox.new();
        this.list.set_selection_mode(Gtk.SelectionMode.NONE);
        this.list.set_header_func(list_header_func);
        this.list.add(exceptions);
        let scroller = new Gtk.ScrolledWindow();
        scroller.hscrollbar_policy = Gtk.PolicyType.NEVER;
        scroller.set_propagate_natural_width(true);
        scroller.set_propagate_natural_height(true);
        scroller.add(this.list);
        let list_frame = Gtk.Frame.new(null);
        list_frame.add(scroller);
        let desc = new Gtk.Label({ label: "Add exceptions by selecting currently running applications and windows." });
        desc.set_line_wrap(true);
        desc.set_halign(Gtk.Align.CENTER);
        desc.set_justify(Gtk.Justification.CENTER);
        desc.set_max_width_chars(55);
        desc.set_margin_top(12);
        this.widget = Gtk.Box.new(Gtk.Orientation.VERTICAL, 24);
        this.widget.add(desc);
        this.widget.add(select);
        this.widget.add(list_frame);
    }
    add_rule(wmclass, wmtitle) {
        let label = Gtk.Label.new(wmtitle === undefined ? wmclass : `${wmclass} / ${wmtitle}`);
        label.set_xalign(0);
        label.set_hexpand(true);
        label.set_ellipsize(Pango.EllipsizeMode.END);
        let button = Gtk.Button.new_from_icon_name("edit-delete", Gtk.IconSize.BUTTON);
        button.set_valign(Gtk.Align.CENTER);
        let widget = Gtk.Box.new(Gtk.Orientation.HORIZONTAL, 24);
        widget.add(label);
        widget.add(button);
        widget.set_border_width(12);
        widget.set_margin_start(12);
        widget.show_all();
        button.connect("clicked", () => {
            widget.destroy();
            this.callback({ tag: 3, wmclass, wmtitle });
        });
        this.list.add(widget);
    }
}
var ExceptionsView = class ExceptionsView {
    constructor() {
        this.callback = () => { };
        this.exceptions = Gtk.ListBox.new();
        let desc_title = Gtk.Label.new("<b>System Exceptions</b>");
        desc_title.set_use_markup(true);
        desc_title.set_xalign(0);
        let desc_desc = Gtk.Label.new("Updated based on validated user reports.");
        desc_desc.set_xalign(0);
        desc_desc.get_style_context().add_class("dim-label");
        desc_desc.set_margin_bottom(6);
        let scroller = new Gtk.ScrolledWindow();
        scroller.hscrollbar_policy = Gtk.PolicyType.NEVER;
        scroller.set_propagate_natural_width(true);
        scroller.set_propagate_natural_height(true);
        scroller.add(this.exceptions);
        let exceptions_frame = Gtk.Frame.new(null);
        exceptions_frame.add(scroller);
        this.exceptions.set_selection_mode(Gtk.SelectionMode.NONE);
        this.exceptions.set_header_func(list_header_func);
        this.widget = Gtk.Box.new(Gtk.Orientation.VERTICAL, 6);
        this.widget.add(desc_title);
        this.widget.add(desc_desc);
        this.widget.add(exceptions_frame);
    }
    add_rule(wmclass, wmtitle, enabled) {
        let label = Gtk.Label.new(wmtitle === undefined ? wmclass : `${wmclass} / ${wmtitle}`);
        label.set_xalign(0);
        label.set_hexpand(true);
        label.set_ellipsize(Pango.EllipsizeMode.END);
        let button = Gtk.Switch.new();
        button.set_valign(Gtk.Align.CENTER);
        button.set_state(enabled);
        button.connect('notify::state', () => {
            this.callback({ tag: 2, wmclass, wmtitle, enable: button.get_state() });
        });
        let widget = Gtk.Box.new(Gtk.Orientation.HORIZONTAL, 24);
        widget.add(label);
        widget.add(button);
        widget.show_all();
        widget.set_border_width(12);
        this.exceptions.add(widget);
    }
}
class App {
    constructor() {
        var _a, _b, _c, _d;
        this.main_view = new MainView();
        this.exceptions_view = new ExceptionsView();
        this.stack = Gtk.Stack.new();
        this.config = new Config();
        this.stack.set_border_width(16);
        this.stack.add(this.main_view.widget);
        this.stack.add(this.exceptions_view.widget);
        let back = Gtk.Button.new_from_icon_name("go-previous-symbolic", Gtk.IconSize.BUTTON);
        const TITLE = "Floating Window Exceptions";
        let win = new Gtk.Dialog({ use_header_bar: true });
        let headerbar = win.get_header_bar();
        headerbar.set_show_close_button(true);
        headerbar.set_title(TITLE);
        headerbar.pack_start(back);
        Gtk.Window.set_default_icon_name("application-default");
        win.set_wmclass(WM_CLASS_ID, TITLE);
        win.set_default_size(550, 700);
        win.get_content_area().add(this.stack);
        win.show_all();
        win.connect('delete-event', () => win.close());
        back.hide();
        this.config.reload();
        for (const value of DEFAULT_FLOAT_RULES.values()) {
            let wmtitle = (_a = value.title) !== null && _a !== void 0 ? _a : undefined;
            let wmclass = (_b = value.class) !== null && _b !== void 0 ? _b : undefined;
            let disabled = this.config.rule_disabled({ class: wmclass, title: wmtitle });
            this.exceptions_view.add_rule(wmclass, wmtitle, !disabled);
        }
        for (const value of Array.from(this.config.float)) {
            let wmtitle = (_c = value.title) !== null && _c !== void 0 ? _c : undefined;
            let wmclass = (_d = value.class) !== null && _d !== void 0 ? _d : undefined;
            if (!value.disabled)
                this.main_view.add_rule(wmclass, wmtitle);
        }
        let event_handler = (event) => {
            switch (event.tag) {
                case 0:
                    println("SELECT");
                    Gtk.main_quit();
                    break;
                case 1:
                    switch (event.view) {
                        case ViewNum.MainView:
                            this.stack.set_visible_child(this.main_view.widget);
                            back.hide();
                            break;
                        case ViewNum.Exceptions:
                            this.stack.set_visible_child(this.exceptions_view.widget);
                            back.show();
                            break;
                    }
                    break;
                case 2:
                    log(`toggling exception ${event.enable}`);
                    this.config.toggle_system_exception(event.wmclass, event.wmtitle, !event.enable);
                    println("MODIFIED");
                    break;
                case 3:
                    log(`removing exception`);
                    this.config.remove_user_exception(event.wmclass, event.wmtitle);
                    println("MODIFIED");
                    break;
            }
        };
        this.main_view.callback = event_handler;
        this.exceptions_view.callback = event_handler;
        back.connect("clicked", () => event_handler({ tag: 1, view: ViewNum.MainView }));
    }
}
function list_header_func(row, before) {
    if (before) {
        row.set_header(Gtk.Separator.new(Gtk.Orientation.HORIZONTAL));
    }
}
const STDOUT = new Gio.DataOutputStream({
    base_stream: new Gio.UnixOutputStream({ fd: 1 })
});
function println(message) {
    STDOUT.put_string(message + "\n", null);
}
function main() {
    GLib.set_prgname(WM_CLASS_ID);
    GLib.set_application_name("Pop Shell Floating Window Exceptions");
    Gtk.init(null);
    new App();
    Gtk.main();
}
main();
