var OK = 1;
var ERR = 2;
function Ok(value) {
    return { kind: 1, value: value };
}
function Err(value) {
    return { kind: 2, value: value };
}
