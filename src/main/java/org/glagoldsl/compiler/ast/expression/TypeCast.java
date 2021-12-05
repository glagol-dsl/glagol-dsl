package org.glagoldsl.compiler.ast.expression;

import org.glagoldsl.compiler.ast.type.Type;

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
}
