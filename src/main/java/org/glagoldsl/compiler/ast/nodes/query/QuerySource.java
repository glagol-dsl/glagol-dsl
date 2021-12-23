package org.glagoldsl.compiler.ast.nodes.query;

import org.glagoldsl.compiler.ast.nodes.Node;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;

public class QuerySource extends Node {
    final private Identifier entity;
    final private Identifier alias;

    public QuerySource(Identifier entity, Identifier alias) {
        this.entity = entity;
        this.alias = alias;
    }

    public Identifier getEntity() {
        return entity;
    }

    public Identifier getAlias() {
        return alias;
    }

    public <T, C> T accept(QueryVisitor<T, C> visitor, C context) {
        return visitor.visitQuerySource(this, context);
    }
}
