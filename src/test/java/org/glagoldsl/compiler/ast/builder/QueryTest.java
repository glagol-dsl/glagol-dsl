package org.glagoldsl.compiler.ast.builder;

import org.glagoldsl.compiler.ast.Builder;
import org.glagoldsl.compiler.ast.nodes.expression.Variable;
import org.glagoldsl.compiler.ast.nodes.expression.literal.BooleanLiteral;
import org.glagoldsl.compiler.ast.nodes.expression.literal.IntegerLiteral;
import org.glagoldsl.compiler.ast.nodes.query.DefinedQueryLimit;
import org.glagoldsl.compiler.ast.nodes.query.Query;
import org.glagoldsl.compiler.ast.nodes.query.QuerySelect;
import org.glagoldsl.compiler.ast.nodes.query.expression.QueryExpression;
import org.glagoldsl.compiler.ast.nodes.query.expression.QueryField;
import org.glagoldsl.compiler.ast.nodes.query.expression.QueryInterpolation;
import org.glagoldsl.compiler.ast.nodes.query.expression.binary.relational.*;
import org.glagoldsl.compiler.ast.nodes.query.expression.unary.QueryBracket;
import org.glagoldsl.compiler.ast.nodes.query.expression.unary.QueryIsNotNull;
import org.glagoldsl.compiler.ast.nodes.query.expression.unary.QueryIsNull;
import org.junit.jupiter.api.Test;

import java.io.ByteArrayInputStream;

import static org.junit.jupiter.api.Assertions.*;

public class QueryTest {
    @Test
    public void should_build_select_query() {
        var query = (QuerySelect) build("""
            SELECT t FROM test as t
        """);

        assertEquals("t", query.getSpecification().getEntity().toString());
        assertFalse(query.getSpecification().isMultiplicity());

        assertEquals("test", query.getSource().getEntity().toString());
        assertEquals("t", query.getSource().getAlias().toString());

        assertFalse(query.getLimit().isDefined());
    }

    @Test
    public void should_build_select_query_with_interpolation() {
        QuerySelect query = (QuerySelect) build("""
            SELECT t[] FROM test as t WHERE t.test_id = << id >>
        """);

        assertEquals("id", ((Variable) ((QueryInterpolation) ((QueryEqual) query.getWhere()).getRight()).getExpression()).getIdentifier().toString());
    }

    @Test
    public void should_build_select_query_without_offset_limit() {
        var query = (QuerySelect) build("""
            SELECT t[] FROM test as t LIMIT 10
        """);

        assertEquals(10, ((IntegerLiteral) ((QueryInterpolation) ((DefinedQueryLimit) query.getLimit()).getSize()).getExpression()).toLong());
        assertTrue(query.getLimit().isDefined());
    }

    @Test
    public void should_build_select_query_with_offset_limit() {
        var longVariant = (QuerySelect) build("""
            SELECT t[] FROM test as t LIMIT 10 OFFSET 30
        """);

        assertEquals(10, ((IntegerLiteral) ((QueryInterpolation) ((DefinedQueryLimit) longVariant.getLimit()).getSize()).getExpression()).toLong());
        assertEquals(30, ((IntegerLiteral) ((QueryInterpolation) ((DefinedQueryLimit) longVariant.getLimit()).getOffset()).getExpression()).toLong());

        var shortVariant = (QuerySelect) build("""
            SELECT t[] FROM test as t LIMIT 30, 10
        """);

        assertEquals(10, ((IntegerLiteral) ((QueryInterpolation) ((DefinedQueryLimit) shortVariant.getLimit()).getSize()).getExpression()).toLong());
        assertEquals(30, ((IntegerLiteral) ((QueryInterpolation) ((DefinedQueryLimit) shortVariant.getLimit()).getOffset()).getExpression()).toLong());
    }

    @Test
    public void should_build_select_query_with_all_elements() {
        var query = (QuerySelect) build("""
            SELECT t[] FROM test as t WHERE t.id = 23 ORDER BY t.created_at, t.updated_at DESC LIMIT 10, 20
        """);

        assertEquals("t", ((QueryField) ((QueryEqual) query.getWhere()).getLeft()).getEntity().toString());
        assertEquals("id", ((QueryField) ((QueryEqual) query.getWhere()).getLeft()).getProperty().toString());

        assertEquals("t", query.getOrderBy().getFields().get(0).getField().getEntity().toString());
        assertEquals("created_at", query.getOrderBy().getFields().get(0).getField().getProperty().toString());
        assertFalse(query.getOrderBy().getFields().get(0).isDescending());

        assertEquals("t", query.getOrderBy().getFields().get(1).getField().getEntity().toString());
        assertEquals("updated_at", query.getOrderBy().getFields().get(1).getField().getProperty().toString());
        assertTrue(query.getOrderBy().getFields().get(1).isDescending());

        assertEquals(20, ((IntegerLiteral) ((QueryInterpolation) ((DefinedQueryLimit) query.getLimit()).getSize()).getExpression()).toLong());
    }

