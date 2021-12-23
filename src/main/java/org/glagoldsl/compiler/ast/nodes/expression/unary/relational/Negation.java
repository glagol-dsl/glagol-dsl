package org.glagoldsl.compiler.ast.nodes.expression.unary.relational;

import org.glagoldsl.compiler.ast.nodes.expression.Expression;
import org.glagoldsl.compiler.ast.nodes.expression.ExpressionVisitor;
import org.glagoldsl.compiler.ast.nodes.expression.unary.Unary;

public class Negation extends Unary {
    public Negation(Expression expression) {
        super(expression);
    }

    public <T, C> T accept(ExpressionVisitor<T, C> visitor, C context) {
        return visitor.visitNegation(this, context);
    }
}
