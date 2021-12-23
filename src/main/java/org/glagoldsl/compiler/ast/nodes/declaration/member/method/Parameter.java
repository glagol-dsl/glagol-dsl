package org.glagoldsl.compiler.ast.nodes.declaration.member.method;

import org.glagoldsl.compiler.ast.nodes.annotation.AnnotatedNode;
import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.glagoldsl.compiler.ast.nodes.type.Type;

public class Parameter extends AnnotatedNode {
    final private Type type;
    final private Identifier name;

    public Parameter(
            Type type,
            Identifier name
    ) {
        this.type = type;
        this.name = name;
    }

    public Type getType() {
        return type;
    }

    public Identifier getName() {
        return name;
    }

    public <T, C> T accept(DeclarationVisitor<T, C> visitor, C context) {
        return visitor.visitParameter(this, context);
    }
}
