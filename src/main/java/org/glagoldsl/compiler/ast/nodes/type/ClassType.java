package org.glagoldsl.compiler.ast.nodes.type;

import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;

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

    @Override
    public <T, C> T accept(TypeVisitor<T, C> visitor, C context) {
        return visitor.visitClassType(this, context);
    }
}
