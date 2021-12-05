package org.glagoldsl.compiler.ast.type;

import org.glagoldsl.compiler.ast.identifier.Identifier;

public class ClassType extends Type {
    final private Identifier name;

    public ClassType(Identifier name) {
        this.name = name;
    }

    public Identifier getName() {
        return name;
    }

    @Override
    public String toString() {
        return name.toString();
    }
}
