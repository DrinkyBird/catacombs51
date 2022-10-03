/// @description generate map
randomise();

var gen = new MapGenerator();
gen.run();
gen.cleanup();

self.loadScreen = false;
obj_player.flashColour = c_white;
obj_player.flashEnd = global.clock + 60;
obj_player.flashAlphaDivide = 1;