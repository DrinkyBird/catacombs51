var scrollSpeed = 2;

if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
	self.y += scrollSpeed;
}

if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
	self.y -= scrollSpeed;
}

if (keyboard_check(vk_pageup)) {
	self.y += 8;
}

if (keyboard_check(vk_pagedown)) {
	self.y -= 8;
}

self.y = clamp(self.y, -350, 0);