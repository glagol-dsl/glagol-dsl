package org.glagoldsl.compiler.ast.declaration.proxy;

import org.glagoldsl.compiler.ast.declaration.Declaration;
import org.glagoldsl.compiler.ast.declaration.NamedDeclaration;
import org.glagoldsl.compiler.ast.declaration.proxy.PhpLabel;

public class Proxy extends Declaration {
    final private PhpLabel phpLabel;
    final private NamedDeclaration declaration;

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
