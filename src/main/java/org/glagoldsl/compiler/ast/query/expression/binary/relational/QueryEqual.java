package org.glagoldsl.compiler.ast.query.expression.binary.relational;

import org.glagoldsl.compiler.ast.query.expression.QueryExpression;

public class QueryEqual extends QueryBinary {
    public QueryEqual(QueryExpression left, QueryExpression right) {
        super(left, right);
    }
}
