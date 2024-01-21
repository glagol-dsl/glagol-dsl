package org.glagoldsl.compiler.typechecker;


import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.glagoldsl.compiler.ast.nodes.declaration.member.Property;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;

import java.util.HashMap;
import java.util.Map;

class PropertyRedefinition implements DeclarationVisitor<Void, Environment> {
    private final Map<Identifier, Property> loaded = new HashMap<>();

    @Override
    public Void visitProperty(Property node, Environment context) {
        check(node, context);

        return null;
    }

    private void check(Property node, Environment context) {
        var pointer = context.getDeclaration().pointer(context.getModule());
        if (loaded.containsKey(node.getName())) {
            context.getErrors().add(new Error(node, pointer + " -> '" + node.getName() + "' property is already defined"));
            return;
        }

        loaded.put(node.getName(), node);
    }
}