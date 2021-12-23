package org.glagoldsl.compiler.ast.nodes.expression.binary.relational;

import org.glagoldsl.compiler.ast.nodes.expression.Expression;
import org.glagoldsl.compiler.ast.nodes.expression.ExpressionVisitor;
import org.glagoldsl.compiler.ast.nodes.expression.binary.Binary;

public class GreaterThan extends Binary {
    public GreaterThan(Expression left, Expression right) {
        super(left, right);
    }

    public <T, C> T accept(ExpressionVisitor<T, C> visitor, C context) {
        return visitor.visitGreaterThan(this, context);
    }
}
