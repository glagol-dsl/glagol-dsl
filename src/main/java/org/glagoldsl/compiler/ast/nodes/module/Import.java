package org.glagoldsl.compiler.ast.nodes.module;

import org.glagoldsl.compiler.CodeCoverageIgnore;
import org.glagoldsl.compiler.ast.nodes.Node;
import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationPointer;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;

import java.util.Objects;

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

    public DeclarationPointer pointer() {
        return new DeclarationPointer(namespace, declaration);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Import anImport = (Import) o;

        boolean isNamespaceEqual = Objects.equals(namespace, anImport.namespace);
        boolean isDeclarationEqual = Objects.equals(declaration, anImport.declaration);
        boolean isAliasEqual = Objects.equals(alias, anImport.alias);

        return isNamespaceEqual && isDeclarationEqual && isAliasEqual;
    }

    @Override
    @CodeCoverageIgnore
    public int hashCode() {
        return Objects.hash(namespace, declaration, alias);
    }
}
