package org.glagoldsl.compiler.ast.declaration.member;

import org.glagoldsl.compiler.ast.declaration.member.method.Body;
import org.glagoldsl.compiler.ast.declaration.member.method.Parameter;

import java.util.List;

public class Constructor extends AccessibleMember {
    final private List<Parameter> parameters;
    final private Body body;

    public Constructor(
            Accessor accessor,
            List<Parameter> parameters,
            Body body
    ) {
        super(accessor);
        this.parameters = parameters;
        this.body = body;
    }

    public List<Parameter> getParameters() {
        return parameters;
    }

    public Body getBody() {
        return body;
    }
}
