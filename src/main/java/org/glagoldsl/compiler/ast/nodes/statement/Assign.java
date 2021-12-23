package org.glagoldsl.compiler.ast.nodes.statement;

import org.glagoldsl.compiler.ast.nodes.statement.assignable.Assignable;

public class Assign extends Statement {
    final private Assignable assignable;
    final private AssignOperator operator;
    final private Statement value;

    public Assign(
            Assignable assignable,
            AssignOperator operator,
            Statement value
    ) {
        this.assignable = assignable;
        this.operator = operator;
        this.value = value;
    }

    public Assignable getAssignable() {
        return assignable;
    }

    public AssignOperator getOperator() {
        return operator;
    }

    public Statement getValue() {
        return value;
    }

    public <T, C> T accept(StatementVisitor<T, C> visitor, C context) {
        return visitor.visitAssign(this, context);
    }
}
