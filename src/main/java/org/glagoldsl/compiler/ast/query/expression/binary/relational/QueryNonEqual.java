package org.glagoldsl.compiler.ast.query.expression.binary.relational;

import org.glagoldsl.compiler.ast.query.expression.QueryExpression;

public class QueryNonEqual extends QueryBinary {
    public QueryNonEqual(QueryExpression left, QueryExpression right) {
        super(left, right);
    }
}
