package org.glagoldsl.compiler.ast.nodes.type;

public class IntegerType extends Type {
    @Override
    public String toString() {
        return "int";
    }

    @Override
    public <T, C> T accept(TypeVisitor<T, C> visitor, C context) {
        return visitor.visitIntegerType(this, context);
    }
}
