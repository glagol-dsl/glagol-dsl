package org.glagoldsl.compiler.ast.nodes.query.expression;

public class QueryEmptyExpression extends QueryExpression {
    public <T, C> T accept(QueryExpressionVisitor<T, C> visitor, C context) {
        return visitor.visitQueryEmptyExpression(this, context);
    }
}
