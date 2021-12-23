package org.glagoldsl.compiler.ast.nodes.expression.literal;

import org.glagoldsl.compiler.ast.nodes.expression.ExpressionVisitor;

public class BooleanLiteral extends TypedLiteral<Boolean> {
    public BooleanLiteral(Boolean value) {
        super(value);
    }

    public <T, C> T accept(ExpressionVisitor<T, C> visitor, C context) {
        return visitor.visitBooleanLiteral(this, context);
    }
}
