var cam = camera_get_active();
var sw = sprite_get_width(sprite_index);
var sh = sprite_get_height(sprite_index);
var cx = self.x - (camera_get_view_width(cam) / 2) + (sw / 2);
var cy = self.y - (camera_get_view_height(cam) / 2) + (sh / 2);

camera_set_view_pos(cam, cx, cy);