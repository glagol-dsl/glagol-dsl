package org.glagoldsl.compiler.ast.nodes.type;

public class VoidType extends Type {
    @Override
    public String toString() {
        return "void";
    }

    @Override
    public <T, C> T accept(TypeVisitor<T, C> visitor, C context) {
        return visitor.visitVoidType(this, context);
    }
}
