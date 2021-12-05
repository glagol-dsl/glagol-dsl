package org.glagoldsl.compiler.ast.query;

public class UndefinedQueryLimit extends QueryLimit {
    @Override
    public boolean isDefined() {
        return false;
    }
}
