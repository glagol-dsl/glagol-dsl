package org.glagoldsl.compiler.ast.nodes.identifier;

import org.glagoldsl.compiler.ast.nodes.Node;

public class Identifier extends Node {
    private final String id;

    public Identifier(String id) {
        this.id = id;
    }

    @Override
    public String toString() {
        return id;
    }

    public <T, C> T accept(IdentifierVisitor<T, C> visitor, C context) {
        return visitor.visitIdentifier(this, context);
    }
}
