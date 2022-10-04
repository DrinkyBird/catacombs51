if (array_length(self.runs) > 0 && !global.paused) {
	run_start_with_seed(self.runs[self.selection].seed);
}