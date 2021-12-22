var __classPrivateFieldSet = (this && this.__classPrivateFieldSet) || function (receiver, state, value, kind, f) {
    if (kind === "m") throw new TypeError("Private method is not writable");
    if (kind === "a" && !f) throw new TypeError("Private accessor was defined without a setter");
    if (typeof state === "function" ? receiver !== state || !f : !state.has(receiver)) throw new TypeError("Cannot write private member to an object whose class did not declare it");
    return (kind === "a" ? f.call(receiver, value) : f ? f.value = value : state.set(receiver, value)), value;
};
var __classPrivateFieldGet = (this && this.__classPrivateFieldGet) || function (receiver, state, kind, f) {
    if (kind === "a" && !f) throw new TypeError("Private accessor was defined without a getter");
    if (typeof state === "function" ? receiver !== state || !f : !state.has(receiver)) throw new TypeError("Cannot read private member from an object whose class did not declare it");
    return kind === "m" ? f : kind === "a" ? f.call(receiver) : f ? f.value : state.get(receiver);
};
var _System_executor;
function entity_eq(a, b) {
    return a[0] == b[0] && b[1] == b[1];
}
function entity_new(pos, gen) {
    return [pos, gen];
}
var Storage = class Storage {
    constructor() {
        this.store = new Array();
    }
    *_iter() {
        let idx = 0;
        for (const slot of this.store) {
            if (slot)
                yield [idx, slot];
            idx += 1;
        }
    }
    *iter() {
        for (const [idx, [gen, value]] of this._iter()) {
            yield [entity_new(idx, gen), value];
        }
    }
    *find(func) {
        for (const [idx, [gen, value]] of this._iter()) {
            if (func(value))
                yield entity_new(idx, gen);
        }
    }
    *values() {
        for (const [, [, value]] of this._iter()) {
            yield value;
        }
    }
    contains(entity) {
        return this.get(entity) != null;
    }
    get(entity) {
        let [id, gen] = entity;
        const val = this.store[id];
        return (val && val[0] == gen) ? val[1] : null;
    }
    get_or(entity, init) {
        let value = this.get(entity);
        if (!value) {
            value = init();
            this.insert(entity, value);
        }
        return value;
    }
    insert(entity, component) {
        let [id, gen] = entity;
        let length = this.store.length;
        if (length >= id) {
            this.store.fill(null, length, id);
        }
        this.store[id] = [gen, component];
    }
    is_empty() {
        for (const slot of this.store)
            if (slot)
                return false;
        return true;
    }
    remove(entity) {
        const comp = this.get(entity);
        if (comp) {
            this.store[entity[0]] = null;
        }
        ;
        return comp;
    }
    take_with(entity, func) {
        const component = this.remove(entity);
        return component ? func(component) : null;
    }
    with(entity, func) {
        const component = this.get(entity);
        return component ? func(component) : null;
    }
}
var World = class World {
    constructor() {
        this.entities_ = new Array();
        this.storages = new Array();
        this.tags_ = new Array();
        this.free_slots = new Array();
    }
    get capacity() {
        return this.entities_.length;
    }
    get free() {
        return this.free_slots.length;
    }
    get length() {
        return this.capacity - this.free;
    }
    tags(entity) {
        return this.tags_[entity[0]];
    }
    *entities() {
        for (const entity of this.entities_.values()) {
            if (!(this.free_slots.indexOf(entity[0]) > -1))
                yield entity;
        }
    }
    create_entity() {
        let slot = this.free_slots.pop();
        if (slot) {
            var entity = this.entities_[slot];
            entity[1] += 1;
        }
        else {
            var entity = entity_new(this.capacity, 0);
            this.entities_.push(entity);
            this.tags_.push(new Set());
        }
        return entity;
    }
    delete_entity(entity) {
        this.tags(entity).clear();
        for (const storage of this.storages) {
            storage.remove(entity);
        }
        this.free_slots.push(entity[0]);
    }
    add_tag(entity, tag) {
        this.tags(entity).add(tag);
    }
    contains_tag(entity, tag) {
        return this.tags(entity).has(tag);
    }
    delete_tag(entity, tag) {
        this.tags(entity).delete(tag);
    }
    register_storage() {
        let storage = new Storage();
        this.storages.push(storage);
        return storage;
    }
    unregister_storage(storage) {
        let matched = this.storages.indexOf(storage);
        if (matched) {
            swap_remove(this.storages, matched);
        }
    }
}
function swap_remove(array, index) {
    array[index] = array[array.length - 1];
    return array.pop();
}
var System = class System extends World {
    constructor(executor) {
        super();
        _System_executor.set(this, void 0);
        __classPrivateFieldSet(this, _System_executor, executor, "f");
    }
    register(event) {
        __classPrivateFieldGet(this, _System_executor, "f").wake(this, event);
    }
    run(_event) { }
}
_System_executor = new WeakMap();
