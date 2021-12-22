const Me = imports.misc.extensionUtils.getCurrentExtension();
const Ecs = Me.imports.ecs;
const a = Me.imports.arena;
const utils = Me.imports.utils;
const Arena = a.Arena;
const { St } = imports.gi;
const ACTIVE_TAB = 'pop-shell-tab pop-shell-tab-active';
const INACTIVE_TAB = 'pop-shell-tab pop-shell-tab-inactive';
const URGENT_TAB = 'pop-shell-tab pop-shell-tab-urgent';
const INACTIVE_TAB_STYLE = '#9B8E8A';
var TAB_HEIGHT = 24;
function stack_widgets_new() {
    var _a;
    let tabs = new St.BoxLayout({
        style_class: 'pop-shell-stack',
        x_expand: true
    });
    (_a = tabs.get_layout_manager()) === null || _a === void 0 ? void 0 : _a.set_homogeneous(true);
    return { tabs };
}
var Stack = class Stack {
    constructor(ext, active, workspace, monitor) {
        this.widgets = null;
        this.active_id = 0;
        this.tabs = new Array();
        this.buttons = new Arena();
        this.tabs_height = TAB_HEIGHT;
        this.stack_rect = { width: 0, height: 0, x: 0, y: 0 };
        this.active_signals = null;
        this.rect = { width: 0, height: 0, x: 0, y: 0 };
        this.restacker = global.display.connect('restacked', () => this.restack());
        this.ext = ext;
        this.active = active;
        this.monitor = monitor;
        this.workspace = workspace;
        this.tabs_height = TAB_HEIGHT * this.ext.dpi;
        this.widgets = stack_widgets_new();
        global.window_group.add_child(this.widgets.tabs);
        this.reposition();
        this.tabs_destroy = this.widgets.tabs.connect('destroy', () => this.recreate_widgets());
    }
    add(window) {
        if (!this.widgets)
            return;
        const entity = window.entity;
        const label = window.title();
        const active = Ecs.entity_eq(entity, this.active);
        const button = new St.Button({
            label,
            x_expand: true,
            style_class: active ? ACTIVE_TAB : INACTIVE_TAB
        });
        const id = this.buttons.insert(button);
        let tab = { active, entity, signals: [], button: id, button_signal: null };
        let comp = this.tabs.length;
        this.bind_hint_events(tab);
        this.tabs.push(tab);
        this.watch_signals(comp, id, window);
        this.widgets.tabs.add(button);
    }
    auto_activate() {
        if (this.tabs.length === 0)
            return null;
        if (this.tabs.length <= this.active_id) {
            this.active_id = this.tabs.length - 1;
        }
        const c = this.tabs[this.active_id];
        this.activate(c.entity);
        return c.entity;
    }
    activate(entity) {
        const permitted = this.permitted_to_show();
        if (this.widgets)
            this.widgets.tabs.visible = permitted;
        this.reset_visibility(permitted);
        const win = this.ext.windows.get(entity);
        if (!win)
            return;
        this.active_connect(win.meta, entity);
        let id = 0;
        for (const component of this.tabs) {
            let name;
            this.window_exec(id, component.entity, (window) => {
                const actor = window.meta.get_compositor_private();
                if (Ecs.entity_eq(entity, component.entity)) {
                    this.active_id = id;
                    component.active = true;
                    name = ACTIVE_TAB;
                    if (actor)
                        actor.show();
                }
                else {
                    component.active = false;
                    name = INACTIVE_TAB;
                    if (actor)
                        actor.hide();
                }
                let button = this.buttons.get(component.button);
                if (button) {
                    button.set_style_class_name(name);
                    let tab_color = '';
                    if (component.active) {
                        let settings = this.ext.settings;
                        let color_value = settings.hint_color_rgba();
                        tab_color = `background: ${color_value}; color: ${utils.is_dark(color_value) ? 'white' : 'black'}`;
                    }
                    else {
                        tab_color = `background: ${INACTIVE_TAB_STYLE}`;
                    }
                    button.set_style(tab_color);
                }
            });
            id += 1;
        }
        this.reset_visibility(permitted);
    }
    active_connect(window, active) {
        this.active_disconnect();
        this.active = active;
        this.active_reconnect(window);
    }
    active_reconnect(window) {
        const on_window_changed = () => this.on_grab(() => {
            const window = this.ext.windows.get(this.active);
            if (window) {
                this.update_positions(window.meta.get_frame_rect());
                this.window_changed();
            }
            else {
                this.active_disconnect();
            }
        });
        this.active_signals = [
            window.connect('size-changed', on_window_changed),
            window.connect('position-changed', on_window_changed)
        ];
    }
    active_disconnect() {
        const active_meta = this.active_meta();
        if (this.active_signals && active_meta) {
            for (const s of this.active_signals)
                active_meta.disconnect(s);
        }
        this.active_signals = null;
    }
    active_meta() {
        var _a;
        return (_a = this.ext.windows.get(this.active)) === null || _a === void 0 ? void 0 : _a.meta;
    }
    bind_hint_events(tab) {
        let settings = this.ext.settings;
        let button = this.buttons.get(tab.button);
        if (button) {
            let change_id = settings.ext.connect('changed', (_, key) => {
                if (key === 'hint-color-rgba') {
                    this.change_tab_color(tab);
                }
                return false;
            });
            button.connect('destroy', () => { settings.ext.disconnect(change_id); });
        }
        this.change_tab_color(tab);
    }
    change_tab_color(tab) {
        let settings = this.ext.settings;
        let button = this.buttons.get(tab.button);
        if (button) {
            let tab_color = '';
            if (Ecs.entity_eq(tab.entity, this.active)) {
                let color_value = settings.hint_color_rgba();
                tab_color = `background: ${color_value}; color: ${utils.is_dark(color_value) ? 'white' : 'black'}`;
            }
            else {
                tab_color = `background: ${INACTIVE_TAB_STYLE}`;
            }
            button.set_style(tab_color);
        }
    }
    clear() {
        var _a;
        this.active_disconnect();
        for (const c of this.tabs.splice(0))
            this.tab_disconnect(c);
        (_a = this.widgets) === null || _a === void 0 ? void 0 : _a.tabs.destroy_all_children();
        this.buttons.truncate(0);
    }
    tab_disconnect(c) {
        var _a;
        const window = this.ext.windows.get(c.entity);
        if (window) {
            for (const s of c.signals)
                window.meta.disconnect(s);
            if (this.workspace === this.ext.active_workspace())
                (_a = window.meta.get_compositor_private()) === null || _a === void 0 ? void 0 : _a.show();
        }
        c.signals = [];
        if (c.button_signal) {
            const b = this.buttons.get(c.button);
            if (b) {
                b.disconnect(c.button_signal);
                c.button_signal = null;
            }
        }
    }
    deactivate(w) {
        for (const c of this.tabs)
            if (Ecs.entity_eq(c.entity, w.entity)) {
                this.tab_disconnect(c);
            }
        if (this.active_signals && Ecs.entity_eq(this.active, w.entity)) {
            this.active_disconnect();
        }
    }
    destroy() {
        var _a;
        global.display.disconnect(this.restacker);
        this.active_disconnect();
        for (const c of this.tabs) {
            this.tab_disconnect(c);
            if (this.workspace === this.ext.active_workspace()) {
                const win = this.ext.windows.get(c.entity);
                if (win) {
                    (_a = win.meta.get_compositor_private()) === null || _a === void 0 ? void 0 : _a.show();
                    win.stack = null;
                }
            }
        }
        for (const b of this.buttons.values()) {
            try {
                b.destroy();
            }
            catch (e) {
            }
        }
        if (this.widgets) {
            const tabs = this.widgets.tabs;
            this.widgets = null;
            tabs.destroy();
        }
    }
    on_grab(or) {
        var _a;
        if (this.ext.grab_op !== null) {
            if (Ecs.entity_eq(this.ext.grab_op.entity, this.active)) {
                if (this.widgets) {
                    const parent = this.widgets.tabs.get_parent();
                    const actor = (_a = this.active_meta()) === null || _a === void 0 ? void 0 : _a.get_compositor_private();
                    if (actor && parent) {
                        parent.set_child_below_sibling(this.widgets.tabs, actor);
                    }
                }
                return;
            }
        }
        or();
    }
    recreate_widgets() {
        if (this.widgets !== null) {
            this.widgets.tabs.disconnect(this.tabs_destroy);
            this.widgets = stack_widgets_new();
            global.window_group.add_child(this.widgets.tabs);
            this.tabs_destroy = this.widgets.tabs.connect('destroy', () => this.recreate_widgets());
            this.active_disconnect();
            for (const c of this.tabs.splice(0)) {
                this.tab_disconnect(c);
                const window = this.ext.windows.get(c.entity);
                if (window)
                    this.add(window);
            }
            this.update_positions(this.rect);
            this.restack();
            const window = this.ext.windows.get(this.active);
            if (!window)
                return;
            this.active_reconnect(window.meta);
        }
    }
    remove_by_pos(idx) {
        const c = this.tabs[idx];
        if (c)
            this.remove_tab_component(c, idx);
    }
    remove_tab_component(c, idx) {
        if (!this.widgets)
            return;
        this.tab_disconnect(c);
        const b = this.buttons.get(c.button);
        if (b) {
            this.widgets.tabs.remove_child(b);
            b.destroy();
            this.buttons.remove(c.button);
        }
        this.tabs.splice(idx, 1);
    }
    remove_tab(entity) {
        if (!this.widgets)
            return null;
        let idx = 0;
        for (const c of this.tabs) {
            if (Ecs.entity_eq(c.entity, entity)) {
                this.remove_tab_component(c, idx);
                return idx;
            }
            idx += 1;
        }
        return null;
    }
    replace(window) {
        var _a;
        if (!this.widgets)
            return;
        const c = this.tabs[this.active_id], actor = window.meta.get_compositor_private();
        if (c && actor) {
            this.tab_disconnect(c);
            if (Ecs.entity_eq(window.entity, this.active)) {
                this.active_connect(window.meta, window.entity);
                actor.show();
            }
            else {
                actor.hide();
            }
            this.watch_signals(this.active_id, c.button, window);
            (_a = this.buttons.get(c.button)) === null || _a === void 0 ? void 0 : _a.set_label(window.title());
            this.activate(window.entity);
        }
    }
    reposition() {
        if (!this.widgets)
            return;
        const window = this.ext.windows.get(this.active);
        if (!window)
            return;
        const actor = window.meta.get_compositor_private();
        if (!actor) {
            this.active_disconnect();
            return;
        }
        actor.show();
        const parent = actor.get_parent();
        if (!parent) {
            return;
        }
        const stack_parent = this.widgets.tabs.get_parent();
        if (stack_parent) {
            stack_parent.remove_child(this.widgets.tabs);
        }
        parent.add_child(this.widgets.tabs);
        if (!window.meta.is_fullscreen() && !window.is_maximized() && !this.ext.maximized_on_active_display()) {
            parent.set_child_above_sibling(this.widgets.tabs, actor);
        }
        else {
            parent.set_child_below_sibling(this.widgets.tabs, actor);
        }
    }
    permitted_to_show(workspace) {
        const active_workspace = workspace !== null && workspace !== void 0 ? workspace : global.workspace_manager.get_active_workspace_index();
        const primary = global.display.get_primary_monitor();
        const only_primary = this.ext.settings.workspaces_only_on_primary();
        return active_workspace === this.workspace
            || (only_primary && this.monitor != primary);
    }
    reset_visibility(permitted) {
        let idx = 0;
        for (const c of this.tabs) {
            this.actor_exec(idx, c.entity, (actor) => {
                if (permitted && this.active_id === idx) {
                    actor.show();
                    return;
                }
                actor.hide();
            });
            idx += 1;
        }
    }
    restack() {
        this.on_grab(() => {
            if (!this.widgets)
                return;
            const permitted = this.permitted_to_show();
            this.widgets.tabs.visible = permitted;
            if (permitted)
                this.reposition();
            this.reset_visibility(permitted);
        });
    }
    set_visible(visible) {
        if (!this.widgets)
            return;
        this.widgets.tabs.visible = visible;
        if (visible) {
            this.widgets.tabs.show();
        }
        else {
            this.widgets.tabs.hide();
        }
    }
    update_positions(rect) {
        if (!this.widgets)
            return;
        this.rect = rect;
        this.tabs_height = TAB_HEIGHT * this.ext.dpi;
        this.stack_rect = {
            x: rect.x,
            y: rect.y - this.tabs_height,
            width: rect.width,
            height: this.tabs_height + rect.height,
        };
        this.widgets.tabs.x = rect.x;
        this.widgets.tabs.y = this.stack_rect.y;
        this.widgets.tabs.height = this.tabs_height;
        this.widgets.tabs.width = rect.width;
    }
    watch_signals(comp, button, window) {
        const entity = window.entity;
        const widget = this.buttons.get(button);
        if (!widget)
            return;
        const c = this.tabs[comp];
        if (c.button_signal)
            widget.disconnect(c.button_signal);
        c.button_signal = widget.connect('clicked', () => {
            this.activate(entity);
            this.window_exec(comp, entity, (window) => {
                var _a;
                const actor = window.meta.get_compositor_private();
                if (actor) {
                    actor.show();
                    window.activate(false);
                    this.reposition();
                    for (const comp of this.tabs) {
                        (_a = this.buttons.get(comp.button)) === null || _a === void 0 ? void 0 : _a.set_style_class_name(INACTIVE_TAB);
                    }
                    widget.set_style_class_name(ACTIVE_TAB);
                }
            });
        });
        if (this.tabs[comp].signals) {
            for (const c of this.tabs[comp].signals)
                window.meta.disconnect(c);
        }
        this.tabs[comp].signals = [
            window.meta.connect('notify::title', () => {
                this.window_exec(comp, entity, (window) => {
                    var _a;
                    (_a = this.buttons.get(button)) === null || _a === void 0 ? void 0 : _a.set_label(window.title());
                });
            }),
            window.meta.connect('notify::urgent', () => {
                this.window_exec(comp, entity, (window) => {
                    var _a;
                    if (!window.meta.has_focus()) {
                        (_a = this.buttons.get(button)) === null || _a === void 0 ? void 0 : _a.set_style_class_name(URGENT_TAB);
                    }
                });
            })
        ];
    }
    window_changed() {
        this.ext.show_border_on_focused();
    }
    actor_exec(comp, entity, func) {
        this.window_exec(comp, entity, (window) => {
            func(window.meta.get_compositor_private());
        });
    }
    window_exec(comp, entity, func) {
        const window = this.ext.windows.get(entity);
        if (window && window.actor_exists()) {
            func(window);
        }
        else {
            const tab = this.tabs[comp];
            if (tab)
                this.tab_disconnect(tab);
        }
    }
}
