package org.glagoldsl.compiler.ast.query;

import org.glagoldsl.compiler.ast.Node;
import org.glagoldsl.compiler.ast.identifier.Identifier;

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
}
