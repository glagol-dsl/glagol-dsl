package org.glagoldsl.compiler.ast;

import org.glagoldsl.compiler.ast.annotation.Annotation;
import org.glagoldsl.compiler.ast.declaration.*;
import org.glagoldsl.compiler.ast.module.Module;
import org.glagoldsl.compiler.ast.module.Namespace;
import org.junit.Test;

import java.io.ByteArrayInputStream;
import java.util.List;

import static org.junit.Assert.assertEquals;

public class ASTBuilderTest {

    @Test
    public void should_build_namespace_node() {
        Module module = buildModule("namespace test::test;");

        assertEquals("test::test", module.getNamespace().toString());
    }

    @Test
    public void should_build_import_nodes() {
        Module module = buildModule("""
                namespace test::test;
                import test::package::class as class1;
                import test::package::class2;
        """);

        assertEquals("test::package", module.getImports().get(0).getNamespace().toString());
        assertEquals("class", module.getImports().get(0).getDeclaration().toString());
        assertEquals("class1", module.getImports().get(0).getAlias().toString());

        assertEquals("test::package", module.getImports().get(1).getNamespace().toString());
        assertEquals("class2", module.getImports().get(1).getDeclaration().toString());
        assertEquals("class2", module.getImports().get(1).getAlias().toString());
    }

    @Test
    public void should_build_declarations() {
        Module module = buildModule("""
            namespace test;
            entity testEntity {}
            value testValue {}
            repository<testEntity> {}
            rest controller /path/:var {}
            service testService {}
            proxy \\Some\\PhpClass as value localValue {}
            proxy \\SomeOther\\PhpClass as service localService {}
        """);

        List<Declaration> declarations = module.getDeclarations();

        assertEquals("testEntity", ((Entity) declarations.get(0)).getIdentifier().toString());
        assertEquals("testValue", ((Value) declarations.get(1)).getIdentifier().toString());
        assertEquals("testEntity", ((Repository) declarations.get(2)).getEntityIdentifier().toString());
        assertEquals("/path/:var", ((Controller) declarations.get(3)).getRoute().toString());
        assertEquals("testService", ((Service) declarations.get(4)).getIdentifier().toString());
        assertEquals("\\Some\\PhpClass", ((Proxy) declarations.get(5)).getPhpLabel().toString());
        assertEquals("localValue", ((Proxy) declarations.get(5)).getDeclaration().getIdentifier().toString());
        assertEquals("\\SomeOther\\PhpClass", ((Proxy) declarations.get(6)).getPhpLabel().toString());
        assertEquals("localService", ((Proxy) declarations.get(6)).getDeclaration().getIdentifier().toString());
    }

    @Test
    public void should_build_annotated_declaration() {
        Module module = buildModule("""
            namespace test;
            @table
            @table()
            entity testEntity {}
        """);

        List<Annotation> annotations = module.getDeclarations().get(0).getAnnotations();

        assertEquals("table", annotations.get(0).getName().toString());
        assertEquals("table", annotations.get(1).getName().toString());
    }

    private Module buildModule(String code) {
        return new ASTBuilder().build(new ByteArrayInputStream(code.getBytes()));
    }
}