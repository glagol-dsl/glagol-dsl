package org.glagoldsl.compiler.ast.builder;

import org.glagoldsl.compiler.ast.Builder;
import org.glagoldsl.compiler.ast.expression.*;
import org.glagoldsl.compiler.ast.expression.binary.Concatenation;
import org.glagoldsl.compiler.ast.expression.binary.arithmetic.Addition;
import org.glagoldsl.compiler.ast.expression.binary.arithmetic.Division;
import org.glagoldsl.compiler.ast.expression.binary.arithmetic.Product;
import org.glagoldsl.compiler.ast.expression.binary.arithmetic.Subtraction;
import org.glagoldsl.compiler.ast.expression.binary.relational.*;
import org.glagoldsl.compiler.ast.expression.literal.BooleanLiteral;
import org.glagoldsl.compiler.ast.expression.literal.DecimalLiteral;
import org.glagoldsl.compiler.ast.expression.literal.IntegerLiteral;
import org.glagoldsl.compiler.ast.expression.literal.StringLiteral;
import org.glagoldsl.compiler.ast.expression.unary.Bracket;
import org.glagoldsl.compiler.ast.expression.unary.arithmetic.Negative;
import org.glagoldsl.compiler.ast.expression.unary.arithmetic.Positive;
import org.glagoldsl.compiler.ast.expression.unary.relational.Negation;
import org.glagoldsl.compiler.ast.query.DefinedQueryLimit;
import org.glagoldsl.compiler.ast.query.QuerySelect;
import org.glagoldsl.compiler.ast.query.expression.QueryField;
import org.glagoldsl.compiler.ast.query.expression.QueryInterpolation;
import org.glagoldsl.compiler.ast.query.expression.binary.relational.QueryEqual;
import org.glagoldsl.compiler.ast.type.IntegerType;
import org.junit.Test;

import java.io.ByteArrayInputStream;

import static org.junit.Assert.*;

public class ExpressionTest {

    @Test
    public void should_build_brackets() {
        Expression singleBrackets = build("(123)");

        assertEquals(123, (long) ((IntegerLiteral) ((Bracket) singleBrackets).getExpression()).getValue());

        Expression nestedBrackets = build("((123))");

        assertEquals(123, (long) ((IntegerLiteral) ((Bracket) ((Bracket) nestedBrackets).getExpression()).getExpression()).getValue());
    }

    @Test
    public void should_build_literals() {
        StringLiteral simpleString = (StringLiteral) build("\"test\"");
        StringLiteral escapedString = (StringLiteral) build("\"\\\"test\"");

        assertEquals("test", simpleString.getValue());
        assertEquals("\"test", escapedString.getValue());

        BooleanLiteral booleanTrue = (BooleanLiteral) build("true");
        BooleanLiteral booleanFalse = (BooleanLiteral) build("false");

        assertTrue(booleanTrue.getValue());
        assertFalse(booleanFalse.getValue());

        IntegerLiteral integer = (IntegerLiteral) build("23");

        assertEquals(23, integer.toLong());

        DecimalLiteral decimal = (DecimalLiteral) build("2.2222222222333333");

        assertEquals("2.2222222222333333", decimal.getValue().toString());
    }

    @Test
    public void should_build_list() {
        GList list = (GList) build("""
            [1, 2, 3, 4]
        """);

        assertEquals(1, ((IntegerLiteral) list.getExpressions().get(0)).toLong());
        assertEquals(2, ((IntegerLiteral) list.getExpressions().get(1)).toLong());
        assertEquals(3, ((IntegerLiteral) list.getExpressions().get(2)).toLong());
        assertEquals(4, ((IntegerLiteral) list.getExpressions().get(3)).toLong());
    }

