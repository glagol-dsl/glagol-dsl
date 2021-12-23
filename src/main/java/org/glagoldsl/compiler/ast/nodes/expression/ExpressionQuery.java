package org.glagoldsl.compiler.ast.nodes.expression;

import org.glagoldsl.compiler.ast.nodes.query.Query;

public class ExpressionQuery extends Expression {
    final private Query query;

    public ExpressionQuery(Query query) {
        this.query = query;
    }

    public Query getQuery() {
        return query;
    }

    public <T, C> T accept(ExpressionVisitor<T, C> visitor, C context) {
        return visitor.visitExpressionQuery(this, context);
    }
}
