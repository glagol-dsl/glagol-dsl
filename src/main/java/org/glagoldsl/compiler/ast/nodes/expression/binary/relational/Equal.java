package org.glagoldsl.compiler.ast.nodes.expression.binary.relational;

import org.glagoldsl.compiler.ast.nodes.expression.Expression;
import org.glagoldsl.compiler.ast.nodes.expression.ExpressionVisitor;
import org.glagoldsl.compiler.ast.nodes.expression.binary.Binary;

public class Equal extends Binary {
    public Equal(Expression left, Expression right) {
        super(left, right);
    }

    public <T, C> T accept(ExpressionVisitor<T, C> visitor, C context) {
        return visitor.visitEqual(this, context);
    }
}
