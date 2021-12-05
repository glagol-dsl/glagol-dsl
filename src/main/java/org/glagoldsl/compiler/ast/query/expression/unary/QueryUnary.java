package org.glagoldsl.compiler.ast.query.expression.unary;

import org.glagoldsl.compiler.ast.query.expression.QueryExpression;

public abstract class QueryUnary extends QueryExpression {
    final private QueryExpression expression;

    public QueryUnary(QueryExpression expression) {
        this.expression = expression;
    }

    public QueryExpression getExpression() {
        return expression;
    }
}
