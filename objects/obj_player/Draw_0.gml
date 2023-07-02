if (self.health > 0) {
	//draw_self();
}

if (false) {
	draw_set_color(c_blue);
	var bl = self.x + sprite_get_bbox_left(sprite_index) - sprite_get_xoffset(sprite_index);
	var br = bl + sprite_get_bbox_right(sprite_index) + 1;
	var bt = self.y + sprite_get_bbox_top(sprite_index) - sprite_get_yoffset(sprite_index);
	var bb = bt + sprite_get_bbox_bottom(sprite_index) + 1;
	draw_rectangle(bl, bt, br, bb, false);
}