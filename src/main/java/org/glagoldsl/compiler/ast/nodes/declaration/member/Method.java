package org.glagoldsl.compiler.ast.nodes.declaration.member;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.Body;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.Parameter;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.When;
import org.glagoldsl.compiler.ast.nodes.expression.Expression;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.glagoldsl.compiler.ast.nodes.type.Type;

import java.util.List;

public class Method extends AccessibleMember {
    final private Identifier name;
    final private Type type;
    final private List<Parameter> parameters;
    final private When guard;
    final private Body body;

    public Method(Accessor accessor, Type type, Identifier name, List<Parameter> parameters, When guard, Body body) {
        super(accessor);
        this.type = type;
        this.name = name;
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

    public Identifier getName() {
        return name;
    }

    public Type getType() {
        return type;
    }

    public When getGuard() {
        return guard;
    }

    @Override
    public boolean isMethod() {
        return true;
    }

    public Signature signature() {
        List<Type> types = parameters.stream().map(Parameter::getType).toList();
        return new Signature(name, types);
    }

    public <T, C> T accept(DeclarationVisitor<T, C> visitor, C context) {
        return visitor.visitMethod(this, context);
    }
}
