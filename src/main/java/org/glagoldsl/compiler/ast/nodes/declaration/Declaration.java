package org.glagoldsl.compiler.ast.nodes.declaration;

import org.glagoldsl.compiler.ast.nodes.annotation.AnnotatedNode;

public abstract class Declaration extends AnnotatedNode {
    abstract public <T, C> T accept(DeclarationVisitor<T, C> visitor, C context);
}
