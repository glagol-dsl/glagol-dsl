package org.glagoldsl.compiler.ast.expression.unary.relational;

import org.glagoldsl.compiler.ast.expression.Expression;
import org.glagoldsl.compiler.ast.expression.unary.Unary;

public class Negation extends Unary {
    public Negation(Expression expression) {
        super(expression);
    }
}
