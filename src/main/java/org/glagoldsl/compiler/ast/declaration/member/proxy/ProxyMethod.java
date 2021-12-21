package org.glagoldsl.compiler.ast.declaration.member.proxy;

import org.glagoldsl.compiler.ast.declaration.member.Accessor;
import org.glagoldsl.compiler.ast.declaration.member.Method;
import org.glagoldsl.compiler.ast.declaration.member.method.Body;
import org.glagoldsl.compiler.ast.declaration.member.method.Parameter;
import org.glagoldsl.compiler.ast.identifier.Identifier;
import org.glagoldsl.compiler.ast.type.Type;

import java.util.ArrayList;
import java.util.List;

public class ProxyMethod extends Method {
    public ProxyMethod(
            Type type,
            Identifier name,
            List<Parameter> parameters
    ) {
        super(
                Accessor.PUBLIC,
                type,
                name,
                parameters,
                new Body(new ArrayList<>())
        );
    }
}
