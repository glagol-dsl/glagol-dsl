package org.glagoldsl.compiler.ast.declaration.proxy;

import org.glagoldsl.compiler.ast.Node;

public class PhpLabel implements Node {
    final private String label;

    public PhpLabel(String label) {
        this.label = label;
    }

    @Override
    public String toString() {
        return label;
    }
}
