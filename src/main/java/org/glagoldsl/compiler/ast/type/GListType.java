package org.glagoldsl.compiler.ast.type;

public class GListType extends Type {
    final private Type type;

    public GListType(Type type) {
        this.type = type;
    }

    public Type getType() {
        return type;
    }

    @Override
    public String toString() {
        return type.toString() + "[]";
    }
}
