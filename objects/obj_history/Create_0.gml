randomise();
var bgcolour = make_colour_rgb( 
	random_range(0.4, 0.8) * 64,
	random_range(0.4, 0.8) * 64,
	random_range(0.4, 0.8) * 64
);

var bgId = layer_get_id("Background");
var bgBg = layer_background_get_id(bgId);
layer_background_blend(bgBg, bgcolour);
window_set_cursor(cr_none);
cursor_sprite = -1;

self.loading = true;
self.runs = [];
self.selection = 0;
self.alarm[0] = 1;