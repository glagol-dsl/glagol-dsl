package org.glagoldsl.compiler.ast.module;

import org.glagoldsl.compiler.ast.Node;
import org.glagoldsl.compiler.ast.declaration.Declaration;

import java.util.List;

public final class Module extends Node {
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
}
