package org.glagoldsl.compiler.ast.nodes.query.expression.unary;

import org.glagoldsl.compiler.ast.nodes.query.expression.QueryExpression;
import org.glagoldsl.compiler.ast.nodes.query.expression.QueryExpressionVisitor;

public class QueryIsNull extends QueryUnary {
    public QueryIsNull(QueryExpression expression) {
        super(expression);
    }

    public <T, C> T accept(QueryExpressionVisitor<T, C> visitor, C context) {
        return visitor.visitQueryIsNull(this, context);
    }
}
