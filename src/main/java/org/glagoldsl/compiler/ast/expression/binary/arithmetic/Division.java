package org.glagoldsl.compiler.ast.expression.binary.arithmetic;

import org.glagoldsl.compiler.ast.expression.Expression;
import org.glagoldsl.compiler.ast.expression.binary.Binary;

public class Division extends Binary {
    public Division(Expression left, Expression right) {
        super(left, right);
    }
}
