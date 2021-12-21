package org.glagoldsl.compiler.ast.expression;

import org.glagoldsl.compiler.ast.query.Query;

public class ExpressionQuery extends Expression {
    final private Query query;

    public ExpressionQuery(Query query) {
        this.query = query;
    }

    public Query getQuery() {
        return query;
    }
}
