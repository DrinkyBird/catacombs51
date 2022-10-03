do {
	global.weapon++;
	if (global.weapon == Weapons.count) {
		global.weapon = 0;
	}
} until (global.weapons[global.weapon]);