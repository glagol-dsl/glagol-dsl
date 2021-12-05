package org.glagoldsl.compiler.ast.expression;

import org.glagoldsl.compiler.ast.query.QuerySelect;

public class ExpressionQuery extends Expression {
    final private QuerySelect query;

    public ExpressionQuery(QuerySelect query) {
        this.query = query;
    }

    public QuerySelect getQuery() {
        return query;
    }
}
