package org.glagoldsl.compiler.ast.nodes.query.expression;

import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;

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

    public <T, C> T accept(QueryExpressionVisitor<T, C> visitor, C context) {
        return visitor.visitQueryField(this, context);
    }
}
