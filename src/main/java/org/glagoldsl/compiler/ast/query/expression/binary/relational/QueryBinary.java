package org.glagoldsl.compiler.ast.query.expression.binary.relational;

import org.glagoldsl.compiler.ast.query.expression.QueryExpression;

public abstract class QueryBinary extends QueryExpression {
    final private QueryExpression left;
    final private QueryExpression right;

    public QueryBinary(QueryExpression left, QueryExpression right) {
        this.left = left;
        this.right = right;
    }

    public QueryExpression getLeft() {
        return left;
    }

    public QueryExpression getRight() {
        return right;
    }
}
