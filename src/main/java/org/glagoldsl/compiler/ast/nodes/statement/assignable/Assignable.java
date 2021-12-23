package org.glagoldsl.compiler.ast.nodes.statement.assignable;

import org.glagoldsl.compiler.ast.nodes.Node;

public abstract class Assignable extends Node {
    abstract public <T, C> T accept(AssignableVisitor<T, C> visitor, C context);
}
