package org.glagoldsl.compiler.ast.nodes.declaration;

import org.glagoldsl.compiler.ast.nodes.declaration.controller.Controller;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.route.Route;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.glagoldsl.compiler.ast.nodes.module.Import;
import org.glagoldsl.compiler.ast.nodes.module.ImportCollection;
import org.glagoldsl.compiler.ast.nodes.module.Module;
import org.glagoldsl.compiler.ast.nodes.module.Namespace;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(MockitoExtension.class)
class DeclarationPointerTest {
    @Test
    void it_creates_declaration_pointer_with_namespace_and_identifier() {
        var namespace = new Namespace(new Identifier("foo"), new Identifier("bar"));
        var identifier = new Identifier("baz");
        var declarationPointer = new DeclarationPointer(namespace, identifier);
        assertEquals("foo::bar::baz", declarationPointer.toString());
    }

    @Test
    void it_creates_declaration_pointer_with_module_and_named_declaration() {
        var identifier = new Identifier("baz");
        var namedDeclaration = mock(NamedDeclaration.class);
        when(namedDeclaration.getIdentifier()).thenReturn(identifier);

        var namespace = new Namespace(new Identifier("foo"), new Identifier("bar"));
        var module = new Module(namespace, new ImportCollection(), new DeclarationCollection() {{
            add(namedDeclaration);
        }});
        var declarationPointer = new DeclarationPointer(module, namedDeclaration);

        assertEquals("foo::bar::baz", declarationPointer.toString());
    }

    @Test
    void it_creates_declaration_pointer_with_module_and_controller() {
        var controller = mock(Controller.class);
        var route = mock(Route.class);
        when(controller.getRoute()).thenReturn(route);
        when(route.toString()).thenReturn("/baz");

        var namespace = new Namespace(new Identifier("foo"), new Identifier("bar"));
        var module = new Module(namespace, new ImportCollection(), new DeclarationCollection() {{
            add(controller);
        }});
        var declarationPointer = new DeclarationPointer(module, controller);

        assertEquals("foo::bar -> controller /baz", declarationPointer.toString());
    }

    @Test
    void it_creates_declaration_pointer_with_module_and_repository() {
        var repository = mock(Repository.class);
        var entityIdentifier = new Identifier("baz");
        when(repository.getEntityIdentifier()).thenReturn(entityIdentifier);

        var namespace = new Namespace(new Identifier("foo"), new Identifier("bar"));
        var imports = mock(ImportCollection.class);
        var anImport = mock(Import.class);
        when(anImport.getNamespace()).thenReturn(new Namespace(new Identifier("foo"), new Identifier("bar")));
        when(anImport.getDeclaration()).thenReturn(new Identifier("baz"));
        when(imports.lookupByAlias(entityIdentifier)).thenReturn(anImport);
        var module = new Module(namespace, imports, new DeclarationCollection() {{
            add(repository);
        }});
        var declarationPointer = new DeclarationPointer(module, repository);

        assertEquals("foo::bar -> repository <foo::bar::baz>", declarationPointer.toString());
    }

    @Test
    void it_creates_null_declaration_pointer() {
        var namespace = new Namespace(new Identifier("foo"), new Identifier("bar"));
        var module = new Module(namespace, new ImportCollection(), new DeclarationCollection());
        var declarationPointer = new DeclarationPointer(module);

        assertEquals("foo::bar -> null", declarationPointer.toString());
    }
}
