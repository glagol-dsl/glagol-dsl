package org.glagoldsl.compiler.ast.statement;

import org.glagoldsl.compiler.ast.expression.Expression;

public class Persist extends Statement {
    final private Expression expression;

    public Persist(Expression expression) {
        this.expression = expression;
    }

    public Expression getExpression() {
        return expression;
    }
}
