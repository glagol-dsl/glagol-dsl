package org.glagoldsl.compiler.ast.nodes.declaration.member.proxy;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.glagoldsl.compiler.ast.nodes.declaration.member.Accessor;
import org.glagoldsl.compiler.ast.nodes.declaration.member.Constructor;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.Body;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.Parameter;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.WhenEmpty;

import java.util.ArrayList;
import java.util.List;

public class ProxyConstructor extends Constructor {
    public ProxyConstructor(List<Parameter> parameters) {
        super(
                Accessor.PUBLIC,
                parameters, new WhenEmpty(), new Body(new ArrayList<>())
        );
    }

    public <T, C> T accept(DeclarationVisitor<T, C> visitor, C context) {
        return visitor.visitProxyConstructor(this, context);
    }
}
