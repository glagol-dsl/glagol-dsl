package org.glagoldsl.compiler.ast.expression.binary.arithmetic;

import org.glagoldsl.compiler.ast.expression.Expression;
import org.glagoldsl.compiler.ast.expression.binary.Binary;

public class Addition extends Binary {
    public Addition(Expression left, Expression right) {
        super(left, right);
    }
}
