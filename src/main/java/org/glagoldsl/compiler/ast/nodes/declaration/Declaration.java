package org.glagoldsl.compiler.ast.nodes.declaration;

import org.glagoldsl.compiler.ast.nodes.annotation.AnnotatedNode;
import org.glagoldsl.compiler.ast.nodes.module.Module;

public abstract class Declaration extends AnnotatedNode {
    abstract public <T, C> T accept(DeclarationVisitor<T, C> visitor, C context);

    abstract public DeclarationPointer pointer(Module module);

    public boolean isNamed() {
        return false;
    }

    public boolean isNull() {
        return false;
    }
}
