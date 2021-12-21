package org.glagoldsl.compiler.ast.statement;

import org.glagoldsl.compiler.ast.expression.Expression;
import org.glagoldsl.compiler.ast.expression.literal.IntegerLiteral;

public class Continue extends Statement {
    final private IntegerLiteral level;

    public Continue(IntegerLiteral level) {
        this.level = level;
    }

    public IntegerLiteral getLevel() {
        return level;
    }
}