    @Test
    public void should_build_query_expression_equal() {
        var query = (QuerySelect) build("""
            SELECT a FROM aa a WHERE a.a = 1
        """);
        var expr = (QueryEqual) query.getWhere();
        var left = (QueryField) expr.getLeft();
        var right = (IntegerLiteral) ((QueryInterpolation) expr.getRight()).getExpression();

        assertEquals("a", left.getEntity().toString());
        assertEquals("a", left.getProperty().toString());
        assertEquals(1, right.getValue());
    }

    @Test
    public void should_build_query_expression_gt() {
        var query = (QuerySelect) build("""
            SELECT a FROM aa a WHERE a.a > 1
        """);
        var expr = (QueryGreaterThan) query.getWhere();
        var left = (QueryField) expr.getLeft();
        var right = (IntegerLiteral) ((QueryInterpolation) expr.getRight()).getExpression();

        assertEquals("a", left.getEntity().toString());
        assertEquals("a", left.getProperty().toString());
        assertEquals(1, right.getValue());
    }

    @Test
    public void should_build_query_expression_gte() {
        var query = (QuerySelect) build("""
            SELECT a FROM aa a WHERE a.a >= 1
        """);
        var expr = (QueryGreaterThanOrEqual) query.getWhere();
        var left = (QueryField) expr.getLeft();
        var right = (IntegerLiteral) ((QueryInterpolation) expr.getRight()).getExpression();

        assertEquals("a", left.getEntity().toString());
        assertEquals("a", left.getProperty().toString());
        assertEquals(1, right.getValue());
    }

    @Test
    public void should_build_query_expression_lt() {
        var query = (QuerySelect) build("""
            SELECT a FROM aa a WHERE a.a < 1
        """);
        var expr = (QueryLowerThan) query.getWhere();
        var left = (QueryField) expr.getLeft();
        var right = (IntegerLiteral) ((QueryInterpolation) expr.getRight()).getExpression();

        assertEquals("a", left.getEntity().toString());
        assertEquals("a", left.getProperty().toString());
        assertEquals(1, right.getValue());
    }

    @Test
    public void should_build_query_expression_lte() {
        var query = (QuerySelect) build("""
            SELECT a FROM aa a WHERE a.a <= 1
        """);
        var expr = (QueryLowerThanOrEqual) query.getWhere();
        var left = (QueryField) expr.getLeft();
        var right = (IntegerLiteral) ((QueryInterpolation) expr.getRight()).getExpression();

        assertEquals("a", left.getEntity().toString());
        assertEquals("a", left.getProperty().toString());
        assertEquals(1, right.getValue());
    }

    @Test
    public void should_build_query_expression_ne() {
        var query = (QuerySelect) build("""
            SELECT a FROM aa a WHERE a.a != 1
        """);
        var expr = (QueryNonEqual) query.getWhere();
        var left = (QueryField) expr.getLeft();
        var right = (IntegerLiteral) ((QueryInterpolation) expr.getRight()).getExpression();

        assertEquals("a", left.getEntity().toString());
        assertEquals("a", left.getProperty().toString());
        assertEquals(1, right.getValue());
    }

    @Test
    public void should_build_query_expression_and() {
        var query = (QuerySelect) build("""
            SELECT a FROM aa a WHERE a.a AND 1
        """);
        var expr = (QueryConjunction) query.getWhere();
        var left = (QueryField) expr.getLeft();
        var right = (IntegerLiteral) ((QueryInterpolation) expr.getRight()).getExpression();

        assertEquals("a", left.getEntity().toString());
        assertEquals("a", left.getProperty().toString());
        assertEquals(1, right.getValue());
    }

    @Test
    public void should_build_query_expression_or() {
        var query = (QuerySelect) build("""
            SELECT a FROM aa a WHERE a.a OR 1
        """);
        var expr = (QueryDisjunction) query.getWhere();
        var left = (QueryField) expr.getLeft();
        var right = (IntegerLiteral) ((QueryInterpolation) expr.getRight()).getExpression();

        assertEquals("a", left.getEntity().toString());
        assertEquals("a", left.getProperty().toString());
        assertEquals(1, right.getValue());
    }

    @Test
    public void should_build_query_expression_is_null() {
        var query = (QuerySelect) build("""
            SELECT a FROM aa a WHERE a.a IS NULL
        """);
        var expr = (QueryIsNull) query.getWhere();
        var field = (QueryField) expr.getExpression();

        assertEquals("a", field.getEntity().toString());
        assertEquals("a", field.getProperty().toString());
    }

    @Test
    public void should_build_query_expression_is_not_null() {
        var query = (QuerySelect) build("""
            SELECT a FROM aa a WHERE a.a IS NOT NULL
        """);
        var expr = (QueryIsNotNull) query.getWhere();
        var field = (QueryField) expr.getExpression();

        assertEquals("a", field.getEntity().toString());
        assertEquals("a", field.getProperty().toString());
    }

    @Test
    public void should_build_query_expression_bracket() {
        var query = (QuerySelect) build("""
            SELECT a FROM aa a WHERE (true)
        """);
        var bracket = (QueryBracket) query.getWhere();
        var expr = (QueryInterpolation) bracket.getExpression();
        var literal = (BooleanLiteral) expr.getExpression();

        assertTrue(literal.getValue());
    }

    private Query build(String code) {
        return new Builder().buildQuery(new ByteArrayInputStream(code.getBytes()));
    }
}