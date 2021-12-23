package org.glagoldsl.compiler.ast.nodes.meta;

public class UndefinedSourcePath extends SourcePath {
    public UndefinedSourcePath() {
        super(null);
    }

    @Override
    public String toString() {
        return "undefined source path";
    }
}
