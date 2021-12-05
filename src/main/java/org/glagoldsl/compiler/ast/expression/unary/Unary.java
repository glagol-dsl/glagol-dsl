package org.glagoldsl.compiler.ast.expression.unary;

import org.glagoldsl.compiler.ast.expression.Expression;

public abstract class Unary extends Expression {
    final private Expression expression;

    public Unary(Expression expression) {
        this.expression = expression;
    }

    public Expression getExpression() {
        return expression;
    }
}
