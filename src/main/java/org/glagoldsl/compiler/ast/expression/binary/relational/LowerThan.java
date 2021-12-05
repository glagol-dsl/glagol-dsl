package org.glagoldsl.compiler.ast.expression.binary.relational;

import org.glagoldsl.compiler.ast.expression.Expression;
import org.glagoldsl.compiler.ast.expression.binary.Binary;

public class LowerThan extends Binary {
    public LowerThan(Expression left, Expression right) {
        super(left, right);
    }
}
