package org.glagoldsl.compiler.ast.nodes.declaration.proxy;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.glagoldsl.compiler.ast.nodes.declaration.NamedDeclaration;

public class Proxy extends NamedDeclaration {
    final private PhpLabel phpLabel;
    final private NamedDeclaration declaration;

    public Proxy(PhpLabel phpLabel, NamedDeclaration declaration) {
        super(declaration.getIdentifier());
        this.phpLabel = phpLabel;
        this.declaration = declaration;
    }

    public PhpLabel getPhpLabel() {
        return phpLabel;
    }

    public NamedDeclaration getDeclaration() {
        return declaration;
    }

    public <T, C> T accept(DeclarationVisitor<T, C> visitor, C context) {
        return visitor.visitProxy(this, context);
    }

    @Override
    public String toString() {
        return "proxy " + getIdentifier();
    }
}
