package org.glagoldsl.compiler.ast.declaration.member.proxy;

import org.glagoldsl.compiler.ast.declaration.member.Accessor;
import org.glagoldsl.compiler.ast.declaration.member.Constructor;
import org.glagoldsl.compiler.ast.declaration.member.method.Body;
import org.glagoldsl.compiler.ast.declaration.member.method.Parameter;

import java.util.ArrayList;
import java.util.List;

public class ProxyConstructor extends Constructor {
    public ProxyConstructor(List<Parameter> parameters) {
        super(
                Accessor.PUBLIC,
                parameters,
                new Body(new ArrayList<>())
        );
    }
}
