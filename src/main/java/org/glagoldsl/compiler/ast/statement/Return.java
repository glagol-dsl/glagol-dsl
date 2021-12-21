package org.glagoldsl.compiler.ast.statement;

import org.glagoldsl.compiler.ast.expression.Expression;

public class Return extends Statement {
    final private Expression expression;

    public Return(Expression expression) {
        this.expression = expression;
    }

    public Expression getExpression() {
        return expression;
    }
}
