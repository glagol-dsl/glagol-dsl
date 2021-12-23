package org.glagoldsl.compiler.ast.nodes.statement;

import org.glagoldsl.compiler.ast.nodes.expression.Expression;

public class ExpressionStatement extends Statement {
    final private Expression expression;

    public ExpressionStatement(Expression expression) {
        this.expression = expression;
    }

    public Expression getExpression() {
        return expression;
    }

    public <T, C> T accept(StatementVisitor<T, C> visitor, C context) {
        return visitor.visitExpressionStatement(this, context);
    }
}
