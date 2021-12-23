package org.glagoldsl.compiler.ast.nodes.statement;

public class EmptyStatement extends Statement {
    @Override
    public boolean isEmpty() {
        return true;
    }

    public <T, C> T accept(StatementVisitor<T, C> visitor, C context) {
        return visitor.visitEmptyStatement(this, context);
    }
}
