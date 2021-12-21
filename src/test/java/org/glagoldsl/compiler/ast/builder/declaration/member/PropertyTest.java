package org.glagoldsl.compiler.ast.builder.declaration.member;

import org.glagoldsl.compiler.ast.Builder;
import org.glagoldsl.compiler.ast.declaration.member.Accessor;
import org.glagoldsl.compiler.ast.declaration.member.AccessibleMember;
import org.glagoldsl.compiler.ast.declaration.member.Property;
import org.glagoldsl.compiler.ast.expression.literal.IntegerLiteral;
import org.junit.Test;

import java.io.ByteArrayInputStream;

import static org.junit.Assert.*;

public class PropertyTest {
    @Test
    public void should_build_property_without_annotations() {
        var property = (Property) build("int prop;");
        assertEquals("prop", property.getName().toString());
        assertEquals("int", property.getType().toString());
        assertFalse(property.hasDefaultValue());
    }

    @Test
    public void should_build_property_with_annotations() {
        var property = (Property) build("@test @test2 int prop;");
        assertEquals(2, property.getAnnotations().size());
    }

    @Test
    public void should_build_property_with_accessor() {
        var privateProperty = (Property) build("private int prop;");
        var publicProperty = (Property) build("public int prop;");
        var propertyWithDefaultAccessor = (Property) build("int prop;");

        assertEquals(Accessor.PRIVATE, privateProperty.getAccessor());
        assertEquals(Accessor.PUBLIC, publicProperty.getAccessor());
        assertEquals(Accessor.PRIVATE, propertyWithDefaultAccessor.getAccessor());
    }

    @Test
    public void should_build_property_with_default_value() {
        var property = (Property) build("int prop = 5;");
        assertTrue(property.hasDefaultValue());
        assertEquals(5, ((IntegerLiteral) property.getDefaultValue()).toLong());
    }

    private AccessibleMember build(String code) {
        return new Builder().buildGenericMember(new ByteArrayInputStream(code.getBytes()));
    }
}