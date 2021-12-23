package org.glagoldsl.compiler.ast.nodes.statement.assignable;

import org.glagoldsl.compiler.ast.nodes.expression.Expression;

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

    public <T, C> T accept(AssignableVisitor<T, C> visitor, C context) {
        return visitor.visitListValueAssign(this, context);
    }
}
