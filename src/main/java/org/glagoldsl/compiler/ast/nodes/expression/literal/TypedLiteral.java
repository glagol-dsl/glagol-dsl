package org.glagoldsl.compiler.ast.nodes.expression.literal;

public abstract class TypedLiteral<T> extends Literal {
    final private T value;

    public TypedLiteral(T value) {
        this.value = value;
    }

    public T getValue() {
        return value;
    }
}
