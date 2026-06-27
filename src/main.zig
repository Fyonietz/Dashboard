const std = @import("std");
const c_locale= @cImport(@cInclude("locale.h"));
const nc = @import("nc.zig").nc;

const renderer = @import("frontend/renderer.zig");
const Plane = renderer.Plane;
const Text = renderer.Text;
const Cell = renderer.Cell;


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
   pub fn render(self:*App) !void{
         if(self.context) |ctx|{
            if(nc.notcurses_render(ctx) < 0) return error.ErrorRenderingProcess;
        }
   }
};
pub inline fn CellChar(c:u32) nc.nccell{
   return nc.nccell{
       .gcluster = c,
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
    const plane_sec = Plane.create(app.plane,10,2,24,80);
    const cell_upper = try Cell.init(plane_sec,"─");
    const cell_lower = try Cell.init(plane_sec,"─");
    const cell_hline =try Cell.init(plane_sec,"─");
    const cell_vline =try Cell.init(plane_sec,"│");
    _ = nc.ncplane_box(plane_sec,
        &cell_upper,
        &cell_upper,
        &cell_lower,
        &cell_lower, 
        &cell_hline, 
        &cell_vline,
        5, 
        20, 
        0);

    const hello = Text{
        .plane = plane_sec,
        .x = 1,
        .y =2,
        .text = "Hellow"
    };
    try hello.draw();

    //Renderer
    try app.render();
    while(app.running){

    }
}
