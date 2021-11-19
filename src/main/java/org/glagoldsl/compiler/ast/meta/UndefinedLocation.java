package org.glagoldsl.compiler.ast.meta;

public class UndefinedLocation extends Location {
    public UndefinedLocation() {
        super(null, null);
    }

    public int getLine() {
        throw new RuntimeException("Undefined line");
    }

    public int getColumn() {
        throw new RuntimeException("Undefined column");
    }

    @Override
    public String toString() {
        return "line: undefined, column: undefined";
    }
}
