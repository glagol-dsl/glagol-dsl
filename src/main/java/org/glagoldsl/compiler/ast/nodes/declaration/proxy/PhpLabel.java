package org.glagoldsl.compiler.ast.nodes.declaration.proxy;

import org.glagoldsl.compiler.ast.nodes.Node;
import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;

public class PhpLabel extends Node {
    private final String label;

    public PhpLabel(String label) {
        this.label = label;
    }

    @Override
    public String toString() {
        return label;
    }

    public <T, C> T accept(DeclarationVisitor<T, C> visitor, C context) {
        return visitor.visitPhpLabel(this, context);
    }
}
