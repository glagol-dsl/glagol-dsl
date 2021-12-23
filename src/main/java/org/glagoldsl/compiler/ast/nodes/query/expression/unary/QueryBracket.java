package org.glagoldsl.compiler.ast.nodes.query.expression.unary;

import org.glagoldsl.compiler.ast.nodes.query.expression.QueryExpression;
import org.glagoldsl.compiler.ast.nodes.query.expression.QueryExpressionVisitor;

public class QueryBracket extends QueryUnary {
    public QueryBracket(QueryExpression expression) {
        super(expression);
    }

    public <T, C> T accept(QueryExpressionVisitor<T, C> visitor, C context) {
        return visitor.visitQueryBracket(this, context);
    }
}
