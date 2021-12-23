package org.glagoldsl.compiler.ast.nodes.type;

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

    @Override
    public <T, C> T accept(TypeVisitor<T, C> visitor, C context) {
        return visitor.visitGListType(this, context);
    }
}
