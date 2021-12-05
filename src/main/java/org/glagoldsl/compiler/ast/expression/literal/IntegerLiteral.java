package org.glagoldsl.compiler.ast.expression.literal;

public class IntegerLiteral extends TypedLiteral<Integer> {
    public IntegerLiteral(Integer value) {
        super(value);
    }

    public long toLong() {
        return (long) getValue();
    }
}
