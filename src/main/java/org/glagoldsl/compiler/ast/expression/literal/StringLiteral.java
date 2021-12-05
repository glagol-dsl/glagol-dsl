package org.glagoldsl.compiler.ast.expression.literal;

import org.apache.commons.lang3.StringUtils;

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
}
