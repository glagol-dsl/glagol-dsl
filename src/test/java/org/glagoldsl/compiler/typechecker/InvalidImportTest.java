package org.glagoldsl.compiler.typechecker;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationCollection;
import org.glagoldsl.compiler.ast.nodes.declaration.Entity;
import org.glagoldsl.compiler.ast.nodes.declaration.member.MemberCollection;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.glagoldsl.compiler.ast.nodes.module.Import;
import org.glagoldsl.compiler.ast.nodes.module.Module;
import org.glagoldsl.compiler.ast.nodes.module.ModuleSet;
import org.glagoldsl.compiler.ast.nodes.module.Namespace;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.ArrayList;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertSame;

@ExtendWith(MockitoExtension.class)
class InvalidImportTest {
    @Test
    void it_yields_error_when_import_is_not_defined() {
        var anImport = new Import(new Namespace(new Identifier("Test")), new Identifier("Customer"));

        var modules = new ModuleSet() {{
            add(new Module(
                    new Namespace(new Identifier("Test")),
                    new ArrayList<>(),
                    new DeclarationCollection() {{
                        add(new Entity(new Identifier("User"), new MemberCollection()));
                    }}
            ));
            add(new Module(
                    new Namespace(new Identifier("Test2")),
                    new ArrayList<>() {{
                        add(anImport);
                    }},
                    new DeclarationCollection()
            ));
        }};
        var environment = new Environment();

        modules.accept(new InvalidImport(), environment);

        assertEquals(1, environment.getErrors().size());

        var error = environment.getErrors().get(0);

        assertSame(anImport, error.node());
        assertEquals("Invalid import Test::Customer - declaration not found", error.message());
    }

    @Test
    void it_yields_no_error_when_import_is_defined() {

        var modules = new ModuleSet() {{
            add(new Module(
                    new Namespace(new Identifier("Test")),
                    new ArrayList<>(),
                    new DeclarationCollection() {{
                        add(new Entity(new Identifier("User"), new MemberCollection()));
                    }}
            ));
            add(new Module(
                    new Namespace(new Identifier("Test2")),
                    new ArrayList<>() {{
                        add(new Import(new Namespace(new Identifier("Test")), new Identifier("User")));
                    }},
                    new DeclarationCollection()
            ));
        }};
        var environment = new Environment();

        modules.accept(new InvalidImport(), environment);

        assertEquals(0, environment.getErrors().size());
    }
}
