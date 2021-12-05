package org.glagoldsl.compiler.ast.query;

import org.glagoldsl.compiler.ast.query.expression.QueryExpression;

public class QuerySelect extends Query {
    final private QuerySpec specification;
    final private QuerySource source;
    final private QueryExpression where;
    final private QueryOrderBy orderBy;
    final private QueryLimit limit;

    public QuerySelect(
            QuerySpec specification,
            QuerySource source,
            QueryExpression where,
            QueryOrderBy orderBy,
            QueryLimit limit
    ) {
        this.specification = specification;
        this.source = source;
        this.where = where;
        this.orderBy = orderBy;
        this.limit = limit;
    }

    public QuerySpec getSpecification() {
        return specification;
    }

    public QuerySource getSource() {
        return source;
    }

    public QueryExpression getWhere() {
        return where;
    }

    public QueryOrderBy getOrderBy() {
        return orderBy;
    }

    public QueryLimit getLimit() {
        return limit;
    }
}
