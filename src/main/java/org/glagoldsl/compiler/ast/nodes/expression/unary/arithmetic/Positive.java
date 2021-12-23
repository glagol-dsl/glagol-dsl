package org.glagoldsl.compiler.ast.nodes.expression.unary.arithmetic;

import org.glagoldsl.compiler.ast.nodes.expression.Expression;
import org.glagoldsl.compiler.ast.nodes.expression.ExpressionVisitor;
import org.glagoldsl.compiler.ast.nodes.expression.unary.Unary;

public class Positive extends Unary {
    public Positive(Expression expression) {
        super(expression);
    }

    public <T, C> T accept(ExpressionVisitor<T, C> visitor, C context) {
        return visitor.visitPositive(this, context);
    }
}
