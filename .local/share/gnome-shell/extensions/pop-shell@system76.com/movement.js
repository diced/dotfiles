var Movement;
(function (Movement) {
    Movement[Movement["NONE"] = 0] = "NONE";
    Movement[Movement["MOVED"] = 1] = "MOVED";
    Movement[Movement["GROW"] = 2] = "GROW";
    Movement[Movement["SHRINK"] = 4] = "SHRINK";
    Movement[Movement["LEFT"] = 8] = "LEFT";
    Movement[Movement["UP"] = 16] = "UP";
    Movement[Movement["RIGHT"] = 32] = "RIGHT";
    Movement[Movement["DOWN"] = 64] = "DOWN";
})(Movement || (Movement = {}));
function calculate(from, change) {
    const xpos = from.x == change.x;
    const ypos = from.y == change.y;
    if (xpos && ypos) {
        if (from.width == change.width) {
            if (from.height == change.width) {
                return Movement.NONE;
            }
            else if (from.height < change.height) {
                return Movement.GROW | Movement.DOWN;
            }
            else {
                return Movement.SHRINK | Movement.UP;
            }
        }
        else if (from.width < change.width) {
            return Movement.GROW | Movement.RIGHT;
        }
        else {
            return Movement.SHRINK | Movement.LEFT;
        }
    }
    else if (xpos) {
        if (from.height < change.height) {
            return Movement.GROW | Movement.UP;
        }
        else {
            return Movement.SHRINK | Movement.DOWN;
        }
    }
    else if (ypos) {
        if (from.width < change.width) {
            return Movement.GROW | Movement.LEFT;
        }
        else {
            return Movement.SHRINK | Movement.RIGHT;
        }
    }
    else {
        return Movement.MOVED;
    }
}
