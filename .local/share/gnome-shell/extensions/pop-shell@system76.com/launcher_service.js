const Me = imports.misc.extensionUtils.getCurrentExtension();
const log = Me.imports.log;
const { Gio, GLib } = imports.gi;
const { byteArray } = imports;
var LauncherService = class LauncherService {
    constructor(service, callback) {
        this.cancellable = new Gio.Cancellable();
        this.service = service;
        const generator = (stdout, res) => {
            try {
                const [bytes,] = stdout.read_line_finish(res);
                if (bytes) {
                    const string = byteArray.toString(bytes);
                    callback(JSON.parse(string));
                    this.service.stdout.read_line_async(0, this.cancellable, generator);
                }
            }
            catch (why) {
                log.error(`failed to read response from launcher service: ${why}`);
            }
        };
        this.service.stdout.read_line_async(0, this.cancellable, generator);
    }
    activate(id) {
        this.send({ "Activate": id });
    }
    activate_context(id, context) {
        this.send({ "ActivateContext": { id, context } });
    }
    complete(id) {
        this.send({ "Complete": id });
    }
    context(id) {
        this.send({ "Context": id });
    }
    exit() {
        this.send('Exit');
        this.cancellable.cancel();
        const service = this.service;
        GLib.timeout_add(GLib.PRIORITY_DEFAULT, 100, () => {
            if (service.stdout.has_pending() || service.stdin.has_pending())
                return true;
            const close_stream = (stream) => {
                try {
                    stream.close(null);
                }
                catch (why) {
                    log.error(`failed to close pop-launcher stream: ${why}`);
                }
            };
            close_stream(service.stdin);
            close_stream(service.stdin);
            return false;
        });
    }
    query(search) {
        this.send({ "Search": search });
    }
    quit(id) {
        this.send({ "Quit": id });
    }
    select(id) {
        this.send({ "Select": id });
    }
    send(object) {
        const message = JSON.stringify(object);
        try {
            this.service.stdin.write_all(message + "\n", null);
        }
        catch (why) {
            log.error(`failed to send request to pop-launcher: ${why}`);
        }
    }
}
