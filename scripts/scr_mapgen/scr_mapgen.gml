#macro TILE_NOTHING $000000
#macro TILE_WALL $FFFFFF
#macro TILE_WALL_IRREMOVABLE $FAFAFA
#macro TILE_JAILBARS $C0C0C0
#macro TILE_JAILBARS_HORIZ $C1C1C1
#macro TILE_TOILET_DOWN $C2C2C2
#macro TILE_TOILET_UP $C3C3C3
#macro TILE_BED_DOWN $C4C4C4
#macro TILE_BED_UP $C5C5C5
#macro TILE_FLOOR $808080
#macro TILE_CONNECT_1H $FF00FF
#macro TILE_CONNECT_2H $FF00AA
#macro TILE_CONNECT_1W $AA00FF
#macro TILE_CONNECT_2W $AA00AA
#macro TILE_PLAYER $0026FF
#macro TILE_ITEMSPAWNER $2200FF
#macro TILE_BIG_BOSS $22AAFF
#macro TILE_DECOR $267F00

global.CONNECTION_TILES = [
	TILE_CONNECT_1H,
	TILE_CONNECT_2H,
	TILE_CONNECT_1W,
	TILE_CONNECT_2W
];

global.ALL_PIECES = [
	"arena1",
	"arena2",
	"arena3",
	"arena4",
	"corridor0",
	"corridor1",
	"corridor2",
	"corridor3",
	"corridor4",
	"corridor5",
	"corridor6",
	"corridor7",
	"corridor8",
	"corridor9",
	"jails0",
	"jails1",
	//"junction1",
	"spawn0",
	"spawn1",
	"spawn2",
	"spawn3",
	"player",
	"ludumdare",
	"gms"
];

function isInArray(arr, val) {
	for (var i = 0; i < array_length(arr); i++) {
		if (arr[i] == val) {
			return true;
		}
	}
	return false;
}

function packCoord(cx, cy) {
	return (cy << 16) | (cx & $FFFF);
}

function unpackX(val) {
	return val & $FFFF;
}

function unpackY(val) {
	return val >> 16;
}

function Piece(_filename) constructor {
	filename = _filename;
	//pixels = read_bmp(string_args("pieces/%1.bmp", _filename));
	pixels = read_txtrgb(string_args("pieces_text/%1.txt", _filename));
	width = ds_grid_width(pixels);
	height = ds_grid_height(pixels);
	connections = ds_map_create(); // populated by mapgen_analyse_piece
}

