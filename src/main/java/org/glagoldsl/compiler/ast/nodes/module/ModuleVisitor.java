package org.glagoldsl.compiler.ast.nodes.module;

public interface ModuleVisitor<T, C> {
    T visitModule(Module node, C context);
    T visitNamespace(Namespace node, C context);
    T visitImport(Import node, C context);
}
