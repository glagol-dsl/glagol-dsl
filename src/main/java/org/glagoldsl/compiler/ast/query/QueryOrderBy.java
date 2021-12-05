package org.glagoldsl.compiler.ast.query;

import org.glagoldsl.compiler.ast.Node;

import java.util.List;

public class QueryOrderBy extends Node {
    final private List<QueryOrderByField> fields;

    public QueryOrderBy(List<QueryOrderByField> fields) {
        this.fields = fields;
    }

    public List<QueryOrderByField> getFields() {
        return fields;
    }
}
