///@desc Asynchronous tests must complete in 1 second
if (progress != maxProgress) {
	assert(false, "GMTwerk 2 asynchronous test timeout");
}
