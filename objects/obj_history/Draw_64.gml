var dw = display_get_gui_width();
var dh = display_get_gui_height();

draw_set_font(font_main);
draw_set_alpha(1);

if (self.loading) {
	var str = "Loading...";
	
	draw_set_colour(c_white);
	draw_text(dw / 2 - string_width(str) / 2, dh / 2 - string_height(str) / 2, str);
} else {
	if (array_length(self.runs) == 0) {
		var str = "No previous runs were found.";
		
		draw_set_colour(c_white);
		draw_text(dw / 2 - string_width(str) / 2, dh / 2 - string_height(str) / 2, str);
	} else {
		var xx = 50;
		var yy = 50;
		
		if (self.selection > 0) {
			draw_sprite_ext(spr_scrollarrow, 0, xx - 16 * 2 + 1, yy + 4 + 1, 1, 1, 0, c_black, 0.2);
			draw_sprite_ext(spr_scrollarrow, 0, xx - 16 * 2, yy + 4, 1, 1, 0, c_white, 1);
		}
	
		for (var i = self.selection; i < min(self.selection + 10, array_length(self.runs)); i++) {
			var run = self.runs[i];
		
			if (self.selection == i) {
				draw_set_colour(c_yellow);
			} else {
				draw_set_colour(c_white);
			}
		
			var str = string_args("Level %1, %2 points", run.level + 1, run.score);
			draw_text_shadow(xx, yy, str);
			yy += string_height(str);
		
			draw_set_colour(c_grey);
			str = date_datetime_string(run.date);
			draw_text_shadow(xx + 10, yy, str);
			yy += string_height(str);
		}
		
		if (self.selection < array_length(self.runs) - 10) {
			draw_sprite_ext(spr_scrollarrow, 0, xx - 16 * 1 + 1, yy - 4 + 1, 1, 1, 180, c_black, 0.2);
			draw_sprite_ext(spr_scrollarrow, 0, xx - 16 * 1, yy - 4, 1, 1, 180, c_white, 1);
		}

		xx = 250;
		yy = 50;
		{
			var run = self.runs[self.selection];
			
			var str = string_args("Run ID %1", run.runId);
			draw_set_colour(c_yellow);
			draw_text_shadow(xx, yy, str);
			yy += string_height(str);
			
			draw_set_colour(c_white);
			str = string_args("Started: %1", date_datetime_string(run.date));
			draw_text_shadow(xx, yy, str);
			yy += string_height(str);
			
			str = string_args("Levels survived: %1", run.level);
			draw_text_shadow(xx, yy, str);
			yy += string_height(str);
			
			str = string_args("Total score: %1", run.score);
			draw_text_shadow(xx, yy, str);
			yy += string_height(str);
			
			yy += 20;
			str = "Weapons";
			draw_text_shadow(xx, yy, str);
			yy += string_height(str);
			
			var sx = xx;
			var ss = 4;
			
			for (var i = 0; i < Weapons.count; i++) {
				if (!run.weapons[i]) {
					continue;
				}
				
				var spr = global.WEAPON_SPRITES[i];
				draw_sprite_ext(spr, 0, sx + ss, yy + ss, ss, ss, 0, c_black, 0.2);
				draw_sprite_ext(spr, 0, sx, yy, ss, ss, 0, c_white, 1);
				sx += ss + sprite_get_width(spr) * ss;
			}
			
			yy += 16 * ss + 10;
			str = "Powerups";
			draw_text_shadow(xx, yy, str);
			yy += string_height(str);
			
			sx = xx;
			
			for (var i = 0; i < Powerups.count; i++) {
				if (!run.powerups[i]) {
					continue;
				}
				
				var spr = global.POWERUP_SPRITES[i];
				var sw = sprite_get_width(spr);
				var sh = sprite_get_height(spr);
				
				draw_sprite_ext(spr, 0, sx + ss, yy + ss, ss, ss, 0, c_black, 0.2);
				draw_sprite_ext(spr, 0, sx, yy, ss, ss, 0, c_white, 1);
				
				var tw = string_width(run.powerups[i]);
				var th = string_height(run.powerups[i]);
				draw_text_shadow(sx + sw * ss - tw - 1, yy + sh * ss, run.powerups[i]);
				
				sx += ss + sw * ss;
			}
		}
	}
	
	{
		var help = "ESC: Main Menu  ";
		if (array_length(self.runs) > 0) {
			help += "UP/W: Up  DOWN/S: Down";
		}
		
		draw_set_colour(c_white);
		draw_text_shadow(2, dh - string_height(help) - 2, help);
	}
}