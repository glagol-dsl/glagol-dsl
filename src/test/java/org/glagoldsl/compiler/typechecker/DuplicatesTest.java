package org.glagoldsl.compiler.typechecker;

import org.glagoldsl.compiler.ast.nodes.declaration.*;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.RestController;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.route.Route;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.route.RouteElementLiteral;
import org.glagoldsl.compiler.ast.nodes.declaration.member.MemberCollection;
import org.glagoldsl.compiler.ast.nodes.declaration.proxy.PhpLabel;
import org.glagoldsl.compiler.ast.nodes.declaration.proxy.Proxy;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.glagoldsl.compiler.ast.nodes.module.*;
import org.glagoldsl.compiler.ast.nodes.module.Module;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;

import static org.junit.jupiter.api.Assertions.*;

class DuplicatesTest {
    @Test
    void it_does_not_yield_errors_when_no_duplicates() {
        var modules = new ModuleSet() {{
            add(new Module(
                    new Namespace(new Identifier("Test")),
                    new ImportCollection(),
                    new DeclarationCollection() {{
                        add(new Entity(new Identifier("User"), new MemberCollection()));
                    }}
            ));
            add(new Module(
                    new Namespace(new Identifier("Test2")),
                    new ImportCollection(),
                    new DeclarationCollection() {{
                        add(new Entity(new Identifier("User"), new MemberCollection()));
                    }}
            ));
        }};

        var environment = new Environment();

        modules.accept(new Duplicates(), environment);

        assertEquals(0, environment.getErrors().size());
    }

    @Test
    void it_yields_error_when_duplicate_entity_is_declared() {
        var modules = new ModuleSet() {{
            add(new Module(
                    new Namespace(new Identifier("Test")),
                    new ImportCollection(),
                    new DeclarationCollection() {{
                        add(new Entity(new Identifier("User"), new MemberCollection()));
                    }}
            ));
            add(new Module(
                    new Namespace(new Identifier("Test")),
                    new ImportCollection(),
                    new DeclarationCollection() {{
                        add(new Entity(new Identifier("User"), new MemberCollection()));
                    }}
            ));
        }};
        var environment = new Environment();

        modules.accept(new Duplicates(), environment);

        assertEquals(1, environment.getErrors().size());

        var error = environment.getErrors().get(0);

        assertEquals("Test::User is already defined", error.message());
    }

    @Test
    void it_yields_error_when_duplicate_value_object_is_declared() {
        var modules = new ModuleSet() {{
            add(new Module(
                    new Namespace(new Identifier("Test")),
                    new ImportCollection(),
                    new DeclarationCollection() {{
                        add(new Value(new Identifier("Money"), new MemberCollection()));
                    }}
            ));
            add(new Module(
                    new Namespace(new Identifier("Test")),
                    new ImportCollection(),
                    new DeclarationCollection() {{
                        add(new Value(new Identifier("Money"), new MemberCollection()));
                    }}
            ));
        }};
        var environment = new Environment();

        modules.accept(new Duplicates(), environment);

        assertEquals(1, environment.getErrors().size());

        var error = environment.getErrors().get(0);

        assertEquals("Test::Money is already defined", error.message());
    }

    @Test
    void it_yields_error_when_duplicate_service_is_declared() {
        var modules = new ModuleSet() {{
            add(new Module(
                    new Namespace(new Identifier("Test")),
                    new ImportCollection(),
                    new DeclarationCollection() {{
                        add(new Service(new Identifier("UserCreator"), new MemberCollection()));
                    }}
            ));
            add(new Module(
                    new Namespace(new Identifier("Test")),
                    new ImportCollection(),
                    new DeclarationCollection() {{
                        add(new Service(new Identifier("UserCreator"), new MemberCollection()));
                    }}
            ));
        }};
        var environment = new Environment();

        modules.accept(new Duplicates(), environment);

        assertEquals(1, environment.getErrors().size());

        var error = environment.getErrors().get(0);

        assertEquals("Test::UserCreator is already defined", error.message());
    }

    @Test
    void it_yields_error_when_duplicate_proxy_is_declared() {
        var modules = new ModuleSet() {{
            add(new Module(
                    new Namespace(new Identifier("Test")),
                    new ImportCollection(),
                    new DeclarationCollection() {{
                        add(new Proxy(new PhpLabel("User"), new Entity(new Identifier("User"), new MemberCollection())));
                    }}
            ));
            add(new Module(
                    new Namespace(new Identifier("Test")),
                    new ImportCollection(),
                    new DeclarationCollection() {{
                        add(new Proxy(new PhpLabel("User"), new Entity(new Identifier("User"), new MemberCollection())));
                    }}
            ));
        }};
        var environment = new Environment();

        modules.accept(new Duplicates(), environment);

        assertEquals(1, environment.getErrors().size());

        var error = environment.getErrors().get(0);

        assertEquals("Test::User is already defined", error.message());
    }

    @Test
    void it_yields_error_when_duplicate_rest_controller_is_declared() {
        var modules = new ModuleSet() {{
            add(new Module(
                    new Namespace(new Identifier("Test")),
                    new ImportCollection(),
                    new DeclarationCollection() {{
                        add(new RestController(new Route(new ArrayList<>() {{
                            add(new RouteElementLiteral("example"));
                        }}), new MemberCollection()));
                    }}
            ));
            add(new Module(
                    new Namespace(new Identifier("Test")),
                    new ImportCollection(),
                    new DeclarationCollection() {{
                        add(new RestController(new Route(new ArrayList<>() {{
                            add(new RouteElementLiteral("example"));
                        }}), new MemberCollection()));
                    }}
            ));
        }};
        var environment = new Environment();

        modules.accept(new Duplicates(), environment);

        assertEquals(1, environment.getErrors().size());

        var error = environment.getErrors().get(0);

        assertEquals("Test -> controller /example is already defined", error.message());
    }

    @Test
    void it_yields_error_when_duplicate_repository_is_declared() {
        var modules = new ModuleSet() {{
            add(new Module(
                    new Namespace(new Identifier("Test")),
                    new ImportCollection() {{
                        add(new Import(new Namespace(new Identifier("Test2")), new Identifier("User")));
                    }},
                    new DeclarationCollection() {{
                        add(new Repository(new Identifier("User"), new MemberCollection()));
                    }}
            ));
            add(new Module(
                    new Namespace(new Identifier("Test")),
                    new ImportCollection() {{
                        add(new Import(new Namespace(new Identifier("Test2")), new Identifier("User")));
                    }},
                    new DeclarationCollection() {{
                        add(new Repository(new Identifier("User"), new MemberCollection()));
                    }}
            ));
        }};
        var environment = new Environment();

        modules.accept(new Duplicates(), environment);

        assertEquals(1, environment.getErrors().size());

        var error = environment.getErrors().get(0);

        assertEquals("Test -> repository <Test2::User> is already defined", error.message());
    }
}