function MapGenerator() constructor {
	gw = room_width / 16;
	gh = room_height / 16;
	grid = ds_grid_create(gw, gh);
	neededConnections = ds_queue_create();
	itemPoints = ds_queue_create();
	
	static run = function() {
		randomise();
		mapgen_init();
		
		global.mp = mp_grid_create(0, 0, gw, gh, 16, 16);
		global.worldColour = [ 
			random_range(0.5, 0.8),
			random_range(0.5, 0.8),
			random_range(0.5, 0.8),
			1.0
		];
		
		random_set_seed(global.worldSeed + global.level);
		
		print("Seed: %1", global.worldSeed + global.level);
		print("1: create spawn");
		createSpawn();
		
		print("2: resolve connections");
		while (ds_queue_size(neededConnections) > 0) {
			var val = ds_queue_dequeue(neededConnections);
			var cx = unpackX(val);
			var cy = unpackY(val);
			resolveConnection(cx, cy);
		}
		
		//print("3: open walls");
		//openWalls();
		
		print("4: seal holes");
		sealHoles();
		
		print("5: random replace");
		randomReplace();
		
		print("6: place tiles and objects");
		placeTiles();
		
		print("7: place items");
		placeItems();
		
		print("8: place zombies");
		spawnZombies();
	}
	
	static cleanup = function() { 
		ds_queue_destroy(itemPoints);
		ds_queue_destroy(neededConnections);
		ds_grid_destroy(grid);
	}
	
	static blit = function(piece, bx, by) {
		var w = min(ds_grid_width(piece.pixels), ds_grid_width(grid) - bx);
		var h = min(ds_grid_height(piece.pixels), ds_grid_height(grid) - by);
		
		for (var xx = 0; xx < w; xx++)
		for (var yy = 0; yy < h; yy++) {
			var tx = bx + xx;
			var ty = by + yy;
			
			if (tx < 0 || ty < 0 || tx >= gw || ty >= gh) {
				continue;
			}
			
			var p = piece.pixels[# xx, yy];
			
			switch (p) {
				case TILE_CONNECT_1H:
				case TILE_CONNECT_1W:
				case TILE_CONNECT_2H:
				case TILE_CONNECT_2W: {
					ds_queue_enqueue(neededConnections, packCoord(tx, ty));
					break;
				}
				
				default: {
					break;
				}
			}
			
			if (p != TILE_NOTHING) {
				set(tx, ty, p);
			}
		}
	}
	
	static canBlit = function(piece, bx, by) {
		var w = min(ds_grid_width(piece.pixels), ds_grid_width(grid) - bx);
		var h = min(ds_grid_height(piece.pixels), ds_grid_height(grid) - by);
		
		for (var xx = 0; xx < w; xx++)
		for (var yy = 0; yy < h; yy++) {
			var tx = bx + xx;
			var ty = by + yy;
			
			if (tx < 0 || ty < 0 || tx >= gw || ty>= gh) {
				continue;
			}
			
			var p = piece.pixels[# xx, yy];
			var gp = get(tx, ty);
			
			if (p == TILE_NOTHING || gp == TILE_NOTHING) {
				continue;
			}
			
			if (p != gp) {
				return false;
			}
		}
		
		return true;
	}
	
	static createSpawn = function() { 
		var spawn = pickSpawn();
		blit(spawn, (gw / 2) - (spawn.width / 2), (gh / 2) - (spawn.height / 2));
	}
	
	static resolveConnection = function(cx, cy) {
		if (cx < 0 || cy < 0 || cx >= gw || cy >= gh) {
			return;
		}
			
		var p = grid[# cx, cy];
		
		var success = false;
		
		var qw = gw / 4;
		var qh = gh / 4;
		if (cx < qw || cx > qw * 3 || cy < qh || cy > qh * 3) {
			return;
		}
		
		var m = clamp(global.level / 2, 2, 10);
		
		var candidates = pickConnectionPieces(p);
		for (var j = 0; j < ds_list_size(candidates); j++) {
			var nextPiece = candidates[| j];
			
			for (var i = 0; i < array_length(nextPiece.connections[? p]); i++) {
				var connC = nextPiece.connections[? p][i];
				var connX = unpackX(connC);
				var connY = unpackY(connC);
			
				var bx = cx - connX;
				var by = cy - connY;
			
				if (canBlit(nextPiece, bx, by)) {
					blit(nextPiece, bx, by); 
					set(cx, cy, TILE_FLOOR);
					success = true;
					
					if (p == TILE_CONNECT_2W) {
						set(cx + 1, cy, TILE_FLOOR);
					}
					else if (p == TILE_CONNECT_2H) {
						set(cx, cy - 1, TILE_FLOOR);
					}
				}
			}
			
			if (success) break;
		}
		
		ds_list_destroy(candidates);
	}
	
	static pickSpawn = function() {
		var spawns = [
			"spawn0",
			"spawn1",
			"spawn2",
			"spawn3",
		];
		
		return global.pieces[? spawns[irandom_range(0, array_length(spawns) - 1)]];
	}
	
	static pickConnectionPieces = function(connectorType) {
		 if (!ds_map_exists(global.piecesWithPixels, connectorType)) {
			 return noone;
		 }
		 
		 var candidates = ds_list_create();
		 
		 for (var i = 0; i < ds_list_size(global.piecesWithPixels[? connectorType]); i++) {
			 var piece = global.piecesWithPixels[? connectorType][| i];
			 if (ds_list_find_index(candidates, piece) != -1 || string_count("spawn", piece.filename) != 0) {
				continue;
			 }
			 
			ds_list_add(candidates, piece);
		 }
		 
		 ds_list_shuffle(candidates);
		 
		 return candidates;
	}
	
	static openWalls = function() {
		for (var xx = 0; xx < gw; xx++)
		for (var yy = 0; yy < gh; yy++) {
			var col = grid[# xx, yy];
			var xu = get(xx + 1, yy);
			var xl = get(xx - 1, yy);
			var yu = get(xx, yy + 1);
			var yl = get(xx, yy - 1);
			var r = irandom_range(1, 10) < 2;
			
			if (canOpen(col) && (canOpenAround(xu) && canOpenAround(xl) && canOpenAround(yu) && canOpenAround(yl))) {
				set(xx, yy, TILE_FLOOR);
			}
		}
	}
	
	static canOpen = function(col) {
		return col == TILE_WALL;
	}
	
	static canOpenAround = function(col) {
		return col == TILE_WALL || col == TILE_FLOOR;
	}
	
	static sealHoles = function() {
		for (var xx = 0; xx < gw; xx++)
		for (var yy = 0; yy < gh; yy++) {
			var col = grid[# xx, yy];
			var xu = get(xx + 1, yy);
			var xl = get(xx - 1, yy);
			var yu = get(xx, yy + 1);
			var yl = get(xx, yy - 1);
			
			for (var i = 0; i < array_length(global.CONNECTION_TILES); i++) {
				if (col == global.CONNECTION_TILES[i]) {
					set(xx, yy, TILE_WALL);
					break;
				}
			}
			
			if (col == TILE_NOTHING && (xu == TILE_FLOOR || xl == TILE_FLOOR || yu == TILE_FLOOR || yl == TILE_FLOOR)) {
				set(xx, yy, TILE_WALL);
			}
		}
	}
	
	static randomReplace = function() {
		for (var xx = 0; xx < gw; xx++)
		for (var yy = 0; yy < gh; yy++) {
			var col = grid[# xx, yy];
			
			switch (col) {
				case TILE_BED_DOWN:
				case TILE_BED_UP:
				case TILE_TOILET_DOWN:
				case TILE_TOILET_UP: {
					if (irandom_range(0, 2) == 0) {
						grid[# xx, yy] = TILE_FLOOR;
					}
					
					break;
				}
				
				case TILE_DECOR: {
					if (irandom_range(0, 1) == 0) {
						grid[# xx, yy] = TILE_FLOOR;
					}
					
					break;
				}
				
				case TILE_JAILBARS:
				case TILE_JAILBARS_HORIZ: {
					if (irandom_range(0, 4) == 0) {
						grid[# xx, yy] = TILE_FLOOR;
					}
					
					break;
				}
				
				
				
				default: break;
			}
		}
	}
	
	static placeTiles = function() {
		var wallsId = layer_get_id("Tiles");
		var wallsTm = layer_tilemap_get_id(wallsId);

		var floorId = layer_get_id("Tiles");
		var floorTm = layer_tilemap_get_id(floorId);

		tilemap_clear(wallsTm, 0);
		tilemap_clear(floorTm, 0);
		
		for (var xx = 0; xx < gw; xx++)
		for (var yy = 0; yy < gh; yy++) {
			var col = grid[# xx, yy];
			
			switch (col) {
				case TILE_NOTHING: {
					break;
				}
				
				case TILE_WALL:
				case TILE_WALL_IRREMOVABLE: {
					tilemap_set(wallsTm, 1, xx, yy);
					
					instance_create_layer(xx * 16, yy * 16, "Instances", obj_wall);
					mp_grid_add_cell(global.mp, xx, yy);
					break;
				}
				
				case TILE_JAILBARS: {
					instance_create_layer(xx * 16 + 8, yy * 16 + 8, "Instances", obj_prison_bars);
					mp_grid_add_cell(global.mp, xx, yy);
					tilemap_set(floorTm, 2, xx, yy);
					break;
				}
				
				case TILE_JAILBARS_HORIZ: {
					var i = instance_create_layer(xx * 16 + 8, yy * 16 + 8, "Instances", obj_prison_bars);
					i.image_angle = 90;
					mp_grid_add_cell(global.mp, xx, yy);
					tilemap_set(floorTm, 2, xx, yy);
					break;
				}
				
				case TILE_TOILET_DOWN: {
					var i = instance_create_layer(xx * 16, yy * 16, "Instances", obj_prison_toilet);
					i.image_index = 0;
					mp_grid_add_cell(global.mp, xx, yy);
					tilemap_set(floorTm, 2, xx, yy);
					break;
				}
				
				case TILE_TOILET_UP: {
					var i = instance_create_layer(xx * 16, yy * 16, "Instances", obj_prison_toilet);
					i.image_index = 1;
					mp_grid_add_cell(global.mp, xx, yy);
					tilemap_set(floorTm, 2, xx, yy);
					break;
				}
				
				case TILE_BED_DOWN: {
					var i = instance_create_layer(xx * 16, yy * 16, "Instances", obj_prison_bed);
					i.image_index = 0;
					mp_grid_add_cell(global.mp, xx, yy);
					tilemap_set(floorTm, 2, xx, yy);
					break;
				}
				
				case TILE_BED_UP: {
					var i = instance_create_layer(xx * 16, yy * 16, "Instances", obj_prison_bed);
					i.image_index = 1;
					mp_grid_add_cell(global.mp, xx, yy);
					tilemap_set(floorTm, 2, xx, yy);
					break;
				}
				
				case TILE_FLOOR: {
					var td = 2;
					if (irandom_range(1, 2) == 1) {
						td = tile_set_flip(td, true);
					}
					if (irandom_range(1, 2) == 1) {
						td = tile_set_mirror(td, true);
					}
					
					tilemap_set(floorTm, td, xx, yy);
					
					break;
				}
				
				case TILE_PLAYER: {
					tilemap_set(floorTm, 2, xx, yy);
					instance_create_layer(6 + xx * 16, 6 + yy * 16, "Instances", obj_player);
					break;
				}
				
				case TILE_ITEMSPAWNER: {
					tilemap_set(floorTm, 3, xx, yy);
					ds_queue_enqueue(itemPoints, packCoord(xx, yy));
					break;
				}
				
				case TILE_BIG_BOSS: {
					tilemap_set(floorTm, 2, xx, yy);
					break;
				}
				
				case TILE_DECOR: {
					var types = [ obj_pillar, obj_damagedwall ];
					
					var i = instance_create_layer(xx * 16, yy * 16, "Decor", types[irandom_range(0, array_length(types) - 1)]);
					i.image_index = 1;
					tilemap_set(floorTm, 2, xx, yy);
					break;
				}
				
				default: {
					break;
				}
			}
		}
	}
	
	static placeItems = function() { 
		var placedWpn = false;
		
		while (ds_queue_size(itemPoints) > 0) {
			var packed = ds_queue_dequeue(itemPoints);
			var xx = unpackX(packed);
			var yy = unpackY(packed);
			var sx = xx * 16;
			var sy = yy * 16;
			var weaptype = noone;
			
			if (!placedWpn) {
				if (!global.weapons[Weapons.rifle]) {
					weaptype = obj_rifle;
				}
				
				else if (!global.weapons[Weapons.shotgun] && global.level > 2) {
					weaptype = obj_shotgun;
				}
				
				else if (!global.weapons[Weapons.chaingun] && global.level > 4) {
					weaptype = obj_chaingun;
				}
				
				else if (!global.weapons[Weapons.rocketLauncher] && global.level > 10) {
					weaptype = obj_rocketlauncher;
				}
			}
			
			var powerups = [
				obj_hppowerup,
				obj_accuracypowerup,
				obj_damageup,
				obj_firerateup,
			];
			
			if (weaptype != noone) {
				array_push(powerups, weaptype);
			}
			
			var type = powerups[irandom_range(0, array_length(powerups) - 1)];
			if (!placedWpn && weaptype != noone) {
				type = weaptype;
				placedWpn = true;
			}
			
			instance_create_layer(sx, sy, "Instances", type);
			print("spawn %1", object_get_name(type));
		}
	}
	
	static spawnZombies = function() {
		for (var xx = 0; xx < gw; xx++)
		for (var yy = 0; yy < gh; yy++) {
			var col = grid[# xx, yy];
			
			if (col == TILE_BIG_BOSS) {
				var z = instance_create_layer(6 + xx * 16, 6 + yy* 16, "Instances", obj_boss_zombie);
				z.image_angle = irandom_range(0, 359);
				continue;
			}
			
			if (col != TILE_FLOOR) {
				continue;
			}
			
			var distFromSpawn = point_distance(xx, yy, gw / 2, gh / 2);
			if (irandom_range(0, 10) < max(1, global.level / 4) && distFromSpawn > 7) {
				var type = obj_zombie;
				if (irandom_range(0, 15) < 1) {
					type = obj_gunzombie;
				}
				if (irandom_range(0, 15) < 3) {
					type = obj_fastzombie;
				}
				
				var z = instance_create_layer(6 + xx * 16, 6 + yy * 16, "Instances", type);
				z.image_angle = irandom_range(0, 359);
				
				if (type == obj_gunzombie) {
					if (global.level >= 5 && irandom_range(0, 5) < 1) {
						z.weapon = Weapons.rifle;
					}
					if (global.level >= 10 && irandom_range(0, 5) < 1) {
						z.weapon = Weapons.shotgun;
					}
					if (global.level >= 12 && irandom_range(0, 5) < 1) {
						z.weapon = Weapons.chaingun;
					}
				}
			}
		}
	}
	
	static set = function(tx, ty, tile) {
		if (tx < 0 || ty < 0 || tx >= gw || ty >= gh) {
			return;
		}
	
		grid[# tx, ty] = tile;
	}
	
	static get = function(tx, ty) {
		if (tx < 0 || ty < 0 || tx >= gw || ty >= gh) {
			return TILE_NOTHING;
		}
	
		return grid[# tx, ty];
	}
}

global.mapgen_inited = false;
function mapgen_init() {
	if (global.mapgen_inited) { return; }
	
	global.pieces = ds_map_create();
	global.piecesWithPixels = ds_map_create();
	
	for (var i = 0; i < array_length(global.ALL_PIECES); i++) {
		var name = global.ALL_PIECES[i];
		
		var fn = string_args("pieces/%1.bmp", name);
		global.pieces[? name] = new Piece(name);
		mapgen_analyse_piece(global.pieces[? name]);
	}
	global.mapgen_inited = true;
}

function mapgen_analyse_piece(piece) {
	for (var xx = 0; xx < piece.width; xx++)
	for (var yy = 0; yy < piece.height; yy++) {
		var p = piece.pixels[# xx, yy];
		
		if (!ds_map_exists(global.piecesWithPixels, p)) {
			global.piecesWithPixels[? p] = ds_list_create();
		}
		
		if (ds_list_find_index(global.piecesWithPixels[? p], piece) == -1) {
			ds_list_add(global.piecesWithPixels[? p], piece);
		}
		
		for (var i = 0; i < array_length(global.CONNECTION_TILES); i++) {
			if (p == global.CONNECTION_TILES[i]) {
				if (!ds_map_exists(piece.connections, p)) {
					piece.connections[? p] = [];
				}
				
				array_push(piece.connections[? p], packCoord(xx, yy));
			
				break;
			}
		}
	}
}