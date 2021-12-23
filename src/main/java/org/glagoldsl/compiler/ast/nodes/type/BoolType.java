package org.glagoldsl.compiler.ast.nodes.type;

public class BoolType extends Type {
    @Override
    public String toString() {
        return "bool";
    }

    @Override
    public <T, C> T accept(TypeVisitor<T, C> visitor, C context) {
        return visitor.visitBoolType(this, context);
    }
}
