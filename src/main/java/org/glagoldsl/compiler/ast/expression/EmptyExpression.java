package org.glagoldsl.compiler.ast.expression;

public class EmptyExpression extends Expression {
    @Override
    public boolean isEmpty() {
        return true;
    }
}
