package org.glagoldsl.compiler.ast.declaration.proxy;

import org.glagoldsl.compiler.ast.Node;

public final class PhpLabel extends Node {
    private final String label;

    public PhpLabel(String label) {
        this.label = label;
    }

    @Override
    public String toString() {
        return label;
    }
}
