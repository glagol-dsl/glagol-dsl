package org.glagoldsl.compiler.ast.nodes.expression.binary;

import org.glagoldsl.compiler.ast.nodes.expression.Expression;
import org.glagoldsl.compiler.ast.nodes.expression.ExpressionVisitor;

public class Concatenation extends Binary {
    public Concatenation(Expression left, Expression right) {
        super(left, right);
    }

    public <T, C> T accept(ExpressionVisitor<T, C> visitor, C context) {
        return visitor.visitConcatenation(this, context);
    }
}
