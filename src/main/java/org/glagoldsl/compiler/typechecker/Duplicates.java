package org.glagoldsl.compiler.typechecker;

import org.glagoldsl.compiler.ast.nodes.declaration.*;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.RestController;
import org.glagoldsl.compiler.ast.nodes.declaration.proxy.Proxy;
import org.glagoldsl.compiler.ast.nodes.module.Module;
import org.glagoldsl.compiler.ast.nodes.module.ModuleSet;
import org.glagoldsl.compiler.ast.nodes.module.ModuleVisitor;

import java.util.HashSet;


public class Duplicates implements ModuleVisitor<Void, Environment>, DeclarationVisitor<Void, Environment> {
    /**
     * A bag containing all already loaded declarations.
     */
    private final HashSet<DeclarationPointer> loaded = new HashSet<>();

    @Override
    public Void visitModuleSet(ModuleSet node, Environment context) {
        var environment = context.withModules(node);

        node.forEach(module -> module.accept(this, environment));

        return null;
    }

    @Override
    public Void visitModule(Module node, Environment context) {
        node.getDeclarations().accept(this, context.inModule(node));

        return null;
    }

    @Override
    public Void visitDeclarations(DeclarationCollection node, Environment context) {
        node.forEach(declaration -> declaration.accept(this, context));

        return null;
    }

    @Override
    public Void visitEntity(Entity node, Environment context) {
        check(node, context);

        return null;
    }

    @Override
    public Void visitService(Service node, Environment context) {
        check(node, context);

        return null;
    }

    @Override
    public Void visitValue(Value node, Environment context) {
        check(node, context);

        return null;
    }

    @Override
    public Void visitProxy(Proxy node, Environment context) {
        check(node, context);

        return null;
    }

    @Override
    public Void visitRestController(RestController node, Environment context) {
        check(node, context);

        return null;
    }

    @Override
    public Void visitRepository(Repository node, Environment context) {
        check(node, context);

        return null;
    }

    private void check(Declaration declaration, Environment context) {
        var pointer = declaration.pointer(context.getModule());

        if (loaded.contains(pointer)) {
            context.getErrors().add(new Error(declaration, pointer + " is already defined"));
            return;
        }

        loaded.add(pointer);
    }
}
