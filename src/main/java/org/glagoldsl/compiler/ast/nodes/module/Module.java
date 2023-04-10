package org.glagoldsl.compiler.ast.nodes.module;

import org.glagoldsl.compiler.ast.nodes.Node;
import org.glagoldsl.compiler.ast.nodes.declaration.Declaration;
import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationCollection;

import java.util.List;

public class Module extends Node {
    private final Namespace namespace;
    private final ImportCollection imports;
    private final DeclarationCollection declarations;

    public Module(Namespace namespace,
                  ImportCollection imports,
                  DeclarationCollection declarations) {
        this.namespace = namespace;
        this.imports = imports;
        this.declarations = declarations;
    }

    public Namespace getNamespace() {
        return namespace;
    }

    public ImportCollection getImports() {
        return imports;
    }

    public DeclarationCollection getDeclarations() {
        return declarations;
    }

    public <T, C> T accept(ModuleVisitor<T, C> visitor, C context) {
        return visitor.visitModule(this, context);
    }
}
