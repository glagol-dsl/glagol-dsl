package org.glagoldsl.compiler.ast.expression.binary.relational;

import org.glagoldsl.compiler.ast.expression.Expression;
import org.glagoldsl.compiler.ast.expression.binary.Binary;

public class Conjunction extends Binary {
    public Conjunction(Expression left, Expression right) {
        super(left, right);
    }
}
