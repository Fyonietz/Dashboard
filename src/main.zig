const std = @import("std");
const c_locale= @cImport(@cInclude("locale.h"));
const nc = @import("nc.zig").nc;
const renderer = @import("frontend/renderer.zig");

const App = struct{
    running:bool,
    context:?*nc.notcurses = null,
    plane:?*nc.ncplane = null,

    pub fn init(opt_1:anytype,opt_2:anytype) !App{
        const ctx = nc.notcurses_init(opt_1,opt_2);
        if(ctx == null ) return error.InitFailed;
        return App{
            .running = true,
            .context =ctx,
            .plane = nc.notcurses_stdplane(ctx)
        };
    }

    pub fn deinit(self:*App) !void{
        if(self.context) |ctx|{
            if(nc.notcurses.stop(ctx) < 0) return error.ErrorCleanUp;
        }
        self.running = false;
    }
};
pub inline fn CellChar(c:u8) nc.nccell{
   return nc.nccell{
       .gcluster = @as(u32,c),
       .stylemask = 0,
       .channels = 0
   };
}
pub fn main() !void{
    //Init Block
    _ = c_locale.setlocale(c_locale.LC_ALL,"");
    var app = try App.init(null,null);
    defer app.deinit() catch {};
    //Code block 

    const plane_opt = nc.ncplane_options{
      .y = 2,
      .x = 0,
      .rows = 24,
      .cols = 80
    };
    const plane_uno = nc.ncplane_create(app.plane,&plane_opt);
    const cell_upper = CellChar('+');
    const cell_lower = CellChar('+');
    const cell_hline = CellChar('-');
    const cell_vline = CellChar('|');
    _ = nc.ncplane_box(plane_uno,
        &cell_upper,
        &cell_upper,
        &cell_lower,
        &cell_lower, 
        &cell_hline, 
        &cell_vline,
        5, 
        20, 
        0);
    _ = nc.notcurses_render(app.context);
    while(app.running){

    }
}
