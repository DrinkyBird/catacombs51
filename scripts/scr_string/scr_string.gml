function string_args_impl(str, args) {
	if (array_length(args) == 0) {
		return str;
	}
	
	var out = "";
	var inPct = false;
	
	// Now do all the horrible shit
	for (var i = 1; i < string_length(str) + 1; i++) {
		var c = string_char_at(str, i);
		var n = ord(c);
		
		if (inPct) {
			var failure = true;
			
			// is this a number?
			if (n >= $31 && n <= $39) {
				var index = n - $31;
				// is it in range?
				if (index >= 0 && index < array_length(args)) {
					out += string(args[index]);
					failure = false;
				}
			}
			// if this is another %, just insert it literally
			else if (n == $25) {
				out += "%";
				failure = false;
			}
			
			if (failure) {
				out += "%" + c;
			}
			
			inPct = false;
		} else {
			if (c == "%") {
				inPct = true;
			} else {
				out += c;
			}
		}
	}
	
	return out;
}

function string_args(str) {
	var args = array_create(argument_count - 1);
	for (var i = 1; i < argument_count; i++) {
		args[i - 1] = argument[i];
	}
	
	return string_args_impl(str, args);
}

function print(str) {
	if (argument_count == 0) {
		show_debug_message("");
	} else if (argument_count == 1) {
		show_debug_message(string(str));
	} else {
		var args = array_create(argument_count - 1);
		for (var i = 1; i < argument_count; i++) {
			args[i - 1] = argument[i];
		}
	
		show_debug_message(string_args_impl(str, args));
	}
}

function draw_text_shadow(tx, ty, str) {
	var col = draw_get_colour();
	draw_set_colour(c_black);
	draw_text(tx + 1, ty + 1, str);
	draw_set_colour(col);
	draw_text(tx, ty, str);
}