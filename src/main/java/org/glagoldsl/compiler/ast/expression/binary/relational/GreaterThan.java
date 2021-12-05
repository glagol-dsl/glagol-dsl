package org.glagoldsl.compiler.ast.expression.binary.relational;

import org.glagoldsl.compiler.ast.expression.Expression;
import org.glagoldsl.compiler.ast.expression.binary.Binary;

public class GreaterThan extends Binary {
    public GreaterThan(Expression left, Expression right) {
        super(left, right);
    }
}
