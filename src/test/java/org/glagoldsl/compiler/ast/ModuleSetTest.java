package org.glagoldsl.compiler.ast;

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

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

@ExtendWith(MockitoExtension.class)
class ModuleSetTest {
    @Test
    void lookup_should_find_declaration() {
        var modules = new ModuleSet() {{
            add(new Module(
                    new Namespace(new ArrayList<>() {{
                        add(new Identifier("Test"));
                    }}),
                    new ArrayList<>(),
                    new DeclarationCollection() {{
                        add(new Entity(new Identifier("User"), new MemberCollection()));
                    }}
            ));
        }};
        var toImport = new Import(
                new Namespace(
                        new ArrayList<>() {{
                            add(new Identifier("Test"));
                        }}
                ),
                new Identifier("User"),
                new Identifier("UserAlias")
        );

        assertFalse(modules.lookupDeclaration(toImport).isNull());
    }

    @Test
    void lookup_should_not_find_declaration() {
        var modules = new ModuleSet() {{
            add(new Module(
                    new Namespace(new ArrayList<>() {{
                        add(new Identifier("Test"));
                    }}),
                    new ArrayList<>(),
                    new DeclarationCollection() {{
                        add(new Entity(new Identifier("User"), new MemberCollection()));
                    }}
            ));
        }};
        var toImport = new Import(
                new Namespace(
                        new ArrayList<>() {{
                            add(new Identifier("Test"));
                        }}
                ),
                new Identifier("Customer"),
                new Identifier("CustomerAlias")
        );

        assertTrue(modules.lookupDeclaration(toImport).isNull());
    }
}
