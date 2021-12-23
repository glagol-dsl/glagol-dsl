package org.glagoldsl.compiler.ast.nodes.module;

import org.glagoldsl.compiler.ast.nodes.Node;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;

public class Import extends Node {
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

    public <T, C> T accept(ModuleVisitor<T, C> visitor, C context) {
        return visitor.visitImport(this, context);
    }
}
