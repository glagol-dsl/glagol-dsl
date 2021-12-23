package org.glagoldsl.compiler.ast.nodes.query.expression;

import org.glagoldsl.compiler.ast.nodes.Node;

public abstract class QueryExpression extends Node {
    abstract public <T, C> T accept(QueryExpressionVisitor<T, C> visitor, C context);
}
