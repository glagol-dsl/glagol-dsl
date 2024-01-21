package org.glagoldsl.compiler.ast.nodes.declaration.member;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.Body;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.Parameter;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.When;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.glagoldsl.compiler.ast.nodes.type.Type;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.ArrayList;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class MethodTest {
    @Test
    void accept(@Mock DeclarationVisitor<Void, Void> visitor) {
        var node = new Method(
                Accessor.PUBLIC, mock(Type.class), mock(Identifier.class), new ArrayList<>(), mock(When.class), mock(Body.class));
        node.accept(visitor, null);
        verify(visitor, times(1)).visitMethod(any(), any());
    }

    @Test
    void getParameters() {
        ArrayList<Parameter> parameters = new ArrayList<>();
        var node = new Method(
                Accessor.PUBLIC, mock(Type.class), mock(Identifier.class), parameters, mock(When.class), mock(Body.class));
        assertSame(parameters, node.getParameters());
    }

    @Test
    void getBody() {
        var body = mock(Body.class);
        var node = new Method(
                Accessor.PUBLIC, mock(Type.class), mock(Identifier.class), new ArrayList<>(), mock(When.class), body);
        assertSame(body, node.getBody());
    }

    @Test
    void getName() {
        var name = mock(Identifier.class);
        var node = new Method(
                Accessor.PUBLIC, mock(Type.class), name, new ArrayList<>(), mock(When.class), mock(Body.class));
        assertSame(name, node.getName());
    }

    @Test
    void getType() {
        var type = mock(Type.class);
        var node = new Method(
                Accessor.PUBLIC, type, mock(Identifier.class), new ArrayList<>(), mock(When.class), mock(Body.class));
        assertSame(type, node.getType());
    }

    @Test
    void getGuard() {
        var guard = mock(When.class);
        var node = new Method(
                Accessor.PUBLIC, mock(Type.class), mock(Identifier.class), new ArrayList<>(), guard, mock(Body.class));
        assertSame(guard, node.getGuard());
    }

    @Test
    void isMethod() {
        var node = new Method(
                Accessor.PUBLIC, mock(Type.class), mock(Identifier.class), new ArrayList<>(), mock(When.class), mock(Body.class));
        assertTrue(node.isMethod());
        assertFalse(node.isProperty());
        assertFalse(node.isConstructor());
    }

    @Test
    void signature() {
        var name = mock(Identifier.class);
        var type1 = mock(Type.class);
        var type2 = mock(Type.class);
        var parameter1 = mock(Parameter.class);
        when(parameter1.getType()).thenReturn(type1);
        var parameter2 = mock(Parameter.class);
        when(parameter2.getType()).thenReturn(type2);
        var parameters = new ArrayList<Parameter>() {{
            add(parameter1);
            add(parameter2);
        }};
        var method1 = new Method(
                Accessor.PUBLIC, mock(Type.class), name, parameters, mock(When.class), mock(Body.class));
        var method2 = new Method(
                Accessor.PRIVATE, mock(Type.class), name, parameters, mock(When.class), mock(Body.class));

        assertEquals(new Signature(name, type1, type2), method1.signature());
        assertEquals(new Signature(name, type1, type2), method2.signature());
        assertEquals(method1.signature(), method2.signature());
    }
}
