package org.glagoldsl.compiler.ast.builder;

import org.glagoldsl.compiler.ast.Builder;
import org.glagoldsl.compiler.ast.nodes.expression.*;
import org.glagoldsl.compiler.ast.nodes.expression.binary.Binary;
import org.glagoldsl.compiler.ast.nodes.expression.binary.Concatenation;
import org.glagoldsl.compiler.ast.nodes.expression.binary.arithmetic.Addition;
import org.glagoldsl.compiler.ast.nodes.expression.binary.arithmetic.Division;
import org.glagoldsl.compiler.ast.nodes.expression.binary.arithmetic.Product;
import org.glagoldsl.compiler.ast.nodes.expression.binary.arithmetic.Subtraction;
import org.glagoldsl.compiler.ast.nodes.expression.binary.relational.*;
import org.glagoldsl.compiler.ast.nodes.expression.literal.BooleanLiteral;
import org.glagoldsl.compiler.ast.nodes.expression.literal.DecimalLiteral;
import org.glagoldsl.compiler.ast.nodes.expression.literal.IntegerLiteral;
import org.glagoldsl.compiler.ast.nodes.expression.literal.StringLiteral;
import org.glagoldsl.compiler.ast.nodes.expression.unary.Bracket;
import org.glagoldsl.compiler.ast.nodes.expression.unary.arithmetic.Negative;
import org.glagoldsl.compiler.ast.nodes.expression.unary.arithmetic.Positive;
import org.glagoldsl.compiler.ast.nodes.expression.unary.relational.Negation;
import org.glagoldsl.compiler.ast.nodes.query.QuerySelect;
import org.junit.jupiter.api.Test;

import java.io.ByteArrayInputStream;

import static org.junit.jupiter.api.Assertions.*;

public class ExpressionTest {

    @Test
    public void should_build_brackets() {
        var singleBrackets = build("(123)");

        assertEquals(123, (long) ((IntegerLiteral) ((Bracket) singleBrackets).getExpression()).getValue());

        var nestedBrackets = build("((123))");

        assertEquals(123, (long) ((IntegerLiteral) ((Bracket) ((Bracket) nestedBrackets).getExpression()).getExpression()).getValue());
    }

    @Test
    public void should_build_literals() {
        var simpleString = (StringLiteral) build("\"test\"");
        var escapedString = (StringLiteral) build("\"\\\"test\"");

        assertEquals("test", simpleString.getValue());
        assertEquals("\"test", escapedString.getValue());
        assertEquals("test", simpleString.toString());
        assertEquals("\"test", escapedString.toString());

        var booleanTrue = (BooleanLiteral) build("true");
        var booleanFalse = (BooleanLiteral) build("false");

        assertTrue(booleanTrue.getValue());
        assertFalse(booleanFalse.getValue());

        var integer = (IntegerLiteral) build("23");

        assertEquals(23, integer.toLong());

        var decimal = (DecimalLiteral) build("2.2222222222333333");

        assertEquals("2.2222222222333333", decimal.getValue().toString());
    }

    @Test
    public void should_build_list() {
        var list = (GList) build("""
            [1, 2, 3, 4]
        """);

        assertEquals(1, ((IntegerLiteral) list.getExpressions().get(0)).toLong());
        assertEquals(2, ((IntegerLiteral) list.getExpressions().get(1)).toLong());
        assertEquals(3, ((IntegerLiteral) list.getExpressions().get(2)).toLong());
        assertEquals(4, ((IntegerLiteral) list.getExpressions().get(3)).toLong());
    }

    @Test
    public void should_build_map() {
        var map = (GMap) build("""
            {"key": "value"}
        """);

        assertEquals(1, map.getPairs().size());

        map.getPairs().forEach((key, value) -> {
            assertEquals("key", ((StringLiteral) key).getValue());
            assertEquals("value", ((StringLiteral) value).getValue());
        });
    }

    @Test
    public void should_build_variable() {
        var var = (Variable) build("""
            variable
        """);

        assertEquals("variable", var.getIdentifier().toString());
    }

    @Test
    public void should_build_new_instance() {
        var newInstance = (New) build("""
            new Instance()
        """);

        assertEquals("Instance", newInstance.getTarget().toString());
    }

    @Test
    public void should_build_new_instance_with_arguments() {
        var newInstance = (New) build("""
            new Instance(1, 2, "3")
        """);

        assertEquals("Instance", newInstance.getTarget().toString());
        assertEquals(3, newInstance.getArguments().size());
    }

    @Test
    public void should_build_invocation() {
        var invoke = (Invoke) build("""
            method(1)
        """);

        assertEquals("method", invoke.getMethod().toString());
        assertTrue(invoke.getPrev() instanceof This);
        assertEquals(1, ((IntegerLiteral) invoke.getArguments().get(0)).toLong());

        var invokeWithNesting = (Invoke) build("""
            this.method(1).that().method2()
        """);

        assertEquals("method2", invokeWithNesting.getMethod().toString());
        assertTrue(invokeWithNesting.getPrev() instanceof Invoke);
    }

    @Test
    public void should_build_property_access() {
        var propertyAccess = (PropertyAccess) build("""
            that.that.that_final
        """);

        assertEquals("that_final", propertyAccess.getProperty().toString());
        assertTrue(propertyAccess.getPrev() instanceof PropertyAccess);
    }

    @Test
    public void should_build_unary_expressions() {
        var negative = (Negative) build("-33");
        var positive = (Positive) build("+33");
        var negate = (Negation) build("!true");

        assertEquals(33, ((IntegerLiteral) negative.getExpression()).toLong());
        assertEquals(33, ((IntegerLiteral) positive.getExpression()).toLong());
        assertEquals(true, ((BooleanLiteral) negate.getExpression()).getValue());
    }

