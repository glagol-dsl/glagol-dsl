package org.glagoldsl.compiler.ast.nodes.identifier;

public interface IdentifierVisitor<T, C> {
    T visitIdentifier(Identifier node, C context);
}
