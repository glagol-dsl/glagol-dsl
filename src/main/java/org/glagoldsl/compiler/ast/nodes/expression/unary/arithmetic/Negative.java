package org.glagoldsl.compiler.ast.nodes.expression.unary.arithmetic;

import org.glagoldsl.compiler.ast.nodes.expression.Expression;
import org.glagoldsl.compiler.ast.nodes.expression.ExpressionVisitor;
import org.glagoldsl.compiler.ast.nodes.expression.unary.Unary;

public class Negative extends Unary {
    public Negative(Expression expression) {
        super(expression);
    }

    public <T, C> T accept(ExpressionVisitor<T, C> visitor, C context) {
        return visitor.visitNegative(this, context);
    }
}
