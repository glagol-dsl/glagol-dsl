package org.glagoldsl.compiler.ast.query;

import org.glagoldsl.compiler.ast.Node;
import org.glagoldsl.compiler.ast.query.expression.QueryField;

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
}
