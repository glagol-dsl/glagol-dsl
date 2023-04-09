package org.glagoldsl.compiler.typechecker;

import org.glagoldsl.compiler.ast.nodes.declaration.*;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.RestController;
import org.glagoldsl.compiler.ast.nodes.declaration.proxy.Proxy;
import org.glagoldsl.compiler.ast.nodes.module.Module;
import org.glagoldsl.compiler.ast.nodes.module.ModuleSet;
import org.glagoldsl.compiler.ast.nodes.module.ModuleVisitor;
import org.glagoldsl.compiler.ast.nodes.module.Namespace;

import java.util.List;

public class DuplicateDeclarations implements ModuleVisitor<Void, Environment>, DeclarationVisitor<Void, Environment> {
    @Override
    public Void visitModuleSet(
            ModuleSet node, Environment context
    ) {
        var environment = context.withModuleSet(node);

        node.forEach(module -> module.accept(this, environment));

        return null;
    }

    @Override
    public Void visitModule(
            Module node, Environment context
    ) {
        node.getDeclarations().accept(this, context.withScope(node));

        return null;
    }

    @Override
    public Void visitEntity(
            Entity node, Environment context
    ) {
        duplicatesCheck(node, context);

        return null;
    }

    @Override
    public Void visitService(
            Service node, Environment context
    ) {
        duplicatesCheck(node, context);

        return null;
    }

    @Override
    public Void visitValue(
            Value node, Environment context
    ) {
        duplicatesCheck(node, context);

        return null;
    }

    @Override
    public Void visitRestController(
            RestController node, Environment context
    ) {
        duplicatesCheck(node, context);

        return null;
    }

    @Override
    public Void visitProxy(
            Proxy node, Environment context
    ) {
        duplicatesCheck(node, context);

        return null;
    }

    private void duplicatesCheck(NamedDeclaration declaration, Environment context) {
        var scope = (Module) context.getScope();
        var namespace = scope.getNamespace();

        var declarations = (List<?>) context.getModules().lookupDeclarations(namespace, declaration.getIdentifier());

        duplicatesCheck(declaration, context, namespace, declarations);
    }

    private void duplicatesCheck(RestController declaration, Environment context) {
        var scope = (Module) context.getScope();
        var namespace = scope.getNamespace();

        var declarations = (List<?>) context.getModules().lookupControllers(declaration.getRoute());

        duplicatesCheck(declaration, context, namespace, declarations);
    }

    private void duplicatesCheck(
            NamedDeclaration declaration, Environment context, Namespace namespace, List<?> declarations
    ) {
        if (declarations.size() > 1) {
            context.getErrors().add(new Error(
                    declaration,
                    namespace + Namespace.NAMESPACE_DELIMITER + declaration + " has already been declared"
            ));
        }
    }

    private void duplicatesCheck(
            Declaration declaration, Environment context, Namespace namespace, List<?> declarations
    ) {
        if (declarations.size() > 1) {
            context.getErrors().add(new Error(
                    declaration,
                    namespace + Namespace.NAMESPACE_DELIMITER + declaration + " has already been declared"
            ));
        }
    }
}
