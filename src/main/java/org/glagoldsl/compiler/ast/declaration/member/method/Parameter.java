package org.glagoldsl.compiler.ast.declaration.member.method;

import org.glagoldsl.compiler.ast.annotation.AnnotatedNode;
import org.glagoldsl.compiler.ast.identifier.Identifier;
import org.glagoldsl.compiler.ast.type.Type;

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
}
