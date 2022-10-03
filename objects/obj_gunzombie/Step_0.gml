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
		path_start(self.path, random_range(0.3, 0.5), 0, 0);
	}
	
	var aheadX = self.x + 8 *  cos(degtorad(image_angle));
	var aheadY = self.y + 8 * -sin(degtorad(image_angle));

	switch (global.weapon) {
		case Weapons.pistol: {
			if (global.clock - self.lastFireTime > 40) {
				var b = instance_create_layer(aheadX, aheadY, "Instances", obj_basicbullet);
				b.image_angle = self.image_angle + random_range(-2, 2);
				b.owner = self;
				b.damage = max(1, 1 + global.level / 4);
				b.moveSpeed /= 2;
				self.lastFireTime = global.clock;
				audio_play_sound(snd_shootpistol, 5, false);
			}
			
			break;
		}
		
		case Weapons.rifle: {
			if (global.clock - self.lastFireTime > 60) {
				var b = instance_create_layer(aheadX, aheadY, "Instances", obj_riflebullet);
				b.image_angle = self.image_angle + random_range(-0.5, 0.5);
				b.owner = self;
				self.lastFireTime = global.clock;
				b.damage = max(1, 1 + global.level / 4);
				b.moveSpeed /= 2;
				audio_play_sound(snd_shootpistol, 5, false);
			}
			
			break;
		}
		
		case Weapons.testGun: {
			if (global.clock - self.lastFireTime > 1) {
				var b = instance_create_layer(aheadX, aheadY, "Instances", obj_testbullet);
				b.image_angle = self.image_angle;
				b.owner = self;
				self.lastFireTime = global.clock;
				b.damage = max(1, 1 + global.level / 4);
				b.moveSpeed /= 2;
				audio_play_sound(snd_shootpistol, 5, false);
			}
			
			break;
		}
		
		case Weapons.chaingun: {
			if (global.clock - self.lastFireTime > 12) {
				var b = instance_create_layer(aheadX, aheadY, "Instances", obj_chainbullet);
				b.image_angle = self.image_angle + random_range(-5, 5);
				b.owner = self;
				self.lastFireTime = global.clock;
				b.damage = max(1, 1 + global.level / 4);
				b.moveSpeed /= 2;
				audio_play_sound(snd_shootpistol, 5, false);
			}
			
			break;
		}
		
		case Weapons.shotgun: {
			if (global.clock - self.lastFireTime > 60) {
				var b = instance_create_layer(aheadX, aheadY, "Instances", obj_shotgunbullet);
				b.image_angle = self.image_angle - 10 + random_range(-2, 2);
				b.owner = self;
				b.damage = max(1, 1 + global.level / 4);
				b.moveSpeed /= 2;
				b = instance_create_layer(aheadX, aheadY, "Instances", obj_shotgunbullet);
				b.image_angle = self.image_angle - 5 + random_range(-2, 2);
				b.owner = self;
				b.damage = max(1, 1 + global.level / 4);
				b.moveSpeed /= 2;
				b = instance_create_layer(aheadX, aheadY, "Instances", obj_shotgunbullet);
				b.image_angle = self.image_angle + random_range(-2, 2);
				b.owner = self;
				b.damage = max(1, 1 + global.level / 4);
				b.moveSpeed /= 2;
				b = instance_create_layer(aheadX, aheadY, "Instances", obj_shotgunbullet);
				b.image_angle = self.image_angle + 5 + random_range(-2, 2);
				b.owner = self;
				b.damage = max(1, 1 + global.level / 4);
				b.moveSpeed /= 2;
				b = instance_create_layer(aheadX, aheadY, "Instances", obj_shotgunbullet);
				b.image_angle = self.image_angle + 10 + random_range(-2, 2);
				b.owner = self;
				b.damage = max(1, 1 + global.level / 4);
				b.moveSpeed /= 2;
				self.lastFireTime = global.clock;
				audio_play_sound(snd_shootpistol, 5, false);
			}
			
			break;
		}
		
		case Weapons.rocketLauncher: {
			if (global.clock - self.lastFireTime > 110) {
				var b = instance_create_layer(aheadX, aheadY, "Instances", obj_rocketbullet);
				b.image_angle = self.image_angle + random_range(-2, 2);
				b.owner = self;
				b.damage = min(1, global.level / 16);
				b.moveSpeed /= 2;
				self.lastFireTime = global.clock;
				audio_play_sound(snd_shootpistol, 5, false);
			}
			
			break;
		}
	}
}