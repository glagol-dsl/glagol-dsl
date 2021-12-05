package org.glagoldsl.compiler.ast.expression.binary;

import org.glagoldsl.compiler.ast.expression.Expression;

public class Concatenation extends Binary {
    public Concatenation(Expression left, Expression right) {
        super(left, right);
    }
}
