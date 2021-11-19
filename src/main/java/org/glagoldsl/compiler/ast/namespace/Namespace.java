package org.glagoldsl.compiler.ast.namespace;

import org.glagoldsl.compiler.ast.Node;
import org.glagoldsl.compiler.ast.declaration.Declaration;
import org.glagoldsl.compiler.ast.identifier.Identifier;

import java.util.List;

public class Namespace implements Node {
    private final Identifier id;
    private final List<Declaration> declarations;

    public Namespace(Identifier id, List<Declaration> declarations) {
        this.id = id;
        this.declarations = declarations;
    }

    public Identifier getId() {
        return id;
    }

    public List<Declaration> getDeclarations() {
        return declarations;
    }
}
