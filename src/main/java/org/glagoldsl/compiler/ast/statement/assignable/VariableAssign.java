package org.glagoldsl.compiler.ast.statement.assignable;

import org.glagoldsl.compiler.ast.identifier.Identifier;

public class VariableAssign extends Assignable {
    final private Identifier name;

    public VariableAssign(Identifier name) {
        this.name = name;
    }

    public Identifier getName() {
        return name;
    }
}
