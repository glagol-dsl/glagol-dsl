package org.glagoldsl.compiler.ast.nodes.statement;

public enum AssignOperator {
    DEFAULT,
    ADDITION,
    SUBTRACTION,
    PRODUCT,
    DIVISION;

    public <T, C> T accept(StatementVisitor<T, C> visitor, C context) {
        return visitor.visitAssignOperator(this, context);
    }
}
