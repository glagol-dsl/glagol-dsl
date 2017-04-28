module Utils::Indentation

import String;

private int TAB_SIZE = 4;

public str s(0) = "";
public str s(int level) = ("" | it + " " | i <- [0..level*TAB_SIZE]);
