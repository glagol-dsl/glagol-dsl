package org.glagoldsl.compiler.ast.statement.assignable;

import org.glagoldsl.compiler.ast.expression.Expression;
import org.glagoldsl.compiler.ast.identifier.Identifier;

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
}
