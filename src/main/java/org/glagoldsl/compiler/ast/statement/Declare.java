package org.glagoldsl.compiler.ast.statement;

import org.glagoldsl.compiler.ast.identifier.Identifier;
import org.glagoldsl.compiler.ast.type.Type;

public class Declare extends Statement {
    final private Type type;
    final private Identifier variable;
    final private Statement value;

    public Declare(
            Type type,
            Identifier variable,
            Statement value
    ) {
        this.type = type;
        this.variable = variable;
        this.value = value;
    }

    public Type getType() {
        return type;
    }

    public Identifier getVariable() {
        return variable;
    }

    public Statement getValue() {
        return value;
    }
}
