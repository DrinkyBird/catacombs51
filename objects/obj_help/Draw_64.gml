var dw = display_get_gui_width();
var dh = display_get_gui_height();

if (false) {
	draw_set_font(font_debug)
	draw_set_alpha(1);
	draw_set_colour(c_white);
	var t = string_args("%1", self.y);
	draw_text_shadow(dw - string_width(t), 0, t);
} else {
	var str = "Press W/D or UP/DOWN to scroll; ESC to return to the main menu";
	
	draw_set_colour(c_black);
	draw_set_alpha(0.8);
	draw_rectangle(0, 0, dw, string_height(str) + 4, false);
	
	draw_set_colour(c_white);
	draw_set_alpha(1);
	draw_text(dw / 2 - string_width(str) / 2, 2, str);
}