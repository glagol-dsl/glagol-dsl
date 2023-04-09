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

    public Import(Namespace namespace,
                  Identifier declaration) {
        this.namespace = namespace;
        this.declaration = declaration;
        this.alias = declaration;
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

    @Override
    public String toString() {
        return namespace + Namespace.NAMESPACE_DELIMITER + declaration;
    }

    public <T, C> T accept(ModuleVisitor<T, C> visitor, C context) {
        return visitor.visitImport(this, context);
    }
}
