#macro ID_CHARS "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
#macro ID_LENGTH 8

#macro SCORE_NEXT_LEVEL 100
#macro SCORE_KILL_ZOMBIE 5
#macro SCORE_KILL_BOSS_ZOMBIE 50
#macro SCORE_KILL_GUN_ZOMBIE 20
#macro SCORE_KILL_FAST_ZOMBIE 10
#macro SCORE_PICK_UP_ITEM 5
#macro SCORE_PICK_UP_WEAPON 30

enum Weapons {
	pistol,
	rifle,
	shotgun,
	chaingun,
	rocketLauncher,
	testGun,
	
	count
};

global.WEAPON_NAMES = [ "Pistol", "Rifle", "Shotgun", "Chaingun", "Rocket Launcher", "Test Gun" ];
global.WEAPON_SPRITES = [ spr_pistol, spr_rifle, spr_shotgun, spr_chaingun, spr_rocketlauncher, spr_pistol ];

enum Powerups {
	maxhp,
	accuracy,
	damage,
	firerate,
	
	count
};

global.POWERUP_NAMES = [ "Max HP", "Accuracy", "Damage", "Fire Rate" ];
global.POWERUP_SPRITES = [ spr_hppowerup, spr_accuracy, spr_damageup, spr_firerate ];

function run_generate_id() {
	randomise();
	var s = "";
	
	for (var i = 0; i < ID_LENGTH; i++) {
		var j = irandom_range(0, string_length(ID_CHARS) - 1);
		var c = string_char_at(ID_CHARS, j);
		s += c;
	}
	
	return s;
}

function settings_load() {
	if (os_browser != browser_not_a_browser) { return; }
	
	ini_open("cata51.ini");
	global.highScore = ini_read_real("game", "highscore", 0);
	global.lastHighScore = global.highScore;
	ini_close();
}

function settings_save() {
	if (os_browser != browser_not_a_browser) { return; }
	
	ini_open("cata51.ini");
	ini_write_real("game", "highscore", global.highScore);
	ini_close();
}

function run_start() {
	run_end();
	
	global.runActive = true;
	global.level = 0;
	global.score = 0;
	global.runId = run_generate_id();
	global.runDateTime = date_current_datetime();
	global.lastHighScore = 0;
	global.weapons = [];
	for (var i = 0; i < Weapons.count; i++) {
		array_push(global.weapons, i == Weapons.pistol || global.debug);
	}
	global.weapon = Weapons.pistol;
	global.powerups = [];
	for (var i = 0; i < Powerups.count; i++) {
		array_push(global.powerups, 0);
	}
	
	randomise();
	global.worldSeed = random_get_seed();
	
	if (room == room_proc) {
		room_restart();
	} else {
		room_goto(room_proc);
	}
	
	settings_load();
}

function run_next_level() {
	audio_play_sound(snd_levelend, 10, false);
	mp_grid_destroy(global.mp);
	global.level++;
	global.score += SCORE_NEXT_LEVEL;
	run_save();
	room_restart();
}

function run_end() {
	if (!global.runActive) {
		return;
	}
	
	global.runId = "";
	mp_grid_destroy(global.mp);
	run_save();
	global.lastHighScore = global.highScore;
	global.runActive = false;
}

function run_save() {
	// can't use on HTML5
	if (os_browser != browser_not_a_browser) {
		return;
	}
	
	// ???
	if (global.runId == "") {
		return;
	}
	
	if (global.score > global.highScore) {
		global.highScore = global.score;
	}
	
	var sect = "run";
	ini_open(string_args("runs/run.%1.ini", global.runId));
	ini_write_string(sect, "id", global.runId);
	ini_write_real(sect, "date", global.runDateTime);
	ini_write_real(sect, "score", global.score);
	ini_write_real(sect, "level", global.level);
	ini_write_real(sect, "worldSeed", global.worldSeed);
	
	for (var i = 0; i < array_length(global.weapons); i++) {
		ini_write_real(sect, string_args("weapon%1", i), global.weapons[i]);
	}
	
	for (var i = 0; i < array_length(global.powerups); i++) {
		ini_write_real(sect, string_args("powerup%1", i), global.powerups[i]);
	}

	ini_close();
	
	settings_save();
}

function reconf_world_shader() {
	shader_set(shd_main);

	var uColour = shader_get_uniform(shd_main, "u_colour");
	shader_set_uniform_f_array(uColour, global.worldColour);
	var uPlayerPos = shader_get_uniform(shd_main, "u_playerPos");

	if (instance_exists(obj_player)) {
		shader_set_uniform_f_array(uPlayerPos, [ obj_player.x, obj_player.y, 0 ]);
	}
	gpu_set_blendenable(true);
	gpu_set_blendmode(bm_normal);
}

function floatytext(xx, yy, colour, text) {
	var o = instance_create_layer(xx, yy, "Instances", obj_floatytext);
	o.colour = colour;
	o.text = text;
}