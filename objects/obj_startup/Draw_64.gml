var dw = display_get_gui_width();
var dh = display_get_gui_height();

var text = string_args("Loading...");

draw_set_color(c_black);
draw_rectangle(0, 0, dw, dh, false);
draw_set_font(font_main);
draw_set_colour(c_white);
draw_text((dw / 2) - (string_width(text) / 2), (dh / 2) - (string_height(text)), text);