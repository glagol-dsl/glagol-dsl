package org.glagoldsl.compiler.ast.query.expression.binary.relational;

import org.glagoldsl.compiler.ast.query.expression.QueryExpression;

public class QueryLowerThan extends QueryBinary {
    public QueryLowerThan(QueryExpression left, QueryExpression right) {
        super(left, right);
    }
}
