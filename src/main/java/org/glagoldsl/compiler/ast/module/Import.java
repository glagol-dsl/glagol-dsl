package org.glagoldsl.compiler.ast.module;

import org.glagoldsl.compiler.ast.Node;
import org.glagoldsl.compiler.ast.identifier.Identifier;

public final class Import extends Node {
    private final Namespace namespace;
    private final Identifier declaration;
    private final Identifier alias;

    public Import(Namespace namespace,
                  Identifier declaration,
                  Identifier alias) {
        this.namespace = namespace;
        this.declaration = declaration;
        this.alias = alias;
    }

    public Namespace getNamespace() {
        return namespace;
    }

    public Identifier getDeclaration() {
        return declaration;
    }

    public Identifier getAlias() {
        return alias;
    }
}
