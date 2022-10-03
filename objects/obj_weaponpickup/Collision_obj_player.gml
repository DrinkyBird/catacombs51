if (global.weapons[self.weapon]) { return; }

global.weapons[self.weapon] = true;
global.weapon = self.weapon;
floatytext(x, y, c_yellow, string_args("Acquired: %1", global.WEAPON_NAMES[self.weapon]));
audio_play_sound(snd_get_weapon, 10, false);
instance_destroy();
global.score += SCORE_PICK_UP_WEAPON;