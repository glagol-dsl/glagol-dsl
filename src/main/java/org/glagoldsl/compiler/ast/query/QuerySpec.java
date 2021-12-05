package org.glagoldsl.compiler.ast.query;

import org.glagoldsl.compiler.ast.Node;
import org.glagoldsl.compiler.ast.identifier.Identifier;

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
}
