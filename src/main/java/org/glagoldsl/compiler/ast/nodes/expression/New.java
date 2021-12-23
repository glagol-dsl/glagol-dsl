package org.glagoldsl.compiler.ast.nodes.expression;

import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;

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

    public <T, C> T accept(ExpressionVisitor<T, C> visitor, C context) {
        return visitor.visitNew(this, context);
    }
}
