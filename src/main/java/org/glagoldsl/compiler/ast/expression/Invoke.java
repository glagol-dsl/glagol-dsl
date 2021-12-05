package org.glagoldsl.compiler.ast.expression;

import org.glagoldsl.compiler.ast.identifier.Identifier;

import java.util.List;

public class Invoke extends Expression {
    final private Expression prev;
    final private Identifier method;
    final private List<Expression> arguments;

    public Invoke(Expression prev, Identifier method, List<Expression> arguments) {
        this.prev = prev;
        this.method = method;
        this.arguments = arguments;
    }

    public Expression getPrev() {
        return prev;
    }

    public Identifier getMethod() {
        return method;
    }

    public List<Expression> getArguments() {
        return arguments;
    }
}
