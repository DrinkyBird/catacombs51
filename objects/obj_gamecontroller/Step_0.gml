if (instance_exists(obj_player) && obj_player.health > 0) {
	self.endScreen = false;
	self.timer++;
	
	
	if (self.timer % 60 == 0 && self.timer >= 7 * 60 && self.timer < 10 * 60) {
		obj_player.flashColour = c_yellow;
		obj_player.flashAlphaDivide = 8;
		obj_player.flashEnd = global.clock + 60;
		audio_play_sound(snd_tick, 2, false);
	}

	if (self.timer >= game_get_speed(gamespeed_fps) * RESET_TIME) {
		run_next_level();
	}
} else {
	self.endScreen = true;
}

//ycursor_sprite = spr_cursor;
window_set_cursor(cr_none) ;