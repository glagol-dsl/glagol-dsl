package org.glagoldsl.compiler.typechecker;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationPointer;
import org.glagoldsl.compiler.ast.nodes.module.*;
import org.glagoldsl.compiler.ast.nodes.module.Module;

import java.util.HashSet;

public class InvalidImport implements ModuleVisitor<Void, Environment> {
    /**
     * A bag containing all available declarations.
     */
    private final HashSet<DeclarationPointer> available = new HashSet<>();

    @Override
    public Void visitModuleSet(
            ModuleSet node, Environment context
    ) {
        var environment = context.withModules(node);

        // load all available declarations
        node.forEach(module -> {
            module.getDeclarations().forEach(declaration -> {
                available.add(declaration.pointer(module));
            });
        });

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
        var pointer = node.pointer();

        if (!available.contains(pointer)) {
            context.getErrors().add(new Error(node, "Invalid import " + node + " - declaration not found"));
        }

        return null;
    }
}
