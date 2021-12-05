package org.glagoldsl.compiler.ast.expression.binary.relational;

import org.glagoldsl.compiler.ast.expression.Expression;
import org.glagoldsl.compiler.ast.expression.binary.Binary;

public class NonEqual extends Binary {
    public NonEqual(Expression left, Expression right) {
        super(left, right);
    }
}
