package org.glagoldsl.compiler.ast.query.expression.binary.relational;

import org.glagoldsl.compiler.ast.query.expression.QueryExpression;

public class QueryConjunction extends QueryBinary {
    public QueryConjunction(QueryExpression left, QueryExpression right) {
        super(left, right);
    }
}
