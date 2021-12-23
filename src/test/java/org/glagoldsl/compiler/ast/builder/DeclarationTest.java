package org.glagoldsl.compiler.ast.builder;

import org.glagoldsl.compiler.ast.Builder;
import org.glagoldsl.compiler.ast.nodes.declaration.Entity;
import org.glagoldsl.compiler.ast.nodes.declaration.Repository;
import org.glagoldsl.compiler.ast.nodes.declaration.Service;
import org.glagoldsl.compiler.ast.nodes.declaration.Value;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.Controller;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.RestController;
import org.glagoldsl.compiler.ast.nodes.declaration.proxy.Proxy;
import org.glagoldsl.compiler.ast.nodes.expression.literal.StringLiteral;
import org.glagoldsl.compiler.ast.nodes.module.Module;
import org.junit.jupiter.api.Test;

import java.io.ByteArrayInputStream;

import static org.junit.jupiter.api.Assertions.*;

public class DeclarationTest {

    @Test
    public void should_build_namespace_node() {
        var module = build("namespace test::test;");

        assertEquals("test::test", module.getNamespace().toString());
    }

    @Test
    public void should_build_import_nodes() {
        var module = build("""
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
        var module = build("""
            namespace test;
            entity testEntity {}
            value testValue {}
            repository<testEntity> {}
            rest controller /path/:var {}
            service testService {}
            proxy \\Some\\PhpClass as value localValue {}
            proxy \\SomeOther\\PhpClass as service localService {}
        """);

        var declarations = module.getDeclarations();

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
        var module = build("""
            namespace test;
            @table
            @table()
            @table("table_name")
            entity testEntity {}
        """);

        var annotations = module.getDeclarations().get(0).getAnnotations();

        assertEquals("table", annotations.get(0).getName().toString());
        assertEquals("table", annotations.get(1).getName().toString());
        assertEquals("table_name", ((StringLiteral) annotations.get(2).getArguments().get(0).getExpression()).getValue());
    }

    @Test
    public void should_build_entity_with_members() {
        var module = build("""
            namespace test;
            entity testEntity {
                int a;
                int b () = 3;
                testEntity() {}
            }
        """);

        var entity = (Entity) module.getDeclarations().get(0);

        assertEquals(3, entity.getMembers().size());
    }

    @Test
    public void should_build_value_with_members() {
        var module = build("""
            namespace test;
            value testValue {
                int a;
                int b () = 3;
                constructor() {}
            }
        """);

        var value = (Value) module.getDeclarations().get(0);

        assertEquals(3, value.getMembers().size());
    }

    @Test
    public void should_build_repository_with_members() {
        var module = build("""
            namespace test;
            repository<Test> {
                int a;
                int b () = 3;
                constructor() {}
            }
        """);

        var repository = (Repository) module.getDeclarations().get(0);

        assertEquals(3, repository.getMembers().size());
    }

    @Test
    public void should_build_service_with_members() {
        var module = build("""
            namespace test;
            service Test {
                int a;
                int b () = 3;
                constructor() {}
            }
        """);

        var service = (Service) module.getDeclarations().get(0);

        assertEquals(3, service.getMembers().size());
    }

    @Test
    public void should_build_rest_controller_with_members() {
        var module = build("""
            namespace test;
            rest controller /test {
                int a;
                int b () = 3;
                constructor() {}
            }
        """);

        var controller = (RestController) module.getDeclarations().get(0);

        assertEquals(3, controller.getMembers().size());
    }

    @Test
    public void should_build_proxy_with_members() {
        var module = build("""
            namespace test;
            proxy \\Illuminate\\Http\\Request as
            service Request {
                int a;
                int b ();
                constructor();
            }
        """);

        var proxy = (Proxy) module.getDeclarations().get(0);
        var service = (Service) proxy.getDeclaration();

        assertEquals(3, service.getMembers().size());
    }

    private Module build(String code) {
        return new Builder().build(new ByteArrayInputStream(code.getBytes()));
    }
}