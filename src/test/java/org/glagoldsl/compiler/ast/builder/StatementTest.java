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
import org.glagoldsl.compiler.ast.identifier.Identifier;
import org.glagoldsl.compiler.ast.statement.*;
import org.glagoldsl.compiler.ast.statement.assignable.ListValueAssign;
import org.glagoldsl.compiler.ast.statement.assignable.PropertyAssign;
import org.glagoldsl.compiler.ast.statement.assignable.VariableAssign;
import org.glagoldsl.compiler.ast.type.GListType;
import org.glagoldsl.compiler.ast.type.Type;
import org.junit.Test;

import java.io.ByteArrayInputStream;

import static org.junit.Assert.*;

public class StatementTest {
    @Test
    public void should_build_block() {
        var block = build("{}");
        assertEquals(0, block.getStatements().size());
    }

    @Test
    public void should_build_expression_statement() {
        var block = build("""
            {
                1;
            }
        """);
        var expression = ((ExpressionStatement) block.getStatements().get(0)).getExpression();

        assertEquals(1, ((IntegerLiteral) expression).toLong());
    }

    @Test
    public void should_build_if_then() {
        var block = build("""
            {
                if (true) foo();
            }
        """);
        var ifThen = (If) block.getStatements().get(0);
        var cond = (BooleanLiteral) ifThen.getCondition();
        var then = (ExpressionStatement) ifThen.getThen();
        var thenExpr = (Invoke) then.getExpression();
        var elseStmt = ifThen.getElseStmt();

        assertTrue(cond.getValue());
        assertEquals("foo", thenExpr.getMethod().toString());
        assertTrue(elseStmt.isEmpty());
    }

    @Test
    public void should_build_if_then_else() {
        var block = build("""
            {
                if (true) foo(); else bar();
            }
        """);
        var ifThen = (If) block.getStatements().get(0);
        var elseStmt = (ExpressionStatement) ifThen.getElseStmt();
        var elseExpr = (Invoke) elseStmt.getExpression();

        assertEquals("bar", elseExpr.getMethod().toString());
    }

    @Test
    public void should_build_return() {
        var block = build("""
            {
                return;
                return 123;
            }
        """);

        var returnVoid = (Return) block.getStatements().get(0);
        var returnValue = (Return) block.getStatements().get(1);
        var returnInteger = (IntegerLiteral) returnValue.getExpression();

        assertTrue(returnVoid.getExpression().isEmpty());
        assertEquals(123, returnInteger.toLong());
    }

    @Test
    public void should_build_assign_default_operator() {
        var block = build("""
            {
                var = 123;
            }
        """);

        var assignVar = (Assign) block.getStatements().get(0);
        var assignable = (VariableAssign) assignVar.getAssignable();
        var assignValue = (ExpressionStatement) assignVar.getValue();
        var integerLiteral = (IntegerLiteral) assignValue.getExpression();

        assertEquals("var", assignable.getName().toString());
        assertEquals(123, integerLiteral.toLong());
    }

    @Test
    public void should_build_assign_other_operators() {
        var block = build("""
            {
                var += 123;
                var -= 123;
                var *= 123;
                var /= 123;
            }
        """);

        var assignAdd = (Assign) block.getStatements().get(0);
        var assignSub = (Assign) block.getStatements().get(1);
        var assignProd = (Assign) block.getStatements().get(2);
        var assignDiv = (Assign) block.getStatements().get(3);

        assertEquals(AssignOperator.ADDITION, assignAdd.getOperator());
        assertEquals(AssignOperator.SUBTRACTION, assignSub.getOperator());
        assertEquals(AssignOperator.PRODUCT, assignProd.getOperator());
        assertEquals(AssignOperator.DIVISION, assignDiv.getOperator());
    }

    @Test
    public void should_build_assign_property() {
        var block = build("""
            {
                this.var = 123;
            }
        """);

        var assignProp = (Assign) block.getStatements().get(0);
        var assignable = (PropertyAssign) assignProp.getAssignable();

        assertTrue(assignable.getPrev() instanceof This);
        assertEquals("var", assignable.getProperty().toString());
    }

    @Test
    public void should_build_assign_list_value() {
        var block = build("""
            {
                var[999] = 123;
            }
        """);

        var assignProp = (Assign) block.getStatements().get(0);
        var assignable = (ListValueAssign) assignProp.getAssignable();

        assertEquals("var", ((VariableAssign) assignable.getPrev()).getName().toString());
        assertEquals(999, ((IntegerLiteral) assignable.getKey()).toLong());
    }

    @Test
    public void should_build_for_each_without_key_and_without_conditions() {
        var block = build("""
            {
                for (list as var) true;
            }
        """);

        var forEach = (ForEach) block.getStatements().get(0);
        var array = (Variable) forEach.getArray();
        var var = (Identifier) forEach.getVariable();
        var body = (ExpressionStatement) forEach.getBody();
        var expr = (BooleanLiteral) body.getExpression();

        assertEquals("list", array.getIdentifier().toString());
        assertEquals("var", var.toString());
        assertTrue(expr.getValue());
    }

    @Test
    public void should_build_for_each_with_key_and_without_conditions() {
        var block = build("""
            {
                for (list as key:var) true;
            }
        """);

        var forEach = (ForEachWithKey) block.getStatements().get(0);
        var array = (Variable) forEach.getArray();
        var var = (Identifier) forEach.getVariable();
        var key = (Identifier) forEach.getKey();
        var body = (ExpressionStatement) forEach.getBody();
        var expr = (BooleanLiteral) body.getExpression();

        assertEquals("list", array.getIdentifier().toString());
        assertEquals("var", var.toString());
        assertEquals("key", key.toString());
        assertTrue(expr.getValue());
    }

    @Test
    public void should_build_for_each_with_conditions() {
        var block = build("""
            {
                for (list as var, true, true, false) true;
            }
        """);

        var forEach = (ForEach) block.getStatements().get(0);

        assertEquals(3, forEach.getConditions().size());
        assertTrue(((BooleanLiteral) forEach.getConditions().get(0)).getValue());
        assertTrue(((BooleanLiteral) forEach.getConditions().get(1)).getValue());
        assertFalse(((BooleanLiteral) forEach.getConditions().get(2)).getValue());
    }

    @Test
    public void should_build_flush() {
        var block = build("""
            {
                flush;
                flush e;
            }
        """);

        var flushAll = (Flush) block.getStatements().get(0);
        var flushOne = (Flush) block.getStatements().get(1);
        var flushOneExpr = (Variable) flushOne.getExpression();

        assertTrue(flushAll.getExpression().isEmpty());
        assertEquals("e", flushOneExpr.getIdentifier().toString());
    }

    @Test
    public void should_build_persist() {
        var block = build("""
            {
                persist e;
            }
        """);

        var persist = (Persist) block.getStatements().get(0);
        var persistExpr = (Variable) persist.getExpression();

        assertEquals("e", persistExpr.getIdentifier().toString());
    }

    @Test
    public void should_build_remove() {
        var block = build("""
            {
                remove e;
            }
        """);

        var remove = (Remove) block.getStatements().get(0);
        var removeExpr = (Variable) remove.getExpression();

        assertEquals("e", removeExpr.getIdentifier().toString());
    }

    @Test
    public void should_build_break() {
        var block = build("""
            {
                break;
                break 3;
            }
        """);

        var breakNoLevel = (Break) block.getStatements().get(0);
        var breakLevel = (Break) block.getStatements().get(1);

        assertEquals(1, breakNoLevel.getLevel().toLong());
        assertEquals(3, breakLevel.getLevel().toLong());
    }

    @Test
    public void should_build_continue() {
        var block = build("""
            {
                continue;
                continue 5;
            }
        """);

        var continueNoLevel = (Continue) block.getStatements().get(0);
        var continueLevel = (Continue) block.getStatements().get(1);

        assertEquals(1, continueNoLevel.getLevel().toLong());
        assertEquals(5, continueLevel.getLevel().toLong());
    }

    @Test
    public void should_build_declare() {
        var block = build("""
            {
                int[] i;
                int[] d = [22];
            }
        """);

        var declareWithoutValue = (Declare) block.getStatements().get(0);
        var declareWithoutValueType = (GListType) declareWithoutValue.getType();
        var declareWithValue = (Declare) block.getStatements().get(1);
        var declareWithValueValue = (GList) ((ExpressionStatement) declareWithValue.getValue()).getExpression();
        var declareWithValueValueItem = (IntegerLiteral) declareWithValueValue.getExpressions().get(0);

        assertEquals("int", declareWithoutValueType.getType().toString());
        assertEquals("i", declareWithoutValue.getVariable().toString());
        assertFalse(declareWithValue.getValue().isEmpty());

        assertEquals(1, declareWithValueValue.getExpressions().size());
        assertEquals(22, declareWithValueValueItem.toLong());
    }

    private Block build(String code) {
        return (Block) new Builder().buildStatement(new ByteArrayInputStream(code.getBytes()));
    }
}