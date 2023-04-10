package org.glagoldsl.compiler.ast.nodes.declaration;

import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.glagoldsl.compiler.ast.nodes.module.Module;

public abstract class NamedDeclaration extends Declaration {
    final private Identifier identifier;

    @Override
    public DeclarationPointer pointer(Module module) {
        return new DeclarationPointer(module, this);
    }

    public NamedDeclaration(Identifier identifier) {
        this.identifier = identifier;
    }

    public Identifier getIdentifier() {
        return identifier;
    }

    @Override
    public boolean isNamed() {
        return true;
    }
}
