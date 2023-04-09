package org.glagoldsl.compiler.ast.nodes.module;

import org.glagoldsl.compiler.ast.nodes.declaration.Declaration;
import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationCollection;
import org.glagoldsl.compiler.ast.nodes.declaration.NullDeclaration;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.Controller;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.route.Route;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

public class ModuleSet extends HashSet<Module> {
    public Declaration lookupDeclaration(Import anImport) {
        return stream()
                .filter(module -> module.getNamespace().equals(anImport.getNamespace()))
                .map(module -> module.getDeclarations().lookupOne(anImport.getDeclaration()))
                .filter(declaration -> !declaration.isNull())
                .findFirst()
                .orElse(new NullDeclaration());
    }

    public DeclarationCollection lookupDeclarations(Namespace namespace, Identifier declaration) {
        var declarations = new DeclarationCollection();

        for (Module module : this) {
            if (module.getNamespace().equals(namespace)) {
                declarations.addAll(module.getDeclarations().lookupMany(declaration));
            }
        }

        return declarations;
    }


    public List<Controller> lookupControllers(Route route) {
        var controllers = new ArrayList<Controller>();

        for (Module module : this) {
            var moduleControllers = module.getDeclarations().controllers();
            controllers.addAll(moduleControllers.stream().filter(
                    controller -> route.equals(controller.getRoute())).toList());
        }

        return controllers;
    }

    public <T, C> T accept(ModuleVisitor<T, C> visitor, C context) {
        return visitor.visitModuleSet(this, context);
    }
}
