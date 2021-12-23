package org.glagoldsl.compiler.ast.nodes.statement;

import org.glagoldsl.compiler.ast.nodes.expression.Expression;

public class Remove extends Statement {
    final private Expression expression;

    public Remove(Expression expression) {
        this.expression = expression;
    }

    public Expression getExpression() {
        return expression;
    }

    public <T, C> T accept(StatementVisitor<T, C> visitor, C context) {
        return visitor.visitRemove(this, context);
    }
}
