var tx = (self.x - camera_get_view_x(view_camera[0])) * 2;
var ty = (self.y - camera_get_view_y(view_camera[0])) * 2;

draw_set_alpha(self.a);
draw_set_colour(self.colour);
draw_text(tx, ty, self.text);
