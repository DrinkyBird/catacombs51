do {
	global.weapon--;
	if (global.weapon == -1) {
		global.weapon = Weapons.count - 1;
	}
} until (global.weapons[global.weapon]);