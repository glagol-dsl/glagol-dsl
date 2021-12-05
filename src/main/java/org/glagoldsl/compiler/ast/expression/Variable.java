package org.glagoldsl.compiler.ast.expression;

import org.glagoldsl.compiler.ast.identifier.Identifier;

public class Variable extends Expression {
    final private Identifier identifier;

    public Variable(Identifier identifier) {
        this.identifier = identifier;
    }

    public Identifier getIdentifier() {
        return identifier;
    }
}
