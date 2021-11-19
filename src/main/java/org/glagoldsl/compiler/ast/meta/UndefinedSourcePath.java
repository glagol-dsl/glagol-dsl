package org.glagoldsl.compiler.ast.meta;

public class UndefinedSourcePath extends SourcePath {
    public UndefinedSourcePath() {
        super(null);
    }

    @Override
    public String toString() {
        return "undefined source path";
    }
}
