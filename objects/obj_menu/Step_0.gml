if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
	self.selection++;
	if (self.selection == array_length(self.items)) {
		self.selection = 0;
	}
	audio_play_sound(snd_menu_select, 1, false);
}

if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
	self.selection--;
	if (self.selection < 0) {
		self.selection = array_length(self.items) - 1;
	}
	audio_play_sound(snd_menu_select, 1, false);
}

if (keyboard_check_pressed(vk_enter)) {
	self.items[self.selection].callback();
	audio_play_sound(snd_menu_select, 1, false);
}

var a = sin(get_timer() / 2500000);
obj_title.image_angle = a;
obj_fiftyone.image_angle = a;