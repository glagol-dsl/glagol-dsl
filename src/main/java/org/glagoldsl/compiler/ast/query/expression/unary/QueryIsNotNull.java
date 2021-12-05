package org.glagoldsl.compiler.ast.query.expression.unary;

import org.glagoldsl.compiler.ast.query.expression.QueryExpression;

public class QueryIsNotNull extends QueryUnary {
    public QueryIsNotNull(QueryExpression expression) {
        super(expression);
    }
}
