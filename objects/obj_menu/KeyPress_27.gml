if (global.paused) {
	room_goto(room_proc);
} else if (os_browser == browser_not_a_browser) {
	game_end();
}