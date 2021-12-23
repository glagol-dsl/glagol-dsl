package org.glagoldsl.compiler.ast.nodes.declaration.member;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.Body;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.Parameter;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;

import java.util.List;

public class Action extends Member {
    final private Identifier name;
    final private List<Parameter> parameters;
    final private Body body;

    public Action(
            Identifier name,
            List<Parameter> parameters,
            Body body
    ) {
        this.name = name;
        this.parameters = parameters;
        this.body = body;
    }

    public Identifier getName() {
        return name;
    }

    public List<Parameter> getParameters() {
        return parameters;
    }

    public Body getBody() {
        return body;
    }

    public <T, C> T accept(DeclarationVisitor<T, C> visitor, C context) {
        return visitor.visitAction(this, context);
    }
}
