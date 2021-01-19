///@desc Draw progress bar
currentElapsed = elapsed.total();
draw_healthbar(x, y, x+100, y+16, 100*(1-currentElapsed/maxElapsed), c_black, c_white, c_white, 0, true, true);
