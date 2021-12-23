package org.glagoldsl.compiler.ast.nodes.expression;

public class EmptyExpression extends Expression {
    @Override
    public boolean isEmpty() {
        return true;
    }

    public <T, C> T accept(ExpressionVisitor<T, C> visitor, C context) {
        return visitor.visitEmptyExpression(this, context);
    }
}
