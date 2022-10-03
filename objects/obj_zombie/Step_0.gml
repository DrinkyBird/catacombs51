self.damageCooldownTimer--;

if (obj_player.health <= 0) { 
	return;
}

if (!self.seenPlayer && distance_to_object(obj_player) <= 5 * 16) {
	var l = collision_line(self.x, self.y, obj_player.x, obj_player.y, obj_wall, true, true);
	if (l == noone) {
		self.seenPlayer = true;
	}
}

if (self.seenPlayer) {
	image_angle = point_direction(self.x, self.y, obj_player.x, obj_player.y);
	//mp_potential_path(self.path, obj_player.x, obj_player.y, 1, 3, true);
	if (mp_grid_path(global.mp, self.path, self.x, self.y, obj_player.x, obj_player.y, true)) {
		path_start(self.path, random_range(0.4, 0.6), 0, 0);
	}
	
	if (self.damageCooldownTimer <= 0 && position_meeting(x, y, obj_player)) {
		obj_player.health -= self.damage;
		self.damageCooldownTimer = self.damageCooldown;
	}
}