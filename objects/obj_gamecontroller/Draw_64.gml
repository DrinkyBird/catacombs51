draw_set_alpha(1);

if (global.debug) {
	show_debug_overlay(true);
}

var dw = display_get_gui_width();
var dh = display_get_gui_height();

if (global.debug && os_browser != browser_not_a_browser) {
	draw_set_font(font_debug);
	draw_set_colour(c_white);
	draw_text_shadow(0, 0, string_args("fps=%1 fps_real=%1", fps, fps_real));
}

if (self.loadScreen) {
	draw_set_color(c_black);
	draw_rectangle(0, 0, dw, dh, false);
	var text = string_args("Generating!");
	draw_set_font(font_main);
	draw_set_colour(c_white);
	draw_text((dw / 2) - (string_width(text) / 2), (dh / 2) - (string_height(text)), text);
} 
else if (obj_player.health <= 0 && obj_player.deathTime >= 0 && global.clock - obj_player.deathTime >= 2 * 60) {
	draw_set_font(font_main);
	draw_set_alpha(1);
	draw_set_colour(c_black);
	draw_rectangle(0, 0, dw, dh, false);
	
	var histr = "NEW HIGH SCORE!";
	if (global.score <= global.highScore) {
		histr = string_args("High Score: %1", global.highScore);
	}
			
	var lines = [
		"GAME OVER",
		"",
		string_args("Levels survived: %1", global.level),
		string_args("Score: %1", global.score),
		histr,
		"",
		"Press [SPACE] to start a new game.",
		"Press [ESC] to return to the main menu.",
	];
			
	draw_set_colour(c_white);
	var py = dh / 2 - 64;
	for (var i = 0; i < array_length(lines); i++) {
		var text = lines[i];
		if (text = "") {
			py += string_height("H");
			continue;
		}
				
		var w = string_width(text);
		var h = string_height(text);
				
		draw_text(dw / 2 - w / 2, py, text);
		py += h;
	}
}
else {
	var gspeed = game_get_speed(gamespeed_fps);
	var totalTime = gspeed * RESET_TIME;
	var timeLeft = totalTime - self.timer;

	var bh = 16;

	var x0 = 0;
	var x1 = timeLeft / totalTime * dw;
	var y0 = dh - bh;
	var y1 = dh;
	var hpscale = 4;
	var puscale = 2;
	
	var hx = 2;
	// HP bar
	{
		for (var i = 0; i < obj_player.maxHealth; i++) {
			var img = 1;
			if (i < obj_player.health) {
				img = 0;
			}
		
			var sy = dh - bh - 2 - sprite_get_height(spr_hud_health) * hpscale;
			draw_sprite_ext(spr_hud_health, img, hx, sy, hpscale, hpscale, 0, c_white, 1);
			hx += (sprite_get_width(spr_hud_health) * hpscale + 2);
		}
	}
	
	{
		var px = 4;
		var sy = dh - bh - 2 - sprite_get_height(spr_hud_health) * hpscale;
		
		for (var i = 0; i < Powerups.count; i++) {
			var num = global.powerups[i];
			if (num < 1) {
				continue;
			}
			
			var iw = sprite_get_width(global.POWERUP_SPRITES[i]);
			var ih = sprite_get_height(global.POWERUP_SPRITES[i]);
			
			sy -= (ih + 2) * puscale;
			draw_sprite_ext(global.POWERUP_SPRITES[i], 0, px, sy, puscale, puscale, 0, c_white, 1);
			draw_set_colour(c_white);
			draw_set_alpha(1);
			draw_text_shadow(px + iw * puscale + 2, sy + ih * puscale - string_height(num), num);
		}
	}
	
	// stats text
	{
		draw_set_font(font_main);
		
		var lines = [
			string_args("HP: %1 / %2", max(0, floor(obj_player.health)), obj_player.maxHealth),
			string_args("SCORE: %1", global.score)
		];
		
		var tw = 0;
		var th = 0;
		for (var i = 0; i < array_length(lines); i++) {
			tw = max(tw, string_width(lines[i]));
			th += string_height(th);
		}
		
		var sy = dh - bh - 2;
		
		draw_set_colour(c_black);
		draw_set_alpha(0.5);
		draw_rectangle(hx, sy - th - 2, hx + tw + 2, sy, false);
		
		for (var i = array_length(lines) - 1; i >= 0; i--) {
			var line = lines[i];
			var sh = string_height(line);
			sy -= sh;
			
			draw_set_colour(c_white);
			draw_set_alpha(1);
			draw_text_shadow(hx + 2, sy, line);
		}
	}
	
	// weapons
	
	{
		var lines = [];
		var ids = [];
		var sprites = [];
		for (var i = 0; i < Weapons.count; i++) {
			if (global.weapons[i]) {
				array_push(ids, i);
				array_push(lines, string_args("%1: %2", i + 1, global.WEAPON_NAMES[i]));
				array_push(sprites, global.WEAPON_SPRITES[i]);
			}
		}
		
		var tw = 0;
		var th = 0;
		for (var i = 0; i < array_length(lines); i++) {
			tw = max(tw, string_width(lines[i]) + sprite_get_width(sprites[i]));
			th += max(string_height(lines[i]), sprite_get_height(sprites[i]));
		}
		
		var sx = dw - tw - 4;
		var sy = dh - bh - 2;
		
		draw_set_colour(c_black);
		draw_set_alpha(0.5);
		draw_rectangle(sx, sy - th - 2, sx + tw + 2, sy, false);
		
		for (var i = array_length(lines) - 1; i >= 0; i--) {
			var line = lines[i];
			var wid = ids[i];
			var spr = sprites[i];
			var sh = string_height(line);
			
			var iw = sprite_get_width(spr);
			var ih = sprite_get_height(spr);
			
			sy -= max(ih, sh);
			
			if (wid == global.weapon) {
				draw_set_colour(c_yellow);
			} else {
				draw_set_colour(c_white);
			}
			draw_set_alpha(1);
			draw_text_shadow(sx + iw + 4, sy, line);
			
			draw_sprite_ext(spr, 0, sx + 2, sy, 1, 1, 0, c_white, 1);
		}
	}
	
	// lower bar
	
	draw_set_colour(c_white);
	draw_set_font(font_main);
	
	var timestr = string_args("%1", timeLeft / gspeed);
	var lvlstr = string_args("Level %1", global.level + 1);
	
	draw_set_colour(c_black);
	draw_rectangle(x0, y0, dw, y1, false);
	draw_set_colour(c_red);
	draw_rectangle(x0, y0, x1, y1, false);
	draw_set_colour(c_white);
	draw_text_shadow(x0, y0, timestr);
	draw_text_shadow(dw - string_width(lvlstr), y0, lvlstr);
}