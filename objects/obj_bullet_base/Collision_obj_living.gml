if (self.owner.id == other.id) {
	return;
}

other.health = max(0, other.health - self.damage);
audio_play_sound(snd_enemy_hit, 5, false);

self.pierceCount++;
if (self.pierceCount >= self.pierce) {
	instance_destroy(); 
}