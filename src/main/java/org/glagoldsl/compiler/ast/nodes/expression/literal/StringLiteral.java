package org.glagoldsl.compiler.ast.nodes.expression.literal;

import org.apache.commons.lang3.StringUtils;
import org.glagoldsl.compiler.ast.nodes.expression.ExpressionVisitor;

public class StringLiteral extends TypedLiteral<String> {
    public StringLiteral(String value) {
        super(value);
    }

    @Override
    public String toString() {
        return getValue();
    }

    public static StringLiteral createFromQuoted(String value) {
        return new StringLiteral(StringUtils.strip(value, "\"").translateEscapes());
    }

    public <T, C> T accept(ExpressionVisitor<T, C> visitor, C context) {
        return visitor.visitStringLiteral(this, context);
    }
}
