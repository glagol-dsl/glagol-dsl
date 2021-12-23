package org.glagoldsl.compiler.ast.nodes.query.expression.unary;

import org.glagoldsl.compiler.ast.nodes.query.expression.QueryExpression;
import org.glagoldsl.compiler.ast.nodes.query.expression.QueryExpressionVisitor;

public class QueryIsNotNull extends QueryUnary {
    public QueryIsNotNull(QueryExpression expression) {
        super(expression);
    }

    public <T, C> T accept(QueryExpressionVisitor<T, C> visitor, C context) {
        return visitor.visitQueryIsNotNull(this, context);
    }
}
