self.alarm[0] = 1;

audio_play_sound(snd_explode, 5, false);

var range = 64;
var list = ds_list_create();
var num = collision_circle_list(x, y, range / 2, obj_living, false, true, list, false);

for (var i = 0; i < num; i++) {
	var dist = 1.0 - point_distance(x, y, list[| i].x, list[| i].y) / range;
	list[| i].health = max(0, list[| i].health - (10 * dist));
}

ds_list_destroy(list);