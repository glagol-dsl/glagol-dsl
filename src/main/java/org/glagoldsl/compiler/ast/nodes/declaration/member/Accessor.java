package org.glagoldsl.compiler.ast.nodes.declaration.member;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;

public enum Accessor {
    PUBLIC, PRIVATE;

    public <T, C> T accept(DeclarationVisitor<T, C> visitor, C context) {
        return visitor.visitAccessor(this, context);
    }
}
