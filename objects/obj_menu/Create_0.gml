randomise();
var bgcolour = make_colour_rgb( 
	random_range(0.4, 0.8) * 64,
	random_range(0.4, 0.8) * 64,
	random_range(0.4, 0.8) * 64
);

var bgId = layer_get_id("Background");
var bgBg = layer_background_get_id(bgId);
layer_background_blend(bgBg, bgcolour);
window_set_cursor(cr_none);
cursor_sprite = -1;

self.selection = 0;

var startItem = {
	label: "Start",
	callback: function() {
		run_start();
	}
};

var resumeItem = {
	label: "Resume",
	callback: function() {
		room_goto(room_proc);
	}
};

var helpItem = {
	label: "Help",
	callback: function() {
		room_goto(room_help);
	}
};

var historyItem = {
	label: "History",
	callback: function() {
		room_goto(room_history);
	}
};

var ldPageItem = {
	label: "ldjam.com",
	callback: function() {
		url_open_ext("https://ldjam.com/events/ludum-dare/51/$298574", "_blank");
	}
};

var exitItem = {
	label: "Exit",
	callback: function() {
		game_end();
	}
};

self.items = [ ];
if (global.paused) {
	array_push(self.items, resumeItem);
} else {
	array_push(self.items, startItem);
}
array_push(self.items, helpItem);
if (os_browser == browser_not_a_browser) {
	array_push(self.items, historyItem);
}
array_push(self.items, ldPageItem);
if (os_browser == browser_not_a_browser) {
	array_push(self.items, exitItem);
}