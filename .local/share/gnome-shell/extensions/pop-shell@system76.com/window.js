const Me = imports.misc.extensionUtils.getCurrentExtension();
const Config = Me.imports.config;
const lib = Me.imports.lib;
const log = Me.imports.log;
const once_cell = Me.imports.once_cell;
const Rect = Me.imports.rectangle;
const Tags = Me.imports.tags;
const Tweener = Me.imports.tweener;
const utils = Me.imports.utils;
const xprop = Me.imports.xprop;
const { DefaultPointerPosition } = Config;
const { Gdk, Meta, Shell, St, GLib } = imports.gi;
const { OnceCell } = once_cell;
var window_tracker = Shell.WindowTracker.get_default();
const WM_TITLE_BLACKLIST = [
    'Firefox',
    'Nightly',
    'Tor Browser'
];
var RESTACK_STATE;
(function (RESTACK_STATE) {
    RESTACK_STATE[RESTACK_STATE["RAISED"] = 0] = "RAISED";
    RESTACK_STATE[RESTACK_STATE["WORKSPACE_CHANGED"] = 1] = "WORKSPACE_CHANGED";
    RESTACK_STATE[RESTACK_STATE["NORMAL"] = 2] = "NORMAL";
})(RESTACK_STATE || (RESTACK_STATE = {}));
var RESTACK_SPEED;
(function (RESTACK_SPEED) {
    RESTACK_SPEED[RESTACK_SPEED["RAISED"] = 430] = "RAISED";
    RESTACK_SPEED[RESTACK_SPEED["WORKSPACE_CHANGED"] = 300] = "WORKSPACE_CHANGED";
    RESTACK_SPEED[RESTACK_SPEED["NORMAL"] = 200] = "NORMAL";
})(RESTACK_SPEED || (RESTACK_SPEED = {}));
var ShellWindow = class ShellWindow {
    constructor(entity, window, window_app, ext) {
        var _a;
        this.stack = null;
        this.grab = false;
        this.activate_after_move = false;
        this.ignore_detach = false;
        this.reassignment = false;
        this.smart_gapped = false;
        this.border = new St.Bin({ style_class: 'pop-shell-active-hint pop-shell-border-normal' });
        this.prev_rect = null;
        this.was_hidden = false;
        this.extra = {
            normal_hints: new OnceCell(),
            wm_role_: new OnceCell(),
            xid_: new OnceCell()
        };
        this.border_size = 0;
        this.window_app = window_app;
        this.entity = entity;
        this.meta = window;
        this.ext = ext;
        this.known_workspace = this.workspace_id();
        if (this.may_decorate()) {
            if (!window.is_client_decorated()) {
                if (ext.settings.show_title()) {
                    this.decoration_show(ext);
                }
                else {
                    this.decoration_hide(ext);
                }
            }
        }
        this.bind_window_events();
        this.bind_hint_events();
        global.window_group.add_child(this.border);
        this.hide_border();
        this.restack();
        this.update_border_layout();
        if ((_a = this.meta.get_compositor_private()) === null || _a === void 0 ? void 0 : _a.get_stage())
            this.on_style_changed();
    }
    activate(move_mouse = true) {
        activate(move_mouse, this.ext.conf.default_pointer_position, this.meta);
    }
    actor_exists() {
        return this.meta.get_compositor_private() !== null;
    }
    bind_window_events() {
        this.ext.window_signals.get_or(this.entity, () => new Array())
            .push(this.meta.connect('size-changed', () => { this.window_changed(); }), this.meta.connect('position-changed', () => { this.window_changed(); }), this.meta.connect('workspace-changed', () => { this.workspace_changed(); }), this.meta.connect('notify::wm-class', () => { this.wm_class_changed(); }), this.meta.connect('raised', () => { this.window_raised(); }));
    }
    bind_hint_events() {
        let settings = this.ext.settings;
        let change_id = settings.ext.connect('changed', (_, key) => {
            if (this.border) {
                if (key === 'hint-color-rgba') {
                    this.update_hint_colors();
                }
            }
            return false;
        });
        this.border.connect('destroy', () => { settings.ext.disconnect(change_id); });
        this.border.connect('style-changed', () => {
            this.on_style_changed();
        });
        this.update_hint_colors();
    }
    update_hint_colors() {
        let settings = this.ext.settings;
        const color_value = settings.hint_color_rgba();
        if (this.ext.overlay) {
            const gdk = new Gdk.RGBA();
            const overlay_alpha = 0.3;
            const orig_overlay = 'rgba(53, 132, 228, 0.3)';
            gdk.parse(color_value);
            if (utils.is_dark(gdk.to_string())) {
                gdk.parse(orig_overlay);
            }
            gdk.alpha = overlay_alpha;
            this.ext.overlay.set_style(`background: ${gdk.to_string()}`);
        }
        if (this.border)
            this.border.set_style(`border-color: ${color_value}`);
    }
    cmdline() {
        let pid = this.meta.get_pid(), out = null;
        if (-1 === pid)
            return out;
        const path = '/proc/' + pid + '/cmdline';
        if (!utils.exists(path))
            return out;
        const result = utils.read_to_string(path);
        if (result.kind == 1) {
            out = result.value.trim();
        }
        else {
            log.error(`failed to fetch cmdline: ${result.value.format()}`);
        }
        return out;
    }
    decoration(_ext, callback) {
        if (this.may_decorate()) {
            const xid = this.xid();
            if (xid)
                callback(xid);
        }
    }
    decoration_hide(ext) {
        if (this.ignore_decoration())
            return;
        this.was_hidden = true;
        this.decoration(ext, (xid) => xprop.set_hint(xid, xprop.MOTIF_HINTS, xprop.HIDE_FLAGS));
    }
    decoration_show(ext) {
        if (!this.was_hidden)
            return;
        this.decoration(ext, (xid) => xprop.set_hint(xid, xprop.MOTIF_HINTS, xprop.SHOW_FLAGS));
    }
    icon(_ext, size) {
        let icon = this.window_app.create_icon_texture(size);
        if (!icon) {
            icon = new St.Icon({
                icon_name: 'applications-other',
                icon_type: St.IconType.FULLCOLOR,
                icon_size: size
            });
        }
        return icon;
    }
    ignore_decoration() {
        const name = this.meta.get_wm_class();
        if (name === null)
            return true;
        return WM_TITLE_BLACKLIST.findIndex((n) => name.startsWith(n)) !== -1;
    }
    is_maximized() {
        let maximized = this.meta.get_maximized() !== 0;
        return maximized;
    }
    is_max_screen() {
        return this.is_maximized() || this.ext.settings.gap_inner() === 0 || this.smart_gapped;
    }
    is_single_max_screen() {
        const display = this.meta.get_display();
        if (display) {
            let monitor_count = display.get_n_monitors();
            return (this.is_maximized() || this.smart_gapped) && monitor_count == 1;
        }
        return false;
    }
    is_snap_edge() {
        return this.meta.get_maximized() == Meta.MaximizeFlags.VERTICAL;
    }
    is_tilable(ext) {
        let tile_checks = () => {
            let wm_class = this.meta.get_wm_class();
            if (wm_class !== null && wm_class.trim().length === 0) {
                wm_class = this.name(ext);
            }
            const role = this.meta.get_role();
            if (role === "quake")
                return false;
            if (this.meta.get_title() === "Steam") {
                const rect = this.rect();
                const is_dialog = rect.width < 400 && rect.height < 200;
                const is_first_login = rect.width === 432 && rect.height === 438;
                if (is_dialog || is_first_login)
                    return false;
            }
            if (wm_class !== null && ext.conf.window_shall_float(wm_class, this.title())) {
                return ext.contains_tag(this.entity, Tags.ForceTile);
            }
            return this.meta.window_type == Meta.WindowType.NORMAL
                && !this.is_transient()
                && wm_class !== null;
        };
        return !ext.contains_tag(this.entity, Tags.Floating)
            && tile_checks();
    }
    is_transient() {
        return this.meta.get_transient_for() !== null;
    }
    may_decorate() {
        const xid = this.xid();
        return xid ? xprop.may_decorate(xid) : false;
    }
    move(ext, rect, on_complete, animate = true) {
        if ((!this.same_workspace() && this.is_maximized())) {
            return;
        }
        this.hide_border();
        const clone = Rect.Rectangle.from_meta(rect);
        const meta = this.meta;
        const actor = meta.get_compositor_private();
        if (actor) {
            meta.unmaximize(Meta.MaximizeFlags.HORIZONTAL);
            meta.unmaximize(Meta.MaximizeFlags.VERTICAL);
            meta.unmaximize(Meta.MaximizeFlags.HORIZONTAL | Meta.MaximizeFlags.VERTICAL);
            actor.remove_all_transitions();
            const entity_string = String(this.entity);
            ext.movements.insert(this.entity, clone);
            const onComplete = () => {
                ext.register({ tag: 2, window: this, kind: { tag: 1 } });
                if (on_complete)
                    ext.register_fn(on_complete);
                ext.tween_signals.delete(entity_string);
                if (meta.appears_focused) {
                    this.update_border_layout();
                    this.show_border();
                }
            };
            if (animate && ext.animate_windows && !ext.init) {
                const current = meta.get_frame_rect();
                const buffer = meta.get_buffer_rect();
                const dx = current.x - buffer.x;
                const dy = current.y - buffer.y;
                const slot = ext.tween_signals.get(entity_string);
                if (slot !== undefined) {
                    const [signal, callback] = slot;
                    Tweener.remove(actor);
                    utils.source_remove(signal);
                    callback();
                }
                const x = clone.x - dx;
                const y = clone.y - dy;
                const duration = ext.tiler.moving ? 49 : 149;
                Tweener.add(this, { x, y, duration, mode: null });
                ext.tween_signals.set(entity_string, [
                    Tweener.on_window_tweened(this, onComplete),
                    onComplete
                ]);
            }
            else {
                onComplete();
            }
        }
    }
    name(ext) {
        return ext.names.get_or(this.entity, () => "unknown");
    }
    on_style_changed() {
        this.border_size = this.border.get_theme_node().get_border_width(St.Side.TOP);
    }
    rect() {
        return Rect.Rectangle.from_meta(this.meta.get_frame_rect());
    }
    size_hint() {
        return this.extra.normal_hints.get_or_init(() => {
            const xid = this.xid();
            return xid ? xprop.get_size_hints(xid) : null;
        });
    }
    swap(ext, other) {
        let ar = this.rect().clone();
        let br = other.rect().clone();
        other.move(ext, ar);
        this.move(ext, br, () => place_pointer_on(this.ext.conf.default_pointer_position, this.meta));
    }
    title() {
        const title = this.meta.get_title();
        return title ? title : this.name(this.ext);
    }
    wm_role() {
        return this.extra.wm_role_.get_or_init(() => {
            const xid = this.xid();
            return xid ? xprop.get_window_role(xid) : null;
        });
    }
    workspace_id() {
        const workspace = this.meta.get_workspace();
        if (workspace) {
            return workspace.index();
        }
        else {
            this.meta.change_workspace_by_index(0, false);
            return 0;
        }
    }
    xid() {
        return this.extra.xid_.get_or_init(() => {
            if (utils.is_wayland())
                return null;
            return xprop.get_xid(this.meta);
        });
    }
    show_border() {
        this.restack();
        if (this.ext.settings.active_hint()) {
            let border = this.border;
            if (!this.meta.is_fullscreen() &&
                (!this.is_single_max_screen() || this.is_snap_edge()) &&
                !this.meta.minimized &&
                this.same_workspace()) {
                if (this.meta.appears_focused) {
                    border.show();
                }
            }
        }
    }
    same_workspace() {
        const workspace = this.meta.get_workspace();
        if (workspace) {
            let workspace_id = workspace.index();
            return workspace_id === global.workspace_manager.get_active_workspace_index();
        }
        return false;
    }
    restack(updateState = RESTACK_STATE.NORMAL) {
        this.update_border_layout();
        if (this.meta.is_fullscreen() ||
            (this.is_single_max_screen() && !this.is_snap_edge()) ||
            this.meta.minimized) {
            this.hide_border();
        }
        let restackSpeed = RESTACK_SPEED.NORMAL;
        switch (updateState) {
            case RESTACK_STATE.NORMAL:
                restackSpeed = RESTACK_SPEED.NORMAL;
                break;
            case RESTACK_STATE.RAISED:
                restackSpeed = RESTACK_SPEED.RAISED;
                break;
            case RESTACK_STATE.WORKSPACE_CHANGED:
                restackSpeed = RESTACK_SPEED.WORKSPACE_CHANGED;
                break;
        }
        const action = () => {
            if (!this.actor_exists)
                return;
            let border = this.border;
            let actor = this.meta.get_compositor_private();
            let win_group = global.window_group;
            if (actor && border && win_group) {
                this.update_border_layout();
                win_group.set_child_above_sibling(border, null);
                if (this.always_top_windows.length > 0) {
                    for (const above_actor of this.always_top_windows) {
                        if (actor != above_actor) {
                            if (border.get_parent() === above_actor.get_parent()) {
                                win_group.set_child_below_sibling(border, above_actor);
                            }
                        }
                    }
                    if (border.get_parent() === actor.get_parent()) {
                        win_group.set_child_above_sibling(border, actor);
                    }
                }
                for (const window of this.ext.windows.values()) {
                    const parent = window.meta.get_transient_for();
                    const window_actor = window.meta.get_compositor_private();
                    if (!parent || !window_actor)
                        continue;
                    const parent_actor = parent.get_compositor_private();
                    if (!parent_actor && parent_actor !== actor)
                        continue;
                    win_group.set_child_below_sibling(border, window_actor);
                }
            }
            return false;
        };
        GLib.timeout_add(GLib.PRIORITY_LOW, restackSpeed, action);
    }
    get always_top_windows() {
        let above_windows = new Array();
        for (const actor of global.get_window_actors()) {
            if (actor && actor.get_meta_window() && actor.get_meta_window().is_above())
                above_windows.push(actor);
        }
        return above_windows;
    }
    hide_border() {
        let b = this.border;
        if (b)
            b.hide();
    }
    update_border_layout() {
        var _a;
        let { x, y, width, height } = this.meta.get_frame_rect();
        const border = this.border;
        let borderSize = this.border_size;
        if (border) {
            if (!(this.is_max_screen() || this.is_snap_edge())) {
                border.remove_style_class_name('pop-shell-border-maximize');
            }
            else {
                borderSize = 0;
                border.add_style_class_name('pop-shell-border-maximize');
            }
            const stack_number = this.stack;
            let dimensions = null;
            if (stack_number !== null) {
                const stack = (_a = this.ext.auto_tiler) === null || _a === void 0 ? void 0 : _a.forest.stacks.get(stack_number);
                if (stack) {
                    let stack_tab_height = stack.tabs_height;
                    if (borderSize === 0 || this.grab) {
                        stack_tab_height = 0;
                    }
                    dimensions = [
                        x - borderSize,
                        y - stack_tab_height - borderSize,
                        width + 2 * borderSize,
                        height + stack_tab_height + 2 * borderSize
                    ];
                }
            }
            else {
                dimensions = [
                    x - borderSize,
                    y - borderSize,
                    width + (2 * borderSize),
                    height + (2 * borderSize)
                ];
            }
            if (dimensions) {
                [x, y, width, height] = dimensions;
                const workspace = this.meta.get_workspace();
                if (workspace === null)
                    return;
                const screen = workspace.get_work_area_for_monitor(this.meta.get_monitor());
                if (screen) {
                    width = Math.min(width, screen.x + screen.width);
                    height = Math.min(height, screen.y + screen.height);
                }
                border.set_position(x, y);
                border.set_size(width, height);
            }
        }
    }
    wm_class_changed() {
        var _a;
        if (this.is_tilable(this.ext)) {
            this.ext.connect_window(this);
            if (!this.meta.minimized) {
                (_a = this.ext.auto_tiler) === null || _a === void 0 ? void 0 : _a.auto_tile(this.ext, this, this.ext.init);
            }
        }
    }
    window_changed() {
        this.update_border_layout();
        this.show_border();
    }
    window_raised() {
        this.restack(RESTACK_STATE.RAISED);
        this.show_border();
        if (this.ext.conf.move_pointer_on_switch && !pointer_already_on_window(this.meta)) {
            place_pointer_on(this.ext.conf.default_pointer_position, this.meta);
        }
    }
    workspace_changed() {
        this.restack(RESTACK_STATE.WORKSPACE_CHANGED);
    }
}
function activate(move_mouse, default_pointer_position, win) {
    const workspace = win.get_workspace();
    if (!workspace)
        return;
    win.unminimize();
    workspace.activate_with_focus(win, global.get_current_time());
    win.raise();
    if (move_mouse && !pointer_already_on_window(win)) {
        place_pointer_on(default_pointer_position, win);
    }
}
function place_pointer_on(default_pointer_position, win) {
    const rect = win.get_frame_rect();
    let x = rect.x;
    let y = rect.y;
    switch (default_pointer_position) {
        case DefaultPointerPosition.TopLeft:
            x += 8;
            y += 8;
            break;
        case DefaultPointerPosition.BottomLeft:
            x += 8;
            y += (rect.height - 16);
            break;
        case DefaultPointerPosition.TopRight:
            x += (rect.width - 16);
            y += 8;
            break;
        case DefaultPointerPosition.BottomRight:
            x += (rect.width - 16);
            y += (rect.height - 16);
            break;
        case DefaultPointerPosition.Center:
            x += (rect.width / 2) + 8;
            y += (rect.height / 2) + 8;
            break;
        default:
            x += 8;
            y += 8;
    }
    const display = Gdk.DisplayManager.get().get_default_display();
    display
        .get_default_seat()
        .get_pointer()
        .warp(display.get_default_screen(), x, y);
}
function pointer_already_on_window(meta) {
    const cursor = lib.cursor_rect();
    return cursor.intersects(meta.get_frame_rect());
}
