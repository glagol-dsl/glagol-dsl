package org.glagoldsl.compiler.ast.nodes.expression;

public class This extends Expression {
    public <T, C> T accept(ExpressionVisitor<T, C> visitor, C context) {
        return visitor.visitThis(this, context);
    }
}