    @Test
    public void should_build_type_cast() {
        var typeCastInt = (TypeCast) build("(int) \"10\"");
        var typeCastBool = (TypeCast) build("(bool) 0");
        var typeCastFloat = (TypeCast) build("(float) 0");
        var typeCastString = (TypeCast) build("(string) 0");
        var typeCastClass = (TypeCast) build("(MyClass) 0");
        var typeCastList = (TypeCast) build("(int[]) 0");
        var typeCastMap = (TypeCast) build("({int,string}) 0");
        var typeCastRepository = (TypeCast) build("(repository<Book>) 0");
        var typeCastVoid = (TypeCast) build("(void) 0");

        assertEquals("int", typeCastInt.getType().toString());
        assertTrue(typeCastInt.getExpression() instanceof StringLiteral);
        assertEquals("bool", typeCastBool.getType().toString());
        assertTrue(typeCastBool.getExpression() instanceof IntegerLiteral);
        assertEquals("float", typeCastFloat.getType().toString());
        assertTrue(typeCastFloat.getExpression() instanceof IntegerLiteral);
        assertEquals("string", typeCastString.getType().toString());
        assertTrue(typeCastString.getExpression() instanceof IntegerLiteral);
        assertEquals("MyClass", typeCastClass.getType().toString());
        assertTrue(typeCastClass.getExpression() instanceof IntegerLiteral);
        assertEquals("int[]", typeCastList.getType().toString());
        assertTrue(typeCastList.getExpression() instanceof IntegerLiteral);
        assertEquals("{int,string}", typeCastMap.getType().toString());
        assertTrue(typeCastMap.getExpression() instanceof IntegerLiteral);
        assertEquals("repository<Book>", typeCastRepository.getType().toString());
        assertTrue(typeCastRepository.getExpression() instanceof IntegerLiteral);
        assertEquals("void", typeCastVoid.getType().toString());
        assertTrue(typeCastVoid.getExpression() instanceof IntegerLiteral);
    }

    @Test
    public void should_build_binary_expressions() {
        var concat = build("22 ++ 33");
        assertTrue(concat instanceof Concatenation);

        // arithmetic
        var add = (Binary) build("2 + 1");
        var sub = (Binary) build("2 - 1");
        var product = (Binary) build("2 * 1");
        var div = (Binary) build("2 / 1");

        assertTrue(add instanceof Addition);
        assertTrue(add.getLeft() instanceof IntegerLiteral);
        assertTrue(add.getRight() instanceof IntegerLiteral);
        assertTrue(sub instanceof Subtraction);
        assertTrue(sub.getLeft() instanceof IntegerLiteral);
        assertTrue(sub.getRight() instanceof IntegerLiteral);
        assertTrue(product instanceof Product);
        assertTrue(product.getLeft() instanceof IntegerLiteral);
        assertTrue(product.getRight() instanceof IntegerLiteral);
        assertTrue(div instanceof Division);
        assertTrue(div.getLeft() instanceof IntegerLiteral);
        assertTrue(div.getRight() instanceof IntegerLiteral);

        // relational
        var gt = (Binary) build("2 > 1");
        var gte = (Binary) build("2 >= 1");
        var lt = (Binary) build("2 < 1");
        var lte = (Binary) build("2 <= 1");
        var e = (Binary) build("2 == 1");
        var ne = (Binary) build("2 != 1");
        var and = (Binary) build("2 && 1");
        var or = (Binary) build("2 || 1");

        assertTrue(gt instanceof GreaterThan);
        assertTrue(gt.getLeft() instanceof IntegerLiteral);
        assertTrue(gt.getRight() instanceof IntegerLiteral);
        assertTrue(gte instanceof GreaterThanOrEqual);
        assertTrue(gte.getLeft() instanceof IntegerLiteral);
        assertTrue(gte.getRight() instanceof IntegerLiteral);
        assertTrue(lt instanceof LowerThan);
        assertTrue(lt.getLeft() instanceof IntegerLiteral);
        assertTrue(lt.getRight() instanceof IntegerLiteral);
        assertTrue(lte instanceof LowerThanOrEqual);
        assertTrue(lte.getLeft() instanceof IntegerLiteral);
        assertTrue(lte.getRight() instanceof IntegerLiteral);
        assertTrue(e instanceof Equal);
        assertTrue(e.getLeft() instanceof IntegerLiteral);
        assertTrue(e.getRight() instanceof IntegerLiteral);
        assertTrue(ne instanceof NonEqual);
        assertTrue(ne.getLeft() instanceof IntegerLiteral);
        assertTrue(ne.getRight() instanceof IntegerLiteral);
        assertTrue(and instanceof Conjunction);
        assertTrue(and.getLeft() instanceof IntegerLiteral);
        assertTrue(and.getRight() instanceof IntegerLiteral);
        assertTrue(or instanceof Disjunction);
        assertTrue(or.getLeft() instanceof IntegerLiteral);
        assertTrue(or.getRight() instanceof IntegerLiteral);
    }

    @Test
    public void should_build_ternary()
    {
        var ternary = (Ternary) build("true ? true : false");
        var cond = ternary.getCondition();
        var then = ternary.getThen();
        var els = ternary.getElse();

        assertTrue(cond instanceof BooleanLiteral);
        assertTrue(then instanceof BooleanLiteral);
        assertTrue(els instanceof BooleanLiteral);
    }

    @Test
    public void should_build_expression_query()
    {
        var query = (ExpressionQuery) build("SELECT a[] FROM aa a");

        assertTrue(query.getQuery() instanceof QuerySelect);
    }

    private Expression build(String code) {
        return new Builder().buildExpression(new ByteArrayInputStream(code.getBytes()));
    }
}