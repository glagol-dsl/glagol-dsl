package org.glagoldsl.compiler.ast.expression;

public class Ternary extends Expression {
    final private Expression condition;
    final private Expression then;
    final private Expression els;

    public Ternary(Expression condition, Expression then, Expression els) {
        this.condition = condition;
        this.then = then;
        this.els = els;
    }

    public Expression getCondition() {
        return condition;
    }

    public Expression getThen() {
        return then;
    }

    public Expression getElse() {
        return els;
    }
}
