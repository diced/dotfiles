var OnceCell = class OnceCell {
    constructor() { }
    get_or_init(callback) {
        if (this.value === undefined) {
            this.value = callback();
        }
        return this.value;
    }
}
