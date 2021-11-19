package org.glagoldsl.compiler.ast;

import org.glagoldsl.compiler.ast.declaration.*;
import org.glagoldsl.compiler.ast.namespace.Namespace;
import org.junit.Test;

import java.io.ByteArrayInputStream;
import java.util.List;

import static org.junit.Assert.assertEquals;

public class ASTBuilderTest {

    @Test
    public void should_build_namespace_node() {
        Namespace namespace = buildNamespace("namespace test;");

        assertEquals("test", namespace.getId().toString());
    }

    @Test
    public void should_build_declarations() {
        Namespace namespace = buildNamespace("""
            namespace test;
            entity testEntity {}
            value testValue {}
            repository<testEntity> {}
            rest controller /path/:var {}
            service testService {}
            proxy \\Some\\PhpClass as value localValue {}
            proxy \\SomeOther\\PhpClass as service localService {}
        """);

        List<Declaration> declarations = namespace.getDeclarations();

        assertEquals("testEntity", ((Entity) declarations.get(0)).getIdentifier().toString());
        assertEquals("testValue", ((Value) declarations.get(1)).getIdentifier().toString());
        assertEquals("testEntity", ((Repository) declarations.get(2)).getEntityIdentifier().toString());
        assertEquals("path", ((Controller) declarations.get(3)).getRoute().get(0).toString());
        assertEquals("var", ((Controller) declarations.get(3)).getRoute().get(1).toString());
        assertEquals("testService", ((Service) declarations.get(4)).getIdentifier().toString());
        assertEquals("\\Some\\PhpClass", ((Proxy) declarations.get(5)).getPhpLabel().toString());
        assertEquals("localValue", ((Proxy) declarations.get(5)).getDeclaration().getIdentifier().toString());
        assertEquals("\\SomeOther\\PhpClass", ((Proxy) declarations.get(6)).getPhpLabel().toString());
        assertEquals("localService", ((Proxy) declarations.get(6)).getDeclaration().getIdentifier().toString());
    }

    private Namespace buildNamespace(String code) {
        return new ASTBuilder().buildNamespace(new ByteArrayInputStream(code.getBytes()));
    }
}