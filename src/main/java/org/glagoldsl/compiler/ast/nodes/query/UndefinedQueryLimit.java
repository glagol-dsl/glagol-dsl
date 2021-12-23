package org.glagoldsl.compiler.ast.nodes.query;

public class UndefinedQueryLimit extends QueryLimit {
    @Override
    public boolean isDefined() {
        return false;
    }

    public <T, C> T accept(QueryVisitor<T, C> visitor, C context) {
        return visitor.visitUndefinedQueryLimit(this, context);
    }
}