    @Test
    public void should_build_map() {
        GMap map = (GMap) build("""
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
        Variable var = (Variable) build("""
            variable
        """);

        assertEquals("variable", var.getIdentifier().toString());
    }

    @Test
    public void should_build_new_instance() {
        New newInstance = (New) build("""
            new Instance()
        """);

        assertEquals("Instance", newInstance.getTarget().toString());
    }

    @Test
    public void should_build_invocation() {
        Invoke invoke = (Invoke) build("""
            method(1)
        """);

        assertEquals("method", invoke.getMethod().toString());
        assertTrue(invoke.getPrev() instanceof This);
        assertEquals(1, ((IntegerLiteral) invoke.getArguments().get(0)).toLong());

        Invoke invokeWithNesting = (Invoke) build("""
            this.method(1).that().method2()
        """);

        assertEquals("method2", invokeWithNesting.getMethod().toString());
        assertTrue(invokeWithNesting.getPrev() instanceof Invoke);
    }

    @Test
    public void should_build_property_access() {
        PropertyAccess propertyAccess = (PropertyAccess) build("""
            that.that.that_final
        """);

        assertEquals("that_final", propertyAccess.getProperty().toString());
        assertTrue(propertyAccess.getPrev() instanceof PropertyAccess);
    }

    @Test
    public void should_build_unary_expressions() {
        Negative negative = (Negative) build("-33");
        Positive positive = (Positive) build("+33");
        Negation negate = (Negation) build("!true");

        assertEquals(33, ((IntegerLiteral) negative.getExpression()).toLong());
        assertEquals(33, ((IntegerLiteral) positive.getExpression()).toLong());
        assertEquals(true, ((BooleanLiteral) negate.getExpression()).getValue());
    }

    @Test
    public void should_build_type_cast() {
        TypeCast typeCastInt = (TypeCast) build("(int) \"10\"");
        TypeCast typeCastBool = (TypeCast) build("(bool) 0");
        TypeCast typeCastFloat = (TypeCast) build("(float) 0");
        TypeCast typeCastString = (TypeCast) build("(string) 0");
        TypeCast typeCastClass = (TypeCast) build("(MyClass) 0");
        TypeCast typeCastList = (TypeCast) build("(int[]) 0");
        TypeCast typeCastMap = (TypeCast) build("({int,string}) 0");
        TypeCast typeCastRepository = (TypeCast) build("(repository<Book>) 0");
        TypeCast typeCastVoid = (TypeCast) build("(void) 0");

        assertEquals("int", typeCastInt.getType().toString());
        assertEquals("bool", typeCastBool.getType().toString());
        assertEquals("float", typeCastFloat.getType().toString());
        assertEquals("string", typeCastString.getType().toString());
        assertEquals("MyClass", typeCastClass.getType().toString());
        assertEquals("int[]", typeCastList.getType().toString());
        assertEquals("{int,string}", typeCastMap.getType().toString());
        assertEquals("repository<Book>", typeCastRepository.getType().toString());
        assertEquals("void", typeCastVoid.getType().toString());
    }

    @Test
    public void should_build_binary_expressions() {
        Expression concat = build("22 ++ 33");
        assertTrue(concat instanceof Concatenation);

        // arithmetic
        Expression add = build("2 + 1");
        Expression sub = build("2 - 1");
        Expression product = build("2 * 1");
        Expression div = build("2 / 1");

        assertTrue(add instanceof Addition);
        assertTrue(sub instanceof Subtraction);
        assertTrue(product instanceof Product);
        assertTrue(div instanceof Division);

        //relational
        Expression gt = build("2 > 1");
        Expression gte = build("2 >= 1");
        Expression lt = build("2 < 1");
        Expression lte = build("2 <= 1");
        Expression e = build("2 == 1");
        Expression ne = build("2 != 1");
        Expression and = build("2 && 1");
        Expression or = build("2 || 1");

        assertTrue(gt instanceof GreaterThan);
        assertTrue(gte instanceof GreaterThanOrEqual);
        assertTrue(lt instanceof LowerThan);
        assertTrue(lte instanceof LowerThanOrEqual);
        assertTrue(e instanceof Equal);
        assertTrue(ne instanceof NonEqual);
        assertTrue(and instanceof Conjunction);
        assertTrue(or instanceof Disjunction);
    }

    @Test
    public void should_build_ternary()
    {
        Expression ternary = build("true ? true : false");

        assertTrue(ternary instanceof Ternary);
    }

    private Expression build(String code) {
        return new Builder().buildExpression(new ByteArrayInputStream(code.getBytes()));
    }
}