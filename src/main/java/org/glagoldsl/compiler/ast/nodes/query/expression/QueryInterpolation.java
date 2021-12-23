package org.glagoldsl.compiler.ast.nodes.query.expression;

import org.glagoldsl.compiler.ast.nodes.expression.Expression;

public class QueryInterpolation extends QueryExpression {
    final private Expression expression;

    public QueryInterpolation(Expression expression) {
        this.expression = expression;
    }

    public Expression getExpression() {
        return expression;
    }

    public <T, C> T accept(QueryExpressionVisitor<T, C> visitor, C context) {
        return visitor.visitQueryInterpolation(this, context);
    }
}
