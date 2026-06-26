const nc = @import("../nc.zig").nc;
const plane_t = ?*nc.ncplane;
pub const Plane = struct {
    pub inline fn create(std_plane:plane_t,x:c_int,y:c_int,rows:c_uint,column:c_uint) plane_t{
       const opt = nc.ncplane_options{
           .x = x,
           .y = y,
           .rows = rows,
           .cols = column
       };
       return nc.ncplane_create(std_plane,&opt); 
    }
};



pub const Text = struct{
    plane :plane_t,
    y : c_int,
    x : c_int,
    text:[*c]const u8,

    pub fn draw(self:*const Text) !void{
        if(nc.ncplane_putstr_yx(self.plane,self.y,self.x,self.text) == -1) return error.PuttingStringError;
    }
};


