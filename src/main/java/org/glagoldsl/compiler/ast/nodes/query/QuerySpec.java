package org.glagoldsl.compiler.ast.nodes.query;

import org.glagoldsl.compiler.ast.nodes.Node;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;

public class QuerySpec extends Node {
    final private Identifier entity;
    final private boolean multiplicity;

    public QuerySpec(Identifier entity, boolean multiplicity) {
        this.entity = entity;
        this.multiplicity = multiplicity;
    }

    public Identifier getEntity() {
        return entity;
    }

    public boolean isMultiplicity() {
        return multiplicity;
    }

    public <T, C> T accept(QueryVisitor<T, C> visitor, C context) {
        return visitor.visitQuerySpec(this, context);
    }
}
