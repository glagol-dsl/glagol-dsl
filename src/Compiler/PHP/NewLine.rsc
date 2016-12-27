module Compiler::PHP::NewLine

public str nl() = "\n";
public str nl(1) = "\n";
public default str nl(int repeat) = ("" | it + "\n" | i <- [0..repeat]);
