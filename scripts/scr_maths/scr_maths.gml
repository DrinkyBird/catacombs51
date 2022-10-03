function easeIn(t) {
	return t * t;
}

function flip(t) {
	return 1 - t;
}

function square(t) {
	return t * t;
}

function easeOut(t) {
	return flip(square(flip(t)));
}

function easeInOut(t) {
	return lerp(easeIn(t), easeOut(t), t);
}