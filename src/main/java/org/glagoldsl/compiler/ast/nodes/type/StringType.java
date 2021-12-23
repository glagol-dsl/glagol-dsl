package org.glagoldsl.compiler.ast.nodes.type;

public class StringType extends Type {
    @Override
    public String toString() {
        return "string";
    }

    @Override
    public <T, C> T accept(TypeVisitor<T, C> visitor, C context) {
        return visitor.visitStringType(this, context);
    }
}
