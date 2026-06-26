const nc = @import("../nc.zig").nc;

pub const Text = struct{
    plane : ?*nc.ncplane,
    y : c_int,
    x : c_int,
    text:[*c]const u8,
};

pub fn render_text(text:Text) !void{
    if(nc.ncplane_putstr_yx(text.plane,text.y,text.x,text.text) == -1) return error.PuttingStringError;
}
