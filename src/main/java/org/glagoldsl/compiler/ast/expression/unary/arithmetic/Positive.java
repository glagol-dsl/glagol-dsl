package org.glagoldsl.compiler.ast.expression.unary.arithmetic;

import org.glagoldsl.compiler.ast.expression.Expression;
import org.glagoldsl.compiler.ast.expression.unary.Unary;

public class Positive extends Unary {
    public Positive(Expression expression) {
        super(expression);
    }
}
