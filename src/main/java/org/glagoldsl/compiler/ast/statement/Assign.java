package org.glagoldsl.compiler.ast.statement;

import org.glagoldsl.compiler.ast.statement.assignable.Assignable;

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
}
