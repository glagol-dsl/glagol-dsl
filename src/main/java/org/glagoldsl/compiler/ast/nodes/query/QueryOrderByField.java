package org.glagoldsl.compiler.ast.nodes.query;

import org.glagoldsl.compiler.ast.nodes.Node;
import org.glagoldsl.compiler.ast.nodes.query.expression.QueryField;

public class QueryOrderByField extends Node {
    final private QueryField field;
    final private boolean descending;

    public QueryOrderByField(QueryField field, boolean descending) {
        this.field = field;
        this.descending = descending;
    }

    public QueryField getField() {
        return field;
    }

    public boolean isDescending() {
        return descending;
    }

    public <T, C> T accept(QueryVisitor<T, C> visitor, C context) {
        return visitor.visitQueryOrderByField(this, context);
    }
}
