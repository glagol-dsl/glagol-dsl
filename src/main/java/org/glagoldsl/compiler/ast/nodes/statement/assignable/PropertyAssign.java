package org.glagoldsl.compiler.ast.nodes.statement.assignable;

import org.glagoldsl.compiler.ast.nodes.expression.Expression;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;

public class PropertyAssign extends Assignable {
    final private Expression prev;
    final private Identifier property;

    public PropertyAssign(
            Expression prev,
            Identifier property
    ) {
        this.prev = prev;
        this.property = property;
    }

    public Expression getPrev() {
        return prev;
    }

    public Identifier getProperty() {
        return property;
    }

    public <T, C> T accept(AssignableVisitor<T, C> visitor, C context) {
        return visitor.visitPropertyAssign(this, context);
    }
}
