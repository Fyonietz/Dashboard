const std = @import("std");
const c_locale= @cImport(@cInclude("locale.h"));
const nc = @cImport(@cInclude("notcurses/notcurses.h"));

pub fn main() !void{
    _ = c_locale.setlocale(c_locale.LC_ALL,"");

    const core = nc.notcurses_init(null,null);
    defer _ = nc.notcurses.stop(core);
    
    const plane = nc.notcurses_stdplane(core);
    
    if(nc.ncplane_putstr(plane,"Hello TUI World") == -1) return error.ErrorPuttingString;

    if(nc.notcurses.render(core) == -1) return error.ProcessRenderingError;

    var keyboard_input:nc.ncinput = .{};
    if(nc.notcurses_get(core,null,&keyboard_input) == -1) return error.ErrorGetKeyboardInput;

}
