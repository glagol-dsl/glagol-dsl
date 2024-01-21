package org.glagoldsl.compiler.ast.nodes.declaration.member;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.Body;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.Parameter;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.When;

import java.util.List;

public class Constructor extends AccessibleMember {
    final private List<Parameter> parameters;
    final private When guard;
    final private Body body;

    public Constructor(
            Accessor accessor, List<Parameter> parameters, When guard, Body body
    ) {
        super(accessor);
        this.parameters = parameters;
        this.guard = guard;
        this.body = body;
    }

    public List<Parameter> getParameters() {
        return parameters;
    }

    public Body getBody() {
        return body;
    }

    public When getGuard() {
        return guard;
    }

    @Override
    public boolean isConstructor() {
        return true;
    }

    public ConstructorSignature signature() {
        return new ConstructorSignature(parameters.stream().map(Parameter::getType).toList());
    }

    public <T, C> T accept(DeclarationVisitor<T, C> visitor, C context) {
        return visitor.visitConstructor(this, context);
    }
}
