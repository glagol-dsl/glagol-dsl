package org.glagoldsl.compiler.ast.nodes.expression.literal;

import org.glagoldsl.compiler.ast.nodes.expression.ExpressionVisitor;

import java.math.BigDecimal;

public class DecimalLiteral extends TypedLiteral<BigDecimal> {
    public DecimalLiteral(BigDecimal value) {
        super(value);
    }

    public <T, C> T accept(ExpressionVisitor<T, C> visitor, C context) {
        return visitor.visitDecimalLiteral(this, context);
    }
}
