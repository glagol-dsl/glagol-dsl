package org.glagoldsl.compiler.ast.nodes.statement;

import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.glagoldsl.compiler.ast.nodes.type.Type;

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

    public <T, C> T accept(StatementVisitor<T, C> visitor, C context) {
        return visitor.visitDeclare(this, context);
    }
}
