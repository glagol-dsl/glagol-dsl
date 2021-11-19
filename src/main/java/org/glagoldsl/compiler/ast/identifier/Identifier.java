package org.glagoldsl.compiler.ast.identifier;

import org.glagoldsl.compiler.ast.Node;

public class Identifier implements Node {
    private final String id;

    public Identifier(String id) {
        this.id = id;
    }

    @Override
    public String toString() {
        return id;
    }
}
