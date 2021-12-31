package org.glagoldsl.compiler.ast.builder.declaration.member;

import org.glagoldsl.compiler.ast.Builder;
import org.glagoldsl.compiler.ast.nodes.declaration.member.Accessor;
import org.glagoldsl.compiler.ast.nodes.declaration.member.Member;
import org.glagoldsl.compiler.ast.nodes.declaration.member.proxy.ProxyConstructor;
import org.glagoldsl.compiler.ast.nodes.declaration.member.proxy.ProxyMethod;
import org.glagoldsl.compiler.ast.nodes.declaration.member.proxy.ProxyProperty;
import org.glagoldsl.compiler.ast.nodes.declaration.member.proxy.ProxyRequire;
import org.junit.jupiter.api.Test;

import java.io.ByteArrayInputStream;

import static org.junit.jupiter.api.Assertions.*;

public class ProxyMemberTest {
    @Test
    public void should_build_proxy_property_without_annotations() {
        var property = (ProxyProperty) build("int prop;");
        assertEquals("prop", property.getName().toString());
        assertFalse(property.hasDefaultValue());
        assertEquals(Accessor.PUBLIC, property.getAccessor());
    }

    @Test
    public void should_build_proxy_property_with_annotations() {
        var property = (ProxyProperty) build("@testing @testing2 int prop;");
        assertEquals(2, property.getAnnotations().size());
    }

    @Test
    public void should_build_proxy_property_with_public_accessor() {
        var property = (ProxyProperty) build("public int prop;");
        assertEquals(Accessor.PUBLIC, property.getAccessor());
    }

    @Test
    public void should_build_proxy_method_without_annotations() {
        var method = (ProxyMethod) build("int method();");
        assertEquals("method", method.getName().toString());
        assertTrue(method.getBody().isEmpty());
        assertTrue(method.getGuard().isEmpty());
        assertEquals(Accessor.PUBLIC, method.getAccessor());
        assertEquals("int", method.getType().toString());
    }

    @Test
    public void should_build_proxy_method_with_annotations() {
        var method = (ProxyMethod) build("@testing int method();");
        assertEquals(1, method.getAnnotations().size());
    }

    @Test
    public void should_build_proxy_method_with_public_accessor() {
        var method = (ProxyMethod) build("public int method();");
        assertEquals(Accessor.PUBLIC, method.getAccessor());
    }

    @Test
    public void should_build_proxy_method_with_parameters() {
        var method = (ProxyMethod) build("int method(int a, float b, bool c);");
        assertEquals(3, method.getParameters().size());
    }

    @Test
    public void should_build_proxy_constructor_without_annotations() {
        var constructor = (ProxyConstructor) build("method();");
        assertTrue(constructor.getBody().isEmpty());
        assertTrue(constructor.getGuard().isEmpty());
        assertEquals(Accessor.PUBLIC, constructor.getAccessor());
    }

    @Test
    public void should_build_proxy_constructor_with_annotations() {
        var constructor = (ProxyConstructor) build("@testing constructor();");
        assertEquals(1, constructor.getAnnotations().size());
        assertTrue(constructor.getGuard().isEmpty());
    }

    @Test
    public void should_build_proxy_constructor_with_public_accessor() {
        var constructor = (ProxyConstructor) build("public constructor();");
        assertEquals(Accessor.PUBLIC, constructor.getAccessor());
        assertTrue(constructor.getGuard().isEmpty());
    }

    @Test
    public void should_build_proxy_constructor_with_parameters() {
        var constructor = (ProxyConstructor) build("constructor(int a, float b, bool c);");
        assertEquals(3, constructor.getParameters().size());
        assertTrue(constructor.getGuard().isEmpty());
    }

    @Test
    public void should_build_proxy_require_without_annotations() {
        var require = (ProxyRequire) build("""
            require "my/composer-package" "^2.0";
        """);

        assertEquals("my/composer-package", require.getPackage());
        assertEquals("^2.0", require.getVersion());
    }

    private Member build(String code) {
        return new Builder().buildProxyMember(new ByteArrayInputStream(code.getBytes()));
    }
}
