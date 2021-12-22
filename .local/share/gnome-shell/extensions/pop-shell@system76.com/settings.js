const Me = imports.misc.extensionUtils.getCurrentExtension();
const { Gio, Gdk } = imports.gi;
const DARK = ["dark", "adapta", "plata", "dracula"];
function settings_new_id(schema_id) {
    try {
        return new Gio.Settings({ schema_id });
    }
    catch (why) {
        if (schema_id !== "org.gnome.shell.extensions.user-theme") {
            global.log(`failed to get settings for ${schema_id}: ${why}`);
        }
        return null;
    }
}
function settings_new_schema(schema) {
    const GioSSS = Gio.SettingsSchemaSource;
    const schemaDir = Me.dir.get_child("schemas");
    let schemaSource = schemaDir.query_exists(null) ?
        GioSSS.new_from_directory(schemaDir.get_path(), GioSSS.get_default(), false) :
        GioSSS.get_default();
    const schemaObj = schemaSource.lookup(schema, true);
    if (!schemaObj) {
        throw new Error("Schema " + schema + " could not be found for extension "
            + Me.metadata.uuid + ". Please check your installation.");
    }
    return new Gio.Settings({ settings_schema: schemaObj });
}
const ACTIVE_HINT = "active-hint";
const COLUMN_SIZE = "column-size";
const GAP_INNER = "gap-inner";
const GAP_OUTER = "gap-outer";
const ROW_SIZE = "row-size";
const SHOW_TITLE = "show-title";
const SMART_GAPS = "smart-gaps";
const SNAP_TO_GRID = "snap-to-grid";
const TILE_BY_DEFAULT = "tile-by-default";
const HINT_COLOR_RGBA = "hint-color-rgba";
const DEFAULT_RGBA_COLOR = "rgba(251, 184, 108, 1)";
const LOG_LEVEL = "log-level";
const SHOW_SKIPTASKBAR = "show-skip-taskbar";
var ExtensionSettings = class ExtensionSettings {
    constructor() {
        this.ext = settings_new_schema(Me.metadata["settings-schema"]);
        this.int = settings_new_id("org.gnome.desktop.interface");
        this.mutter = settings_new_id("org.gnome.mutter");
        this.shell = settings_new_id("org.gnome.shell.extensions.user-theme");
    }
    active_hint() {
        return this.ext.get_boolean(ACTIVE_HINT);
    }
    column_size() {
        return this.ext.get_uint(COLUMN_SIZE);
    }
    dynamic_workspaces() {
        return this.mutter ? this.mutter.get_boolean("dynamic-workspaces") : false;
    }
    gap_inner() {
        return this.ext.get_uint(GAP_INNER);
    }
    gap_outer() {
        return this.ext.get_uint(GAP_OUTER);
    }
    hint_color_rgba() {
        let rgba = this.ext.get_string(HINT_COLOR_RGBA);
        let valid_color = new Gdk.RGBA().parse(rgba);
        if (!valid_color) {
            return DEFAULT_RGBA_COLOR;
        }
        return rgba;
    }
    theme() {
        return this.shell
            ? this.shell.get_string("name")
            : this.int
                ? this.int.get_string("gtk-theme")
                : "Adwaita";
    }
    is_dark() {
        const theme = this.theme().toLowerCase();
        return DARK.some(dark => theme.includes(dark));
    }
    is_high_contrast() {
        return this.theme().toLowerCase() === "highcontrast";
    }
    row_size() {
        return this.ext.get_uint(ROW_SIZE);
    }
    show_title() {
        return this.ext.get_boolean(SHOW_TITLE);
    }
    smart_gaps() {
        return this.ext.get_boolean(SMART_GAPS);
    }
    snap_to_grid() {
        return this.ext.get_boolean(SNAP_TO_GRID);
    }
    tile_by_default() {
        return this.ext.get_boolean(TILE_BY_DEFAULT);
    }
    workspaces_only_on_primary() {
        return this.mutter
            ? this.mutter.get_boolean("workspaces-only-on-primary")
            : false;
    }
    log_level() {
        return this.ext.get_uint(LOG_LEVEL);
    }
    show_skiptaskbar() {
        return this.ext.get_boolean(SHOW_SKIPTASKBAR);
    }
    set_active_hint(set) {
        this.ext.set_boolean(ACTIVE_HINT, set);
    }
    set_column_size(size) {
        this.ext.set_uint(COLUMN_SIZE, size);
    }
    set_gap_inner(gap) {
        this.ext.set_uint(GAP_INNER, gap);
    }
    set_gap_outer(gap) {
        this.ext.set_uint(GAP_OUTER, gap);
    }
    set_hint_color_rgba(rgba) {
        let valid_color = new Gdk.RGBA().parse(rgba);
        if (valid_color) {
            this.ext.set_string(HINT_COLOR_RGBA, rgba);
        }
        else {
            this.ext.set_string(HINT_COLOR_RGBA, DEFAULT_RGBA_COLOR);
        }
    }
    set_row_size(size) {
        this.ext.set_uint(ROW_SIZE, size);
    }
    set_show_title(set) {
        this.ext.set_boolean(SHOW_TITLE, set);
    }
    set_smart_gaps(set) {
        this.ext.set_boolean(SMART_GAPS, set);
    }
    set_snap_to_grid(set) {
        this.ext.set_boolean(SNAP_TO_GRID, set);
    }
    set_tile_by_default(set) {
        this.ext.set_boolean(TILE_BY_DEFAULT, set);
    }
    set_log_level(set) {
        this.ext.set_uint(LOG_LEVEL, set);
    }
    set_show_skiptaskbar(set) {
        this.ext.set_boolean(SHOW_SKIPTASKBAR, set);
    }
}
