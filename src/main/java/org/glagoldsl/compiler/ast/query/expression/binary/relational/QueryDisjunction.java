package org.glagoldsl.compiler.ast.query.expression.binary.relational;

import org.glagoldsl.compiler.ast.query.expression.QueryExpression;

public class QueryDisjunction extends QueryBinary {
    public QueryDisjunction(QueryExpression left, QueryExpression right) {
        super(left, right);
    }
}
