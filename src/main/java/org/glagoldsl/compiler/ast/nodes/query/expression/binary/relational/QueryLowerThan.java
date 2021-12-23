package org.glagoldsl.compiler.ast.nodes.query.expression.binary.relational;

import org.glagoldsl.compiler.ast.nodes.query.expression.QueryExpression;
import org.glagoldsl.compiler.ast.nodes.query.expression.QueryExpressionVisitor;

public class QueryLowerThan extends QueryBinary {
    public QueryLowerThan(QueryExpression left, QueryExpression right) {
        super(left, right);
    }

    public <T, C> T accept(QueryExpressionVisitor<T, C> visitor, C context) {
        return visitor.visitQueryLowerThan(this, context);
    }
}
