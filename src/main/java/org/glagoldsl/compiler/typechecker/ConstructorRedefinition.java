package org.glagoldsl.compiler.typechecker;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.glagoldsl.compiler.ast.nodes.declaration.member.Constructor;
import org.glagoldsl.compiler.ast.nodes.declaration.member.ConstructorSignature;
import org.glagoldsl.compiler.ast.nodes.declaration.member.proxy.ProxyConstructor;

import java.util.HashMap;
import java.util.Map;

class ConstructorRedefinition implements DeclarationVisitor<Void, Environment> {
    private final Map<ConstructorSignature, Constructor> loaded = new HashMap<>();

    @Override
    public Void visitConstructor(Constructor node, Environment context) {
        check(node, context);

        return null;
    }

    @Override
    public Void visitProxyConstructor(ProxyConstructor node, Environment context) {
        check(node, context);

        return null;
    }

    private void check(Constructor node, Environment context) {
        var pointer = context.getDeclaration().pointer(context.getModule());
        ConstructorSignature signature = node.signature();
        if (loaded.containsKey(signature)) {
            context.getErrors().add(new Error(node, pointer + " -> " + signature + " is already defined"));
            return;
        }

        loaded.put(signature, node);
    }
}
