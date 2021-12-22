const Me = imports.misc.extensionUtils.getCurrentExtension();
const Movement = Me.imports.movement;
var GrabOp = class GrabOp {
    constructor(entity, rect) {
        this.entity = entity;
        this.rect = rect;
    }
    operation(change) {
        return Movement.calculate(this.rect, change);
    }
}
