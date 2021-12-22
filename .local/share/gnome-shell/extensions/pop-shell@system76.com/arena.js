var Arena = class Arena {
    constructor() {
        this.slots = new Array();
        this.unused = new Array();
    }
    truncate(n) {
        this.slots.splice(n);
        this.unused.splice(n);
    }
    get(n) {
        return this.slots[n];
    }
    insert(v) {
        let n;
        const slot = this.unused.pop();
        if (slot !== undefined) {
            n = slot;
            this.slots[n] = v;
        }
        else {
            n = this.slots.length;
            this.slots.push(v);
        }
        return n;
    }
    remove(n) {
        if (this.slots[n] === null)
            return null;
        const v = this.slots[n];
        this.slots[n] = null;
        this.unused.push(n);
        return v;
    }
    *values() {
        for (const v of this.slots) {
            if (v !== null)
                yield v;
        }
    }
}
