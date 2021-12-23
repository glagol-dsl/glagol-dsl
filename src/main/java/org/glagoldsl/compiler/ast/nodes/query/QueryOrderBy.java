package org.glagoldsl.compiler.ast.nodes.query;

import org.glagoldsl.compiler.ast.nodes.Node;

import java.util.List;

public class QueryOrderBy extends Node {
    final private List<QueryOrderByField> fields;

    public QueryOrderBy(List<QueryOrderByField> fields) {
        this.fields = fields;
    }

    public List<QueryOrderByField> getFields() {
        return fields;
    }

    public <T, C> T accept(QueryVisitor<T, C> visitor, C context) {
        return visitor.visitQueryOrderBy(this, context);
    }
}
