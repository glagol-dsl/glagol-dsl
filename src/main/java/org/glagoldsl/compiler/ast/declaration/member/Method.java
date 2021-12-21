package org.glagoldsl.compiler.ast.declaration.member;

import org.glagoldsl.compiler.ast.declaration.member.method.Body;
import org.glagoldsl.compiler.ast.declaration.member.method.Parameter;
import org.glagoldsl.compiler.ast.identifier.Identifier;
import org.glagoldsl.compiler.ast.type.Type;

import java.util.List;

public class Method extends AccessibleMember {
    final private Identifier name;
    final private Type type;
    final private List<Parameter> parameters;
    final private Body body;

    public Method(
            Accessor accessor,
            Type type,
            Identifier name,
            List<Parameter> parameters,
            Body body
    ) {
        super(accessor);
        this.type = type;
        this.name = name;
        this.parameters = parameters;
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
}
