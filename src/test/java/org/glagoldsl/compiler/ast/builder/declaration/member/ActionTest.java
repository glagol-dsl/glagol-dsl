package org.glagoldsl.compiler.ast.builder.declaration.member;

import org.glagoldsl.compiler.ast.Builder;
import org.glagoldsl.compiler.ast.nodes.declaration.member.Action;
import org.glagoldsl.compiler.ast.nodes.declaration.member.Member;
import org.glagoldsl.compiler.ast.nodes.expression.literal.StringLiteral;
import org.glagoldsl.compiler.ast.nodes.statement.Return;
import org.junit.jupiter.api.Test;

import java.io.ByteArrayInputStream;

import static org.junit.jupiter.api.Assertions.*;

public class ActionTest {
    @Test
    public void should_build_action_without_annotations() {
        var action = (Action) build("""
            index = "hello world";
        """);
        var body = (Return) action.getBody().getStatements().get(0);
        var expression = (StringLiteral) body.getExpression();

        assertEquals("index", action.getName().toString());
        assertEquals("index", action.getName().toString());
        assertEquals("hello world", expression.getValue());
    }

    @Test
    public void should_build_action_with_annotations() {
        var action = (Action) build("""
            @testing
            @testing123
            index = "hello world";
        """);

        assertEquals(2, action.getAnnotations().size());
    }

    @Test
    public void should_build_action_with_parameters() {
        var action = (Action) build("""
            index (string a, string b, string c) = "hello world";
        """);

        assertEquals(3, action.getParameters().size());
    }

    @Test
    public void should_build_action_with_full_body_syntax() {
        var action = (Action) build("""
            index {
                return "hello world";
            }
        """);

        var body = (Return) action.getBody().getStatements().get(0);
        var expression = (StringLiteral) body.getExpression();

        assertEquals("index", action.getName().toString());
        assertEquals("index", action.getName().toString());
        assertEquals("hello world", expression.getValue());
    }

    private Member build(String code) {
        return new Builder().buildControllerMember(new ByteArrayInputStream(code.getBytes()));
    }
}