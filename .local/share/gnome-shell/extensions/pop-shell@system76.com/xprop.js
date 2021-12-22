const Me = imports.misc.extensionUtils.getCurrentExtension();
const lib = Me.imports.lib;
const GLib = imports.gi.GLib;
const { spawn } = imports.misc.util;
var MOTIF_HINTS = '_MOTIF_WM_HINTS';
var HIDE_FLAGS = ['0x2', '0x0', '0x2', '0x0', '0x0'];
var SHOW_FLAGS = ['0x2', '0x0', '0x1', '0x0', '0x0'];
function get_window_role(xid) {
    let out = xprop_cmd(xid, 'WM_WINDOW_ROLE');
    if (!out)
        return null;
    return parse_string(out);
}
function get_hint(xid, hint) {
    let out = xprop_cmd(xid, hint);
    if (!out)
        return null;
    const array = parse_cardinal(out);
    return array ? array.map((value) => value.startsWith('0x') ? value : '0x' + value) : null;
}
function size_params(line) {
    let fields = line.split(' ');
    let x = lib.dbg(lib.nth_rev(fields, 2));
    let y = lib.dbg(lib.nth_rev(fields, 0));
    if (!x || !y)
        return null;
    let xn = parseInt(x, 10);
    let yn = parseInt(y, 10);
    return isNaN(xn) || isNaN(yn) ? null : [xn, yn];
}
function get_size_hints(xid) {
    let out = xprop_cmd(xid, 'WM_NORMAL_HINTS');
    if (out) {
        let lines = out.split('\n')[Symbol.iterator]();
        lines.next();
        let minimum = lines.next().value;
        let increment = lines.next().value;
        let base = lines.next().value;
        if (!minimum || !increment || !base)
            return null;
        let min_values = size_params(minimum);
        let inc_values = size_params(increment);
        let base_values = size_params(base);
        if (!min_values || !inc_values || !base_values)
            return null;
        return {
            minimum: min_values,
            increment: inc_values,
            base: base_values,
        };
    }
    return null;
}
function get_xid(meta) {
    const desc = meta.get_description();
    const match = desc && desc.match(/0x[0-9a-f]+/);
    return match && match[0];
}
function may_decorate(xid) {
    const hints = motif_hints(xid);
    return hints ? hints[2] != '0x0' : true;
}
function motif_hints(xid) {
    return get_hint(xid, MOTIF_HINTS);
}
function set_hint(xid, hint, value) {
    spawn(['xprop', '-id', xid, '-f', hint, '32c', '-set', hint, value.join(', ')]);
}
function consume_key(string) {
    const pos = string.indexOf('=');
    return -1 == pos ? null : pos;
}
function parse_cardinal(string) {
    const pos = consume_key(string);
    return pos ? string.slice(pos + 1).trim().split(', ') : null;
}
function parse_string(string) {
    const pos = consume_key(string);
    return pos ? string.slice(pos + 1).trim().slice(1, -1) : null;
}
function xprop_cmd(xid, args) {
    let xprops = GLib.spawn_command_line_sync(`xprop -id ${xid} ${args}`);
    if (!xprops[0])
        return null;
    return imports.byteArray.toString(xprops[1]);
}
