package org.glagoldsl.compiler.ast.nodes.expression;

import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;

public class PropertyAccess extends Expression {
    private final Expression prev;
    private final Identifier property;

    public PropertyAccess(Expression prev, Identifier property) {
        this.prev = prev;
        this.property = property;
    }

    public Expression getPrev() {
        return prev;
    }

    public Identifier getProperty() {
        return property;
    }

    public <T, C> T accept(ExpressionVisitor<T, C> visitor, C context) {
        return visitor.visitPropertyAccess(this, context);
    }
}
