package org.glagoldsl.compiler.ast.nodes.query.expression.binary.relational;

import org.glagoldsl.compiler.ast.nodes.query.expression.QueryExpression;
import org.glagoldsl.compiler.ast.nodes.query.expression.QueryExpressionVisitor;

public class QueryDisjunction extends QueryBinary {
    public QueryDisjunction(QueryExpression left, QueryExpression right) {
        super(left, right);
    }

    public <T, C> T accept(QueryExpressionVisitor<T, C> visitor, C context) {
        return visitor.visitQueryDisjunction(this, context);
    }
}
