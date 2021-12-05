package org.glagoldsl.compiler.ast.query.expression;

import org.glagoldsl.compiler.ast.expression.Expression;

public class QueryInterpolation extends QueryExpression {
    final private Expression expression;

    public QueryInterpolation(Expression expression) {
        this.expression = expression;
    }

    public Expression getExpression() {
        return expression;
    }
}
