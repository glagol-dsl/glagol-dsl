package org.glagoldsl.compiler.ast.nodes.type;

public class FloatType extends Type {
    @Override
    public String toString() {
        return "float";
    }

    @Override
    public <T, C> T accept(TypeVisitor<T, C> visitor, C context) {
        return visitor.visitFloatType(this, context);
    }
}
