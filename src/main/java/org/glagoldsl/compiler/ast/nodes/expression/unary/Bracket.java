package org.glagoldsl.compiler.ast.nodes.expression.unary;

import org.glagoldsl.compiler.ast.nodes.expression.Expression;
import org.glagoldsl.compiler.ast.nodes.expression.ExpressionVisitor;

public class Bracket extends Unary {
    public Bracket(Expression expression) {
        super(expression);
    }

    public <T, C> T accept(ExpressionVisitor<T, C> visitor, C context) {
        return visitor.visitBracket(this, context);
    }
}
