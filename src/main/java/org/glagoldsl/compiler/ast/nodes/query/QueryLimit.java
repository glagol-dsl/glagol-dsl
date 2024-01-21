package org.glagoldsl.compiler.ast.nodes.query;

import org.glagoldsl.compiler.CodeCoverageIgnore;
import org.glagoldsl.compiler.ast.nodes.Node;

@CodeCoverageIgnore
public abstract class QueryLimit extends Node {
    public abstract boolean isDefined();

    abstract public <T, C> T accept(QueryVisitor<T, C> visitor, C context);
}
