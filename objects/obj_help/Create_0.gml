randomise();
var bgcolour = make_colour_rgb( 
	random_range(0.3, 0.5) * 64,
	random_range(0.3, 0.5) * 64,
	random_range(0.3, 0.5) * 64
);

var bgId = layer_get_id("Background");
var bgBg = layer_background_get_id(bgId);
layer_background_blend(bgBg, bgcolour);
window_set_cursor(cr_none);
cursor_sprite = -1;