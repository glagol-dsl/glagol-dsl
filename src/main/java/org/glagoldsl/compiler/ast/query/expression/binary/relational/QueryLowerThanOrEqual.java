package org.glagoldsl.compiler.ast.query.expression.binary.relational;

import org.glagoldsl.compiler.ast.query.expression.QueryExpression;

public class QueryLowerThanOrEqual extends QueryBinary {
    public QueryLowerThanOrEqual(QueryExpression left, QueryExpression right) {
        super(left, right);
    }
}
