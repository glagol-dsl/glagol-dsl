package org.glagoldsl.compiler.ast.nodes.declaration;

public class NullDeclaration extends Declaration {
    @Override
    public boolean isNull() {
        return true;
    }

    @Override
    public <T, C> T accept(DeclarationVisitor<T, C> visitor, C context) {
        return visitor.visitNullDeclaration(this, context);
    }
}
