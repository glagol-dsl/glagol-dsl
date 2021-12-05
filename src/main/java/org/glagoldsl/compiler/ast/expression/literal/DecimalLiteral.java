package org.glagoldsl.compiler.ast.expression.literal;

import java.math.BigDecimal;

public class DecimalLiteral extends TypedLiteral<BigDecimal> {
    public DecimalLiteral(BigDecimal value) {
        super(value);
    }
}
