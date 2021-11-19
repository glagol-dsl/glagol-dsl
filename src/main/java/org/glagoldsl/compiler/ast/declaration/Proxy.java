package org.glagoldsl.compiler.ast.declaration;

import org.glagoldsl.compiler.ast.declaration.proxy.PhpLabel;

public class Proxy extends Declaration {
    final private PhpLabel phpLabel;
    private final NamedDeclaration declaration;

    public Proxy(PhpLabel phpLabel, NamedDeclaration declaration) {
        this.phpLabel = phpLabel;
        this.declaration = declaration;
    }

    public PhpLabel getPhpLabel() {
        return phpLabel;
    }

    public NamedDeclaration getDeclaration() {
        return declaration;
    }
}
