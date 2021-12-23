package org.glagoldsl.compiler.ast.nodes.expression;

import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;

public class Variable extends Expression {
    final private Identifier identifier;

    public Variable(Identifier identifier) {
        this.identifier = identifier;
    }

    public Identifier getIdentifier() {
        return identifier;
    }

    public <T, C> T accept(ExpressionVisitor<T, C> visitor, C context) {
        return visitor.visitVariable(this, context);
    }
}
