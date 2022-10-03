#macro PLAYER_MAX_SPEED 1.6
#macro PLAYER_FRICTION 0.25
#macro PLAYER_SPEED 0.8
#macro PLAYER_ZERO_THRESHOLD 0.05

if (self.health != self.lastHealth && self.lastHealth > 0) {
	self.flashEnd = global.clock + 30;
	self.flashColour = c_red;
	self.flashAlphaDivide = 2;
	
	if (self.health <= 0) {
		self.flashAlphaDivide = 1;
	} else {
		audio_play_sound(snd_player_hit, 10, false);
	}
	
	self.lastHealth = self.health;
}

if (self.health <= 0) {
	if (self.deathTime == -1) {
		self.deathTime = global.clock;
		audio_play_sound(snd_player_die, 10, false);
	}
	
	return;
}

if (self.lastMaxHpPowerup != global.powerups[Powerups.maxhp]) { 
	self.maxHealth = 3 + global.powerups[Powerups.maxhp];
	self.health = self.maxHealth;
	self.lastMaxHpPowerup = global.powerups[Powerups.maxhp]
}

/// @function				player_check_tiles(cx, cy);
/// @param {real}	cx		X coord to check
/// @param {real}	cy		Y coord to check
/// @description			Checks tilemaps at the given co-ordinates for a collison
function player_check_tiles(cx, cy) {
	// Collide if this isn't a floor.
	
	var tilemap = layer_tilemap_get_id("Walls");
	if (tilemap == -1) {
		// No floor layer!
		return true;
	}
	
	var bl = cx + sprite_get_bbox_left(sprite_index) - sprite_get_xoffset(sprite_index);
	var br = bl + sprite_get_bbox_right(sprite_index) + 1;
	var bt = cy + sprite_get_bbox_top(sprite_index) - sprite_get_xoffset(sprite_index);
	var bb = bt + sprite_get_bbox_bottom(sprite_index) + 1;
		
	for (var xx = bl; xx < br; xx++)
	for (var yy = bt; yy < bb; yy++) {
		var test = tilemap_get_at_pixel(tilemap, xx, yy);
		if (test != 0) {
			return false;
		}
	}
	
	return true;
}

function player_check_objects(cx, cy) {
	var bl = cx + sprite_get_bbox_left(sprite_index) - sprite_get_xoffset(sprite_index);
	var br = bl + sprite_get_bbox_right(sprite_index) + 1;
	var bt = cy + sprite_get_bbox_top(sprite_index) - sprite_get_xoffset(sprite_index);
	var bb = bt + sprite_get_bbox_bottom(sprite_index) + 1;
	
	var obj = collision_rectangle(bl, bt, br, bb, all, true, true);
	if (obj != noone && obj.solid) {
		// print("hit %1", object_get_name(obj.object_index));
		return false;
	}
	
	return true;
}

function player_test_collision(cx, cy) {
	if (global.debug && keyboard_check(vk_tab)) {
		return true;
	}
	
	/*
	if (!player_check_tiles(cx, cy)) {
		return false;
	}
	//*/
	
	if (!player_check_objects(cx, cy)) {
		return false;
	}
	
	return true;
}

var mx = 0;
var my = 0;

if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
	mx += 1;
}
if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
	mx -= 1;
}

if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
	my -= 1;
}
if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
	my += 1;
}

// check weapon keys
for (var i = 0; i < Weapons.count; i++) {
	if (keyboard_check(ord("1") + i) && global.weapons[i]) {
		global.weapon = i;
	}
}

var svx = sign(self.vx);
var svy = sign(self.vy);
self.vx -= svx * PLAYER_FRICTION;
self.vy -= svy * PLAYER_FRICTION;
if (sign(self.vx) != svx) { self.vx = 0; }
if (sign(self.vy) != svy) { self.vy = 0; }

self.vx = clamp(self.vx + (mx * PLAYER_SPEED), -PLAYER_MAX_SPEED, PLAYER_MAX_SPEED);
self.vy = clamp(self.vy + (my * PLAYER_SPEED), -PLAYER_MAX_SPEED, PLAYER_MAX_SPEED);

if (global.debug && keyboard_check(vk_shift)) {
	self.vx *= 2;
	self.vy *= 2;
}

var nextX = self.x + self.vx;
var nextY = self.y + self.vy;

if (player_test_collision(nextX, self.y)) {
	self.x = nextX;
}

if (player_test_collision(self.x, nextY)) {
	self.y = nextY;
}

var dx = mouse_x - self.x;
var dy = mouse_y - self.y;
self.image_angle = point_direction(self.x, self.y, mouse_x, mouse_y);

