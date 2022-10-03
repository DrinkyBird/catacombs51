// https://gist.github.com/alaingalvan/2a37bc4619b2e67415638522f03ac42f

function read_bmp(filename) {
	var handle;
	handle = file_bin_open(filename, 0);
	var offset, width, height, bits, output;
	offset = 29;
	width = 0;
	height = 0;
	bits = 0;

	var i;
	for (i = 0; i < offset; i += 1) {
	  if (i == 10)
	    offset = file_bin_read_byte(handle);
	  else
	  if (i == 11)
	    offset += file_bin_read_byte(handle) << 8;
	  else
	  if (i == 12)
	    offset += file_bin_read_byte(handle) << 16;
	  else
	  if (i == 13)
	    offset += file_bin_read_byte(handle) << 24;
	  else
	  if (i == 18)
	    width = file_bin_read_byte(handle);
	  else
	  if (i == 19)
	    width += file_bin_read_byte(handle) << 8;
	  else
	  if (i == 20)
	    width += file_bin_read_byte(handle) << 16;
	  else
	  if (i == 21)
	    width += file_bin_read_byte(handle) << 24;
	  else
	  if (i == 22)
	    height = file_bin_read_byte(handle);
	  else
	  if (i == 19)
	    height += file_bin_read_byte(handle) << 8;
	  else
	  if (i == 20)
	    height += file_bin_read_byte(handle) << 16;
	  else
	  if (i == 21)
	    height += file_bin_read_byte(handle) << 24;
	  else
	  if (i == 28)
	    bits = file_bin_read_byte(handle);
	  else
	    file_bin_read_byte(handle); // Skip
	}

	var output;
	output = ds_grid_create(width, height);

	var j;
	for (j = 0; j < height; j += 1) {
	  for (i = 0; i < width; i += 1) {

	    var r, g, b, value;
	    r = file_bin_read_byte(handle);
	    g = file_bin_read_byte(handle) << 8;
	    b = file_bin_read_byte(handle) << 16;
	    if (bits == 32)
	      file_bin_read_byte(handle);

	    value = r + g + b;

	    ds_grid_set(output, i, (height-1)-j, value);
	  }
	  if (bits == 24) {
	    // Padding
	    for (h = 0; h < (width * 3) mod 4; h += 1) {
	      //file_bin_read_byte(handle);
	    }
	  }
	}

	file_bin_close(handle);

	return output;
}

function read_txtrgb(filename) {
	var handle = file_text_open_read(filename);
	var width = file_text_read_real(handle);
	var height = file_text_read_real(handle);
	var grid = ds_grid_create(width, height);
	
	/*
	var xx = 0, yy = 0, total = 0;
	do {
		var count = file_text_read_real(handle);
		var colour = file_text_read_real(handle);
		
		for (var i = 0; i < count; i++) {
			grid[# xx, yy] = colour;
			xx++;
			if (xx == width) {
				xx = 0;
				yy++;
			}
			print("%1, %2", xx, yy);
			//total++;
		}
		total += count;
	} until (file_text_eof(handle));
	
	if (total != width * height) {
		show_error(string_args("mismatch: %1 =/= %2", total, width * height), true);
	}
	//*/
	
	for (var xx = 0; xx < width; xx++)
	for (var yy = 0; yy < height; yy++) {
		ds_grid_set(grid, xx, yy, file_text_read_real(handle));
	}
	
	return grid;
}