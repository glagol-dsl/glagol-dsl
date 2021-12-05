package org.glagoldsl.compiler.ast.expression.binary.relational;

import org.glagoldsl.compiler.ast.expression.Expression;
import org.glagoldsl.compiler.ast.expression.binary.Binary;

public class Equal extends Binary {
    public Equal(Expression left, Expression right) {
        super(left, right);
    }
}
