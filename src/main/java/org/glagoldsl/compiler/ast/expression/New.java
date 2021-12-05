package org.glagoldsl.compiler.ast.expression;

import org.glagoldsl.compiler.ast.identifier.Identifier;

import java.util.List;

public class New extends Expression {
    final private Identifier target;
    final private List<Expression> arguments;

    public New(Identifier target, List<Expression> arguments) {
        this.target = target;
        this.arguments = arguments;
    }

    public Identifier getTarget() {
        return target;
    }

    public List<Expression> getArguments() {
        return arguments;
    }
}
