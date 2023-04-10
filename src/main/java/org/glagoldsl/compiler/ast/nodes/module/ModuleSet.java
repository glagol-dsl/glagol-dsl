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

    public <T, C> T accept(ModuleVisitor<T, C> visitor, C context) {
        return visitor.visitModuleSet(this, context);
    }
}
