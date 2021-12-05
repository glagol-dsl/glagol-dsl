package org.glagoldsl.compiler.ast.expression.unary.arithmetic;

import org.glagoldsl.compiler.ast.expression.Expression;
import org.glagoldsl.compiler.ast.expression.unary.Unary;

public class Negative extends Unary {
    public Negative(Expression expression) {
        super(expression);
    }
}
