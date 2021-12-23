package org.glagoldsl.compiler.ast.nodes.meta;

public class Location {
    final private Integer line;
    final private Integer column;

    public Location(Integer line, Integer column) {
        this.line = line;
        this.column = column;
    }

    public int getLine() {
        return line;
    }

    public int getColumn() {
        return column;
    }

    @Override
    public String toString() {
        return "line: " + this.line + ", column: " + this.column;
    }
}
