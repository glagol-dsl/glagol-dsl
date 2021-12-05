package org.glagoldsl.compiler.ast.expression.binary;

import org.glagoldsl.compiler.ast.expression.Expression;

public abstract class Binary extends Expression {
    final private Expression left;
    final private Expression right;

    public Binary(Expression left, Expression right) {
        this.left = left;
        this.right = right;
    }

    public Expression getLeft() {
        return left;
    }

    public Expression getRight() {
        return right;
    }
}
