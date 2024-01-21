package org.glagoldsl.compiler.typechecker;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.glagoldsl.compiler.ast.nodes.declaration.member.Method;
import org.glagoldsl.compiler.ast.nodes.declaration.member.Signature;
import org.glagoldsl.compiler.ast.nodes.declaration.member.proxy.ProxyMethod;

import java.util.HashMap;
import java.util.Map;

class MethodRedefinition implements DeclarationVisitor<Void, Environment> {
    private final Map<Signature, Method> loaded = new HashMap<>();

    @Override
    public Void visitMethod(Method node, Environment context) {

        check(node, context);

        return null;
    }

    @Override
    public Void visitProxyMethod(ProxyMethod node, Environment context) {
        check(node, context);

        return null;
    }

    private void check(Method node, Environment context) {
        var pointer = context.getDeclaration().pointer(context.getModule());
        Signature signature = node.signature();
        if (loaded.containsKey(signature)) {
            context.getErrors().add(new Error(node, pointer + " -> " + signature + " method is already defined"));
            return;
        }

        loaded.put(signature, node);
    }
}
