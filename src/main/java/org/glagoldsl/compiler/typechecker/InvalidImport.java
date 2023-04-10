package org.glagoldsl.compiler.typechecker;

import org.glagoldsl.compiler.ast.nodes.module.*;
import org.glagoldsl.compiler.ast.nodes.module.Module;

public class InvalidImport implements ModuleVisitor<Void, Environment> {
    @Override
    public Void visitModuleSet(
            ModuleSet node, Environment context
    ) {
        var environment = context.withModules(node);

        node.forEach(module -> module.accept(this, environment));

        return null;
    }

    @Override
    public Void visitModule(
            Module node, Environment context
    ) {
        var environment = context.inModule(node);
        node.getImports().forEach(anImport -> anImport.accept(this, environment));

        return null;
    }

    @Override
    public Void visitImport(
            Import node, Environment context
    ) {
        if (context.getModules().lookupDeclaration(node).isNull()) {
            context.getErrors().add(new Error(node, "Invalid import " + node + " - declaration not found"));
        }

        return null;
    }
}
