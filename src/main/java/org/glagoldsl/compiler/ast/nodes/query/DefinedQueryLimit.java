package org.glagoldsl.compiler.ast.nodes.query;

import org.glagoldsl.compiler.ast.nodes.query.expression.QueryExpression;

public class DefinedQueryLimit extends QueryLimit {
    final private QueryExpression size;
    final private QueryExpression offset;

    public DefinedQueryLimit(QueryExpression size, QueryExpression offset) {
        this.size = size;
        this.offset = offset;
    }

    public QueryExpression getSize() {
        return size;
    }

    public QueryExpression getOffset() {
        return offset;
    }

    @Override
    public boolean isDefined() {
        return true;
    }

    public <T, C> T accept(QueryVisitor<T, C> visitor, C context) {
        return visitor.visitDefinedQueryLimit(this, context);
    }
}
