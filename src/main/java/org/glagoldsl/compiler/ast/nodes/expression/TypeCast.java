package org.glagoldsl.compiler.ast.nodes.expression;

import org.glagoldsl.compiler.ast.nodes.type.Type;

public class TypeCast extends Expression {
    final private Type type;
    final private Expression expression;

    public TypeCast(Type type, Expression expression) {
        this.type = type;
        this.expression = expression;
    }

    public Type getType() {
        return type;
    }

    public Expression getExpression() {
        return expression;
    }

    public <T, C> T accept(ExpressionVisitor<T, C> visitor, C context) {
        return visitor.visitTypeCast(this, context);
    }
}
