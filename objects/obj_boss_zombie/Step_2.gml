if (self.health <= 0) {
	global.score += SCORE_KILL_BOSS_ZOMBIE;
	floatytext(x, y, c_green, string_args("+%1", SCORE_KILL_BOSS_ZOMBIE));
	instance_destroy();
}