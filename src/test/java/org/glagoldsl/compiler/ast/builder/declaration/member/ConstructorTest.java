package org.glagoldsl.compiler.ast.builder.declaration.member;

import org.glagoldsl.compiler.ast.Builder;
import org.glagoldsl.compiler.ast.declaration.member.Accessor;
import org.glagoldsl.compiler.ast.declaration.member.Constructor;
import org.glagoldsl.compiler.ast.declaration.member.AccessibleMember;
import org.junit.Test;

import java.io.ByteArrayInputStream;

import static org.junit.Assert.assertEquals;

public class ConstructorTest {
    @Test
    public void should_build_constructor_without_annotations() {
        var constructor = (Constructor) build("""
            Constructor() {}
        """);

        assertEquals(Accessor.PUBLIC, constructor.getAccessor());
        assertEquals(0, constructor.getParameters().size());
        assertEquals(0, constructor.getBody().getStatements().size());
    }

    @Test
    public void should_build_constructor_with_annotations() {
        var constructor = (Constructor) build("""
            @test
            @test2
            Constructor() {}
        """);

        assertEquals(2, constructor.getAnnotations().size());
    }

    @Test
    public void should_build_constructor_with_accessor() {
        var constructor = (Constructor) build("""
            private Constructor() {}
        """);

        assertEquals(Accessor.PRIVATE, constructor.getAccessor());
    }

    @Test
    public void should_build_constructor_with_parameters() {
        var constructor = (Constructor) build("""
            private Constructor(int a, float b, bool c, string d) {}
        """);

        assertEquals(4, constructor.getParameters().size());
    }

    private AccessibleMember build(String code) {
        return new Builder().buildGenericMember(new ByteArrayInputStream(code.getBytes()));
    }
}