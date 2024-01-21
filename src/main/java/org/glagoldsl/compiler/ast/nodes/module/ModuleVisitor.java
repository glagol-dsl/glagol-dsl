package org.glagoldsl.compiler.ast.nodes.module;

import org.glagoldsl.compiler.CodeCoverageIgnore;

@CodeCoverageIgnore
public interface ModuleVisitor<T, C> {
    default T visitModuleSet(ModuleSet node, C context) {
        return null;
    }

    default T visitModule(Module node, C context) {
        return null;
    }

    default T visitNamespace(Namespace node, C context) {
        return null;
    }

    default T visitImport(Import node, C context) {
        return null;
    }
}
