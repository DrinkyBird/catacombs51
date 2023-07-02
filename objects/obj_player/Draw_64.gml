return;
if (global.debug) {
	draw_set_alpha(1);
	draw_set_font(font_debug);
	draw_set_colour(c_white);
	draw_text_shadow(0, 24, string_args("x: %1 y: %2 vx: %3 vy: %4 a: %5", self.x, self.y, self.vx, self.vy, image_angle));
}

var dw = display_get_gui_width();
var dh = display_get_gui_height();

if (self.flashEnd - global.clock < 60) {
	var a = (self.flashEnd - global.clock) / 60;
	draw_set_alpha(a / self.flashAlphaDivide);
	draw_set_colour(self.flashColour);
	draw_rectangle(0, 0, dw, dh, false);
}
