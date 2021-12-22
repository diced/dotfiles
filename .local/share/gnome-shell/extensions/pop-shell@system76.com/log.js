const ExtensionUtils = imports.misc.extensionUtils;
var LOG_LEVELS;
(function (LOG_LEVELS) {
    LOG_LEVELS[LOG_LEVELS["OFF"] = 0] = "OFF";
    LOG_LEVELS[LOG_LEVELS["ERROR"] = 1] = "ERROR";
    LOG_LEVELS[LOG_LEVELS["WARN"] = 2] = "WARN";
    LOG_LEVELS[LOG_LEVELS["INFO"] = 3] = "INFO";
    LOG_LEVELS[LOG_LEVELS["DEBUG"] = 4] = "DEBUG";
})(LOG_LEVELS || (LOG_LEVELS = {}));
function log_level() {
    let settings = ExtensionUtils.getSettings();
    let log_level = settings.get_uint('log-level');
    return log_level;
}
function log(text) {
    global.log("pop-shell: " + text);
}
function error(text) {
    if (log_level() > LOG_LEVELS.OFF)
        log("[ERROR] " + text);
}
function warn(text) {
    if (log_level() > LOG_LEVELS.ERROR)
        log(" [WARN] " + text);
}
function info(text) {
    if (log_level() > LOG_LEVELS.WARN)
        log(" [INFO] " + text);
}
function debug(text) {
    if (log_level() > LOG_LEVELS.INFO)
        log("[DEBUG] " + text);
}
