package org.glagoldsl.compiler.ast.nodes.declaration;

import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;

public abstract class NamedDeclaration extends Declaration {
    final private Identifier identifier;

    public NamedDeclaration(Identifier identifier) {
        this.identifier = identifier;
    }

    public Identifier getIdentifier() {
        return identifier;
    }
}
