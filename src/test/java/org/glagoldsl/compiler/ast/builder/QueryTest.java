package org.glagoldsl.compiler.ast.builder;

import org.glagoldsl.compiler.ast.Builder;
import org.glagoldsl.compiler.ast.nodes.expression.Variable;
import org.glagoldsl.compiler.ast.nodes.expression.literal.IntegerLiteral;
import org.glagoldsl.compiler.ast.nodes.query.DefinedQueryLimit;
import org.glagoldsl.compiler.ast.nodes.query.Query;
import org.glagoldsl.compiler.ast.nodes.query.QuerySelect;
import org.glagoldsl.compiler.ast.nodes.query.expression.QueryField;
import org.glagoldsl.compiler.ast.nodes.query.expression.QueryInterpolation;
import org.glagoldsl.compiler.ast.nodes.query.expression.binary.relational.QueryEqual;
import org.junit.jupiter.api.Test;

import java.io.ByteArrayInputStream;

import static org.junit.jupiter.api.Assertions.*;

public class QueryTest {
    @Test
    public void should_build_select_query() {
        QuerySelect query = (QuerySelect) build("""
            SELECT t[] FROM test as t
        """);

        assertEquals("t", query.getSpecification().getEntity().toString());
        assertTrue(query.getSpecification().isMultiplicity());

        assertEquals("test", query.getSource().getEntity().toString());
        assertEquals("t", query.getSource().getAlias().toString());
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
        QuerySelect query = (QuerySelect) build("""
            SELECT t[] FROM test as t LIMIT 10
        """);

        assertEquals(10, ((IntegerLiteral) ((QueryInterpolation) ((DefinedQueryLimit) query.getLimit()).getSize()).getExpression()).toLong());
    }

    @Test
    public void should_build_select_query_with_offset_limit() {
        QuerySelect longVariant = (QuerySelect) build("""
            SELECT t[] FROM test as t LIMIT 10 OFFSET 30
        """);

        assertEquals(10, ((IntegerLiteral) ((QueryInterpolation) ((DefinedQueryLimit) longVariant.getLimit()).getSize()).getExpression()).toLong());
        assertEquals(30, ((IntegerLiteral) ((QueryInterpolation) ((DefinedQueryLimit) longVariant.getLimit()).getOffset()).getExpression()).toLong());

        QuerySelect shortVariant = (QuerySelect) build("""
            SELECT t[] FROM test as t LIMIT 30, 10
        """);

        assertEquals(10, ((IntegerLiteral) ((QueryInterpolation) ((DefinedQueryLimit) shortVariant.getLimit()).getSize()).getExpression()).toLong());
        assertEquals(30, ((IntegerLiteral) ((QueryInterpolation) ((DefinedQueryLimit) shortVariant.getLimit()).getOffset()).getExpression()).toLong());
    }

    @Test
    public void should_build_select_query_with_all_elements() {
        QuerySelect query = (QuerySelect) build("""
            SELECT t[] FROM test as t WHERE t.id = 23 ORDER BY t.created_at, t.updated_at DESC LIMIT 10, 20
        """);

        assertEquals("t", ((QueryField) ((QueryEqual) query.getWhere()).getLeft()).getEntity().toString());
        assertEquals("id", ((QueryField) ((QueryEqual) query.getWhere()).getLeft()).getProperty().toString());

        assertEquals("t", query.getOrderBy().getFields().get(0).getField().getEntity().toString());
        assertEquals("created_at", query.getOrderBy().getFields().get(0).getField().getProperty().toString());

        assertEquals("t", query.getOrderBy().getFields().get(1).getField().getEntity().toString());
        assertEquals("updated_at", query.getOrderBy().getFields().get(1).getField().getProperty().toString());

        assertEquals(20, ((IntegerLiteral) ((QueryInterpolation) ((DefinedQueryLimit) query.getLimit()).getSize()).getExpression()).toLong());
    }

    private Query build(String code) {
        return new Builder().buildQuery(new ByteArrayInputStream(code.getBytes()));
    }
}