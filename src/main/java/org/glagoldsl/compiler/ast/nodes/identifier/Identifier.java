package org.glagoldsl.compiler.ast.nodes.identifier;

import org.glagoldsl.compiler.ast.nodes.Node;

import java.util.Objects;

public class Identifier extends Node {
    private final String id;

    public Identifier(String id) {
        this.id = id;
    }

    @Override
    public String toString() {
        return id;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Identifier that = (Identifier) o;

        return Objects.equals(id, that.id);
    }

    @Override
    public int hashCode() {
        return id != null ? id.hashCode() : 0;
    }

    public <T, C> T accept(IdentifierVisitor<T, C> visitor, C context) {
        return visitor.visitIdentifier(this, context);
    }
}
