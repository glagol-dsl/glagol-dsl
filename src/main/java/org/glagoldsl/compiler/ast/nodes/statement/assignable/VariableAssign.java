package org.glagoldsl.compiler.ast.nodes.statement.assignable;

import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;

public class VariableAssign extends Assignable {
    final private Identifier name;

    public VariableAssign(Identifier name) {
        this.name = name;
    }

    public Identifier getName() {
        return name;
    }

    public <T, C> T accept(AssignableVisitor<T, C> visitor, C context) {
        return visitor.visitVariableAssign(this, context);
    }
}
