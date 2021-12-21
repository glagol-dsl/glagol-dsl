package org.glagoldsl.compiler.ast.statement;

public class EmptyStatement extends Statement {
    @Override
    public boolean isEmpty() {
        return true;
    }
}
