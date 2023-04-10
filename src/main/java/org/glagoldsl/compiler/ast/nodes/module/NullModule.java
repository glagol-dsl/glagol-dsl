package org.glagoldsl.compiler.ast.nodes.module;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationCollection;

public class NullModule extends Module {
    public NullModule() {
        super(new NullNamespace(), new ImportCollection(), new DeclarationCollection());
    }
}
