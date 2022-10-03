var dw = display_get_gui_width();
var dh = display_get_gui_height();

var xx = 50;
var yy = dh - 50;

for (var i = array_length(self.items) - 1; i >= 0; i--) {
	var item = self.items[i];
	var selected = self.selection == i;
	
	if (selected) {
		draw_set_colour(c_yellow);
	} else {
		draw_set_colour(c_white);
	}
	
	yy -= string_height(item.label);
	
	draw_set_font(font_main);
	draw_set_alpha(1);
	if (selected) {
		var aw = string_width("> ");
		draw_text_shadow(xx - aw, yy, string_args("> %1", item.label));
	} else {
		draw_text_shadow(xx, yy, item.label);
	}
}

var verstr = string_args("v%1 built %2", GM_version, date_datetime_string(GM_build_date));
draw_set_colour(c_grey);
draw_text_shadow(dw - string_width(verstr) - 2, dh - string_height(verstr) - 2, verstr);

if (global.highScore > 0) {
	var histr = string_args("Your high score: %1", global.highScore);
	draw_set_colour(c_white);
	draw_text_shadow(dw - string_width(histr) - 50, dh - string_height(histr) - 50, histr);
}