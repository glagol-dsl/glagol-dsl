package org.glagoldsl.compiler.typechecker;

import org.glagoldsl.compiler.ast.nodes.declaration.*;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.RestController;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.route.Route;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.route.RouteElementLiteral;
import org.glagoldsl.compiler.ast.nodes.declaration.member.*;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.Body;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.Parameter;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.When;
import org.glagoldsl.compiler.ast.nodes.declaration.member.proxy.ProxyMethod;
import org.glagoldsl.compiler.ast.nodes.declaration.proxy.PhpLabel;
import org.glagoldsl.compiler.ast.nodes.declaration.proxy.Proxy;
import org.glagoldsl.compiler.ast.nodes.expression.Expression;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.glagoldsl.compiler.ast.nodes.module.Module;
import org.glagoldsl.compiler.ast.nodes.module.*;
import org.glagoldsl.compiler.ast.nodes.type.Type;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;
import org.mockito.Mockito;

import java.util.ArrayList;
import java.util.stream.Stream;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

class RedefinitionTest {
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

        modules.accept(new Redefinition(), environment);

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

        modules.accept(new Redefinition(), environment);

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

        modules.accept(new Redefinition(), environment);

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

        modules.accept(new Redefinition(), environment);

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

        modules.accept(new Redefinition(), environment);

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

        modules.accept(new Redefinition(), environment);

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

        modules.accept(new Redefinition(), environment);

        assertEquals(1, environment.getErrors().size());

        var error = environment.getErrors().get(0);

        assertEquals("Test -> repository <Test2::User> is already defined", error.message());
    }

    @ParameterizedTest
    @MethodSource("declarationsWithPropertyRedefinitions")
    void it_yields_error_when_duplicated_property_is_declared_in_entity(Declaration declaration, String expectedError) {
        var modules = new ModuleSet() {{
            add(new Module(
                    new Namespace(new Identifier("Test")),
                    new ImportCollection(),
                    new DeclarationCollection() {{
                        add(declaration);
                    }}
            ));
        }};
        var environment = new Environment();

        modules.accept(new Redefinition(), environment);

        assertEquals(1, environment.getErrors().size());

        var error = environment.getErrors().get(0);

        assertEquals(expectedError, error.message());
    }

    public static Stream<Arguments> declarationsWithPropertyRedefinitions() {
        var property1 = new Property(Accessor.PRIVATE,
                mock(Type.class),
                new Identifier("name"),
                mock(Expression.class));
        var property2 = new Property(Accessor.PUBLIC,
                mock(Type.class),
                new Identifier("name"),
                mock(Expression.class));

        var entity = new Entity(new Identifier("User"), new MemberCollection() {{
            add(property1);
            add(property2);
        }});

        var value = new Value(new Identifier("Money"), new MemberCollection() {{
            add(property1);
            add(property2);
        }});

        var repository = new Repository(new Identifier("User"), new MemberCollection() {{
            add(property1);
            add(property2);
        }});

        var service = new Service(new Identifier("UserCreator"), new MemberCollection() {{
            add(property1);
            add(property2);
        }});

        return Stream.of(
                Arguments.of(entity, "Test::User -> 'name' property is already defined"),
                Arguments.of(value, "Test::Money -> 'name' property is already defined"),
                Arguments.of(repository, "Test -> repository <::> -> 'name' property is already defined"),
                Arguments.of(service, "Test::UserCreator -> 'name' property is already defined")
        );
    }

    @ParameterizedTest
    @MethodSource("declarationsWithMethodRedefinitions")
    void it_yields_error_when_duplicated_method_is_declared_in_entity(Declaration declaration, String expectedError) {
        var modules = new ModuleSet() {{
            add(new Module(
                    new Namespace(new Identifier("Test")),
                    new ImportCollection(),
                    new DeclarationCollection() {{
                        add(declaration);
                    }}
            ));
        }};
        var environment = new Environment();

        modules.accept(new Redefinition(), environment);

        assertEquals(1, environment.getErrors().size());

        var error = environment.getErrors().get(0);

        assertEquals(expectedError, error.message());
    }

    public static Stream<Arguments> declarationsWithMethodRedefinitions() {
        var type1 = mock(Type.class);
        when(type1.toString()).thenReturn("Type1");
        var method1 = new Method(Accessor.PRIVATE,
                mock(Type.class),
                new Identifier("name"),
                new ArrayList<>() {{
                    add(new Parameter(type1, new Identifier("name")));
                }},
                mock(When.class),
                mock(Body.class)
        );
        var method2 = new ProxyMethod(mock(Type.class),
                new Identifier("name"),
                new ArrayList<>() {{
                    add(new Parameter(type1, new Identifier("name")));
                }}
        );

        var entity = new Entity(new Identifier("User"), new MemberCollection() {{
            add(method1);
            add(method2);
        }});

        var value = new Value(new Identifier("Money"), new MemberCollection() {{
            add(method1);
            add(method2);
        }});

        var repository = new Repository(new Identifier("User"), new MemberCollection() {{
            add(method1);
            add(method2);
        }});

        var service = new Service(new Identifier("UserCreator"), new MemberCollection() {{
            add(method1);
            add(method2);
        }});

        return Stream.of(
                Arguments.of(entity, "Test::User -> name(Type1) method is already defined"),
                Arguments.of(value, "Test::Money -> name(Type1) method is already defined"),
                Arguments.of(repository, "Test -> repository <::> -> name(Type1) method is already defined"),
                Arguments.of(service, "Test::UserCreator -> name(Type1) method is already defined")
        );
    }
}
