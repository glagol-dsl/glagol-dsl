package org.glagoldsl.compiler.ast.query.expression;

import org.glagoldsl.compiler.ast.identifier.Identifier;

public class QueryField extends QueryExpression {
    final private Identifier entity;
    final private Identifier property;

    public QueryField(Identifier entity, Identifier property) {
        this.entity = entity;
        this.property = property;
    }

    public Identifier getEntity() {
        return entity;
    }

    public Identifier getProperty() {
        return property;
    }
}
