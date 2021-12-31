package org.glagoldsl.compiler.ast.nodes.declaration.member.proxy;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.glagoldsl.compiler.ast.nodes.declaration.member.Accessor;
import org.glagoldsl.compiler.ast.nodes.declaration.member.Method;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.Body;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.Parameter;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.WhenEmpty;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.glagoldsl.compiler.ast.nodes.type.Type;

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
                parameters, new WhenEmpty(), new Body(new ArrayList<>())
        );
    }

    public <T, C> T accept(DeclarationVisitor<T, C> visitor, C context) {
        return visitor.visitProxyMethod(this, context);
    }
}
