package org.glagoldsl.compiler.ast.nodes.expression.literal;

import org.glagoldsl.compiler.ast.nodes.expression.ExpressionVisitor;

public class IntegerLiteral extends TypedLiteral<Integer> {
    public IntegerLiteral(Integer value) {
        super(value);
    }

    public long toLong() {
        return (long) getValue();
    }

    public <T, C> T accept(ExpressionVisitor<T, C> visitor, C context) {
        return visitor.visitIntegerLiteral(this, context);
    }
}
