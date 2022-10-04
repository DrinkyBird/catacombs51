var original = self.selection;

if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
	self.selection--;
	if (self.selection < 0) {
		self.selection = array_length(self.runs) - 1;
	}
}

if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
	self.selection++;
	if (self.selection >= array_length(self.runs)) {
		self.selection = 0;
	}
}

if (self.selection != original) {
	audio_play_sound(snd_menu_select, 5, false);
}