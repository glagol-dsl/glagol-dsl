package org.glagoldsl.compiler.ast.builder.declaration.member;

import org.glagoldsl.compiler.ast.Builder;
import org.glagoldsl.compiler.ast.nodes.declaration.member.Accessor;
import org.glagoldsl.compiler.ast.nodes.declaration.member.AccessibleMember;
import org.glagoldsl.compiler.ast.nodes.declaration.member.Method;
import org.glagoldsl.compiler.ast.nodes.expression.literal.IntegerLiteral;
import org.glagoldsl.compiler.ast.nodes.statement.Return;
import org.junit.jupiter.api.Test;

import java.io.ByteArrayInputStream;

import static org.junit.jupiter.api.Assertions.*;

public class MethodTest {
    @Test
    public void should_build_method_without_annotations() {
        var method = (Method) build("int method() = 1;");
        assertEquals("method", method.getName().toString());
    }

    @Test
    public void should_build_method_with_annotations() {
        var method = (Method) build("@test @test2 int method() = 1;");
        assertEquals(2, method.getAnnotations().size());
    }

    @Test
    public void should_build_method_with_accessors() {
        var privateMethod = (Method) build("private int method() = 1;");
        var publicMethod = (Method) build("public int method() = 2;");
        var methodWithDefaultAccessor = (Method) build("int method() = 1;");

        assertEquals(Accessor.PRIVATE, privateMethod.getAccessor());
        assertEquals(Accessor.PUBLIC, publicMethod.getAccessor());
        assertEquals(Accessor.PRIVATE, methodWithDefaultAccessor.getAccessor());
    }

    @Test
    public void should_build_method_with_parameters() {
        var method = (Method) build("int method(bool a, string b) = 1;");
        var parameters = method.getParameters();
        var parameterA = parameters.get(0);
        var parameterB = parameters.get(1);

        assertEquals("bool", parameterA.getType().toString());
        assertEquals("string", parameterB.getType().toString());

        assertEquals("a", parameterA.getName().toString());
        assertEquals("b", parameterB.getName().toString());
    }

    @Test
    public void should_build_method_with_annotated_parameters() {
        var method = (Method) build("int method(@abc bool a, string b) = 1;");
        var parameters = method.getParameters();
        var parameterA = parameters.get(0);

        assertEquals("abc", parameterA.getAnnotations().get(0).getName().toString());
    }

    @Test
    public void should_build_method_with_expression_body() {
        var method = (Method) build("int method() = 1;");
        var returnStmt = (Return) method.getBody().getStatements().get(0);
        var expression = (IntegerLiteral) returnStmt.getExpression();

        assertEquals(1, expression.toLong());
    }

    @Test
    public void should_build_method_with_statement_body() {
        var method = (Method) build("""
            int method() {
            }
        """);
        assertEquals(0, method.getBody().getStatements().size());
    }

    private AccessibleMember build(String code) {
        return new Builder().buildGenericMember(new ByteArrayInputStream(code.getBytes()));
    }
}