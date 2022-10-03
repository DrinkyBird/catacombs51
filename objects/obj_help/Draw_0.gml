var dw = 448;
var dh = 252;

function dotext(xx, yy, text) {
	if (yy > -self.y + 252) return;
	draw_text_shadow(xx, yy + self.y, text);
}

var text;
var ty = 0;

draw_set_font(font_main)
draw_set_alpha(1);

ty = 20;
draw_set_colour(c_yellow);
text = "HELP";
dotext(dw/2 - string_width(text)/2, ty, text); ty += string_height(text);

ty += 10;

draw_set_colour(c_yellow);
text = "Controls";
dotext(20, ty, text); ty += string_height(text);


draw_set_colour(c_white);
text  = "WASD/arrow keys - Move\n";
text += "Mouse cursor - Aim\n";
text += "Left mouse - Shoot\n";
text += "Scroll wheel - Select weapon\n";
text += "0-5 - Select weapon with given number\n";
text += "Escape - Pause";
dotext(20, ty, text); ty += string_height(text);

ty += 10;

draw_set_colour(c_yellow);
text = "Enemies";
dotext(20, ty, text); ty += string_height(text);

draw_set_colour(c_white);
draw_sprite(spr_zombie, 0, 26, self.y + ty + 8);
text = "Zombie - Slow. Attacks you when it reaches you.";
dotext(36, ty, text); ty += string_height(text);
draw_set_colour(c_white);

draw_sprite(spr_fast_zombie, 0, 26, self.y + ty + 8);
text = "Fast Zombie - A faster variant of the Zombie.";
dotext(36, ty, text); ty += string_height(text);

draw_sprite(spr_gun_zombie, 0, 26, self.y + ty + 8);
text = "Gun Zombie - A Zombie with a gun! They use the same guns as\n you can, and can deal a lot of damage.";
dotext(36, ty, text); ty += string_height(text);

draw_sprite(spr_boss_zombie, 0, 32, self.y + ty + 16);
text = "Big Zombie - Usually found guarding Items. Slower, but they\n can take - and deal - a lot of hits.";
dotext(48, ty, text); ty += string_height(text);

ty += 10;

draw_set_colour(c_yellow);
text = "Weapons";
dotext(20, ty, text); ty += string_height(text);

for (var i = 0; i < Weapons.count; i++) {	
	if (i == Weapons.testGun) continue;
	
	draw_set_colour(c_white);
	draw_sprite(global.WEAPON_SPRITES[i], 0, 20, self.y + ty);
	text = global.WEAPON_NAMES[i] + " - ";
	
	switch (i) 
	{
		case Weapons.pistol: {
			text += "Your default weapon.";
			break;
		}
		
		case Weapons.rifle: {
			text += "High damage, slow fire rate. Its bullets can\n pierce through up to three enemies."
			break;
		}
		
		case Weapons.shotgun: {
			text += "Fires 5 bullet at once! Large spread, large damage.";
			break;
		}
		
		case Weapons.chaingun: {
			text += "Effectively a rapid-fire version of the Pistol.";
			break;
		}
		
		case Weapons.rocketLauncher: {
			text += "Fires rockets that deal massive damage to\n anything within around its target.";
			break;
		}
		
		default: break;
	}
	
	dotext(42, ty, text); ty += string_height(text);
}

ty += 10;

draw_set_colour(c_yellow);
text = "Power-ups";
dotext(20, ty, text); ty += string_height(text);

for (var i = 0; i < Powerups.count; i++) {	
	draw_set_colour(c_white);
	draw_sprite(global.POWERUP_SPRITES[i], 0, 20, self.y + ty + 2);
	text = global.POWERUP_NAMES[i] + " - ";
	
	switch (i) 
	{
		case Powerups.accuracy: {
			text += "Increases the accuracy of your weapons.";
			break;
		}
		
		case Powerups.maxhp: {
			text += "Increases your maximum health."
			break;
		}
		
		case Powerups.damage: {
			text += "Increases the amount of damage your weapons deal.";
			break;
		}
		
		case Powerups.firerate: {
			text += "Makes your weapons shoot faster.";
			break;
		}
		
		default: break;
	}
	
	dotext(38, ty, text); ty += string_height(text);
}