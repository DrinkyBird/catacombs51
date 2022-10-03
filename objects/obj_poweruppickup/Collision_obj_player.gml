global.powerups[self.powerup]++;
floatytext(x, y, c_yellow, string_args("Acquired: +1 %1", global.POWERUP_NAMES[self.powerup]));
audio_play_sound(snd_get_powerup, 10, false);
instance_destroy();
global.score += SCORE_PICK_UP_ITEM;