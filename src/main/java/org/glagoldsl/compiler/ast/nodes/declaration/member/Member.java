package org.glagoldsl.compiler.ast.nodes.declaration.member;

import org.glagoldsl.compiler.ast.nodes.annotation.AnnotatedNode;
import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;

public abstract class Member extends AnnotatedNode {
    abstract public <T, C> T accept(DeclarationVisitor<T, C> visitor, C context);

    public boolean isProperty() {
        return false;
    }

    public boolean isMethod() {
        return false;
    }

    public boolean isConstructor() {
        return false;
    }
}
