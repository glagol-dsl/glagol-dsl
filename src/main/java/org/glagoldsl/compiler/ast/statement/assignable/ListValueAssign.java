package org.glagoldsl.compiler.ast.statement.assignable;

import org.glagoldsl.compiler.ast.expression.Expression;

public class ListValueAssign extends Assignable {
    final private Assignable prev;
    final private Expression key;

    public ListValueAssign(
            Assignable prev,
            Expression key
    ) {
        this.prev = prev;
        this.key = key;
    }

    public Assignable getPrev() {
        return prev;
    }

    public Expression getKey() {
        return key;
    }
}
