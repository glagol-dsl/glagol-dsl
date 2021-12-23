package org.glagoldsl.compiler.ast.nodes.expression;

import org.glagoldsl.compiler.ast.nodes.Node;

public abstract class Expression extends Node {
    public boolean isEmpty() {
        return false;
    }

    abstract public <T, C> T accept(ExpressionVisitor<T, C> visitor, C context);
}
