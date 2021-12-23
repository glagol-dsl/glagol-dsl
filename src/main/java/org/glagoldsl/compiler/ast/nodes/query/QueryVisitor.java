package org.glagoldsl.compiler.ast.nodes.query;

public interface QueryVisitor<T, C> {
    // query types
    T visitQuerySelect(QuerySelect node, C context);

    // select query elements
    T visitQuerySpec(QuerySpec node, C context);
    T visitQuerySource(QuerySource node, C context);
    T visitQueryOrderBy(QueryOrderBy node, C context);
    T visitQueryOrderByField(QueryOrderByField node, C context);
    T visitDefinedQueryLimit(DefinedQueryLimit node, C context);
    T visitUndefinedQueryLimit(UndefinedQueryLimit node, C context);
}
