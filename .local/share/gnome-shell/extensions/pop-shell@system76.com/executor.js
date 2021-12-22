var __classPrivateFieldGet = (this && this.__classPrivateFieldGet) || function (receiver, state, kind, f) {
    if (kind === "a" && !f) throw new TypeError("Private accessor was defined without a getter");
    if (typeof state === "function" ? receiver !== state || !f : !state.has(receiver)) throw new TypeError("Cannot read private member from an object whose class did not declare it");
    return kind === "m" ? f : kind === "a" ? f.call(receiver) : f ? f.value : state.get(receiver);
};
var __classPrivateFieldSet = (this && this.__classPrivateFieldSet) || function (receiver, state, value, kind, f) {
    if (kind === "m") throw new TypeError("Private method is not writable");
    if (kind === "a" && !f) throw new TypeError("Private accessor was defined without a setter");
    if (typeof state === "function" ? receiver !== state || !f : !state.has(receiver)) throw new TypeError("Cannot write private member to an object whose class did not declare it");
    return (kind === "a" ? f.call(receiver, value) : f ? f.value = value : state.set(receiver, value)), value;
};
var _GLibExecutor_event_loop, _GLibExecutor_events, _OnceExecutor_iterable, _OnceExecutor_signal, _ChannelExecutor_channel, _ChannelExecutor_signal;
const Me = imports.misc.extensionUtils.getCurrentExtension();
const GLib = imports.gi.GLib;
var GLibExecutor = class GLibExecutor {
    constructor() {
        _GLibExecutor_event_loop.set(this, null);
        _GLibExecutor_events.set(this, new Array());
    }
    wake(system, event) {
        __classPrivateFieldGet(this, _GLibExecutor_events, "f").unshift(event);
        if (__classPrivateFieldGet(this, _GLibExecutor_event_loop, "f"))
            return;
        __classPrivateFieldSet(this, _GLibExecutor_event_loop, GLib.idle_add(GLib.PRIORITY_DEFAULT, () => {
            let event = __classPrivateFieldGet(this, _GLibExecutor_events, "f").pop();
            if (event)
                system.run(event);
            if (__classPrivateFieldGet(this, _GLibExecutor_events, "f").length === 0) {
                __classPrivateFieldSet(this, _GLibExecutor_event_loop, null, "f");
                return false;
            }
            return true;
        }), "f");
    }
}
_GLibExecutor_event_loop = new WeakMap(), _GLibExecutor_events = new WeakMap();
var OnceExecutor = class OnceExecutor {
    constructor(iterable) {
        _OnceExecutor_iterable.set(this, void 0);
        _OnceExecutor_signal.set(this, null);
        __classPrivateFieldSet(this, _OnceExecutor_iterable, iterable, "f");
    }
    start(delay, apply, then) {
        this.stop();
        const iterator = __classPrivateFieldGet(this, _OnceExecutor_iterable, "f")[Symbol.iterator]();
        __classPrivateFieldSet(this, _OnceExecutor_signal, GLib.timeout_add(GLib.PRIORITY_DEFAULT, delay, () => {
            const next = iterator.next().value;
            if (typeof next === 'undefined') {
                if (then)
                    GLib.timeout_add(GLib.PRIORITY_DEFAULT, delay, () => {
                        then();
                        return false;
                    });
                return false;
            }
            return apply(next);
        }), "f");
    }
    stop() {
        if (__classPrivateFieldGet(this, _OnceExecutor_signal, "f") !== null)
            GLib.source_remove(__classPrivateFieldGet(this, _OnceExecutor_signal, "f"));
    }
}
_OnceExecutor_iterable = new WeakMap(), _OnceExecutor_signal = new WeakMap();
var ChannelExecutor = class ChannelExecutor {
    constructor() {
        _ChannelExecutor_channel.set(this, new Array());
        _ChannelExecutor_signal.set(this, null);
    }
    clear() { __classPrivateFieldGet(this, _ChannelExecutor_channel, "f").splice(0); }
    get length() { return __classPrivateFieldGet(this, _ChannelExecutor_channel, "f").length; }
    send(v) {
        __classPrivateFieldGet(this, _ChannelExecutor_channel, "f").push(v);
    }
    start(delay, apply) {
        this.stop();
        __classPrivateFieldSet(this, _ChannelExecutor_signal, GLib.timeout_add(GLib.PRIORITY_DEFAULT, delay, () => {
            const e = __classPrivateFieldGet(this, _ChannelExecutor_channel, "f").shift();
            return typeof e === 'undefined' ? true : apply(e);
        }), "f");
    }
    stop() {
        if (__classPrivateFieldGet(this, _ChannelExecutor_signal, "f") !== null)
            GLib.source_remove(__classPrivateFieldGet(this, _ChannelExecutor_signal, "f"));
    }
}
_ChannelExecutor_channel = new WeakMap(), _ChannelExecutor_signal = new WeakMap();
