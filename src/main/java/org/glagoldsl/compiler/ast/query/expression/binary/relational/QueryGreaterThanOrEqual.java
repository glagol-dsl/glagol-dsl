package org.glagoldsl.compiler.ast.query.expression.binary.relational;

import org.glagoldsl.compiler.ast.query.expression.QueryExpression;

public class QueryGreaterThanOrEqual extends QueryBinary {
    public QueryGreaterThanOrEqual(QueryExpression left, QueryExpression right) {
        super(left, right);
    }
}
