package org.glagoldsl.compiler.ast.query.expression.binary.relational;

import org.glagoldsl.compiler.ast.query.expression.QueryExpression;

public class QueryGreaterThan extends QueryBinary {
    public QueryGreaterThan(QueryExpression left, QueryExpression right) {
        super(left, right);
    }
}
