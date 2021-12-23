package org.glagoldsl.compiler.ast.nodes.statement;

import org.glagoldsl.compiler.ast.nodes.Node;

public abstract class Statement extends Node {
    public boolean isEmpty() {
        return false;
    }

    abstract public <T, C> T accept(StatementVisitor<T, C> visitor, C context);
}
