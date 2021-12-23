package org.glagoldsl.compiler.ast.nodes.query.expression;

import org.glagoldsl.compiler.ast.nodes.query.expression.binary.relational.*;
import org.glagoldsl.compiler.ast.nodes.query.expression.unary.QueryBracket;
import org.glagoldsl.compiler.ast.nodes.query.expression.unary.QueryIsNotNull;
import org.glagoldsl.compiler.ast.nodes.query.expression.unary.QueryIsNull;

public interface QueryExpressionVisitor<T, C> {
    // binary
    T visitQueryConjunction(QueryConjunction node, C context);
    T visitQueryDisjunction(QueryDisjunction node, C context);
    T visitQueryEqual(QueryEqual node, C context);
    T visitQueryGreaterThan(QueryGreaterThan node, C context);
    T visitQueryGreaterThanOrEqual(QueryGreaterThanOrEqual node, C context);
    T visitQueryLowerThan(QueryLowerThan node, C context);
    T visitQueryLowerThanOrEqual(QueryLowerThanOrEqual node, C context);
    T visitQueryNonEqual(QueryNonEqual node, C context);

    // unary
    T visitQueryBracket(QueryBracket node, C context);
    T visitQueryIsNotNull(QueryIsNotNull node, C context);
    T visitQueryIsNull(QueryIsNull node, C context);

    // misc
    T visitQueryEmptyExpression(QueryEmptyExpression node, C context);
    T visitQueryField(QueryField node, C context);
    T visitQueryInterpolation(QueryInterpolation node, C context);
}
