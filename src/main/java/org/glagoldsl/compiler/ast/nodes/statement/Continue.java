package org.glagoldsl.compiler.ast.nodes.statement;

import org.glagoldsl.compiler.ast.nodes.expression.Expression;
import org.glagoldsl.compiler.ast.nodes.expression.literal.IntegerLiteral;

public class Continue extends Statement {
    final private IntegerLiteral level;

    public Continue(IntegerLiteral level) {
        this.level = level;
    }

    public IntegerLiteral getLevel() {
        return level;
    }

    public <T, C> T accept(StatementVisitor<T, C> visitor, C context) {
        return visitor.visitContinue(this, context);
    }
}
