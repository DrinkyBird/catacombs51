var fn = file_find_first("runs/run.*.ini", 0);
while (fn != "") {
	var path = string_args("runs/%1", fn);
	
	ini_open(path);
	var run = {
		runId: ini_read_string("run", "id", ""),
		date: ini_read_real("run", "date", 0),
		score: ini_read_real("run", "score", 0),
		level: ini_read_real("run", "level", 0),
		seed: ini_read_real("run", "worldSeed", 0),
		weapons: [],
		powerups: []
	};
	
	for (var i = 0; i < Weapons.count; i++) {
		array_push(run.weapons, ini_read_real("run", string_args("weapon%1", i), 0));
	}
	
	for (var i = 0; i < Powerups.count; i++) {
		array_push(run.powerups, ini_read_real("run", string_args("powerup%1", i), 0));
	}
	
	ini_close();
	
	array_push(self.runs, run);
	
	fn = file_find_next();
}

file_find_close();

array_sort(self.runs, function(a, b) {
	return sign(b.date - a.date);
});

self.loading = false;