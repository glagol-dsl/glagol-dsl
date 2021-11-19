package org.glagoldsl.compiler.ast.declaration;

import org.glagoldsl.compiler.ast.identifier.Identifier;

public class Repository extends Declaration {
    final private Identifier entityIdentifier;

    public Repository(Identifier identifier) {
        this.entityIdentifier = identifier;
    }

    public Identifier getEntityIdentifier() {
        return entityIdentifier;
    }
}
