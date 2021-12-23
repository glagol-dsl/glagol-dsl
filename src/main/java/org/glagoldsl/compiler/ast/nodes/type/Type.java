package org.glagoldsl.compiler.ast.nodes.type;

import org.glagoldsl.compiler.ast.nodes.Node;

public abstract class Type extends Node {
    abstract public String toString();

    abstract public <T, C> T accept(TypeVisitor<T, C> visitor, C context);
}