var aheadX = self.x + 8 *  cos(degtorad(image_angle));
var aheadY = self.y + 8 * -sin(degtorad(image_angle));
var accu = max(0, 1.0 - abs(degtorad(clamp(global.powerups[Powerups.accuracy], 0, 360))));
var dmgfactor = 1 + (global.powerups[Powerups.damage] / 4);

if (mouse_check_button(mb_left)) {
	switch (global.weapon) {
		case Weapons.pistol: {
			if (global.clock - self.lastFireTime[global.weapon] > max(1, 10 - global.powerups[Powerups.firerate])) {
				var b = instance_create_layer(aheadX, aheadY, "Instances", obj_basicbullet);
				b.damage *= dmgfactor;
				b.image_angle = self.image_angle + (random_range(-2, 2) * accu);
				b.owner = self;
				self.lastFireTime[global.weapon] = global.clock;
				audio_play_sound(snd_shootpistol, 5, false);
			}
			
			break;
		}
		
		case Weapons.rifle: {
			if (global.clock - self.lastFireTime[global.weapon] > max(1, 30 - global.powerups[Powerups.firerate])) {
				var b = instance_create_layer(aheadX, aheadY, "Instances", obj_riflebullet);
				b.damage *= dmgfactor;
				b.image_angle = self.image_angle + (random_range(-0.5, 0.5) * accu);
				b.owner = self;
				self.lastFireTime[global.weapon] = global.clock;
				audio_play_sound(snd_shootrifle, 5, false);
			}
			
			break;
		}
		
		case Weapons.testGun: {
			if (global.clock - self.lastFireTime[global.weapon] > 1) {
				var b = instance_create_layer(aheadX, aheadY, "Instances", obj_testbullet);
				b.damage *= dmgfactor;
				b.image_angle = self.image_angle;
				b.owner = self;
				self.lastFireTime[global.weapon] = global.clock;
			}
			
			break;
		}
		
		case Weapons.chaingun: {
			if (global.clock - self.lastFireTime[global.weapon] > max(6, 10 - global.powerups[Powerups.firerate])) {
				var b = instance_create_layer(aheadX, aheadY, "Instances", obj_chainbullet);
				b.damage *= dmgfactor;
				b.image_angle = self.image_angle + (random_range(-5, 5) * accu);
				b.owner = self;
				self.lastFireTime[global.weapon] = global.clock;
				audio_play_sound(snd_shootpistol, 5, false);
			}
			
			break;
		}
		
		case Weapons.shotgun: {
			if (global.clock - self.lastFireTime[global.weapon] > max(1, 45 - global.powerups[Powerups.firerate])) {
				var b = instance_create_layer(aheadX, aheadY, "Instances", obj_shotgunbullet);
				b.damage *= dmgfactor;
				b.image_angle = self.image_angle - 10 + (random_range(-2, 2) * accu);
				b.owner = self;
				b = instance_create_layer(aheadX, aheadY, "Instances", obj_shotgunbullet);
				b.damage *= dmgfactor;
				b.image_angle = self.image_angle - 5 + (random_range(-2, 2) * accu);
				b.owner = self;
				b = instance_create_layer(aheadX, aheadY, "Instances", obj_shotgunbullet);
				b.damage *= dmgfactor;
				b.image_angle = self.image_angle + (random_range(-2, 2) * accu);
				b.owner = self;
				b = instance_create_layer(aheadX, aheadY, "Instances", obj_shotgunbullet);
				b.damage *= dmgfactor;
				b.image_angle = self.image_angle + 5 + (random_range(-2, 2) * accu);
				b.owner = self;
				b = instance_create_layer(aheadX, aheadY, "Instances", obj_shotgunbullet);
				b.damage *= dmgfactor;
				b.image_angle = self.image_angle + 10 + (random_range(-2, 2) * accu);
				b.owner = self;
				self.lastFireTime[global.weapon] = global.clock;
				audio_play_sound(snd_shootshotgun, 5, false);
			}
			
			break;
		}
		
		case Weapons.rocketLauncher: {
			if (global.clock - self.lastFireTime[global.weapon] > max(1, 90 - global.powerups[Powerups.firerate])) {
				var b = instance_create_layer(aheadX, aheadY, "Instances", obj_rocketbullet);
				b.image_angle = self.image_angle + (random_range(-2, 2) * accu);
				b.owner = self;
				b.damage *= dmgfactor;
				self.lastFireTime[global.weapon] = global.clock;
				audio_play_sound(snd_shootpistol, 5, false);
			}
			
			break;
		}
	}
}