package org.glagoldsl.compiler.ast.nodes.module;

import org.glagoldsl.compiler.ast.nodes.Node;
import org.glagoldsl.compiler.ast.nodes.declaration.Declaration;

import java.util.List;

public class Module extends Node {
    private final Namespace namespace;
    private final List<Import> imports;
    private final List<Declaration> declarations;

    public Module(Namespace namespace,
                  List<Import> imports,
                  List<Declaration> declarations) {
        this.namespace = namespace;
        this.imports = imports;
        this.declarations = declarations;
    }

    public Namespace getNamespace() {
        return namespace;
    }

    public List<Import> getImports() {
        return imports;
    }

    public List<Declaration> getDeclarations() {
        return declarations;
    }

    public <T, C> T accept(ModuleVisitor<T, C> visitor, C context) {
        return visitor.visitModule(this, context);
    }
}
