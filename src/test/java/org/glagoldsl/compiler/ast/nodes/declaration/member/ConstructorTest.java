package org.glagoldsl.compiler.ast.nodes.declaration.member;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.Body;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.Parameter;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.When;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.ArrayList;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ConstructorTest {
    @Test
    void accept(@Mock DeclarationVisitor<Void, Void> visitor) {
        var node = new Constructor(Accessor.PUBLIC, new ArrayList<>(), mock(When.class), mock(Body.class));
        node.accept(visitor, null);
        verify(visitor, times(1)).visitConstructor(any(), any());
    }

    @Test
    void getParameters() {
        ArrayList<Parameter> parameters = new ArrayList<>();
        var node = new Constructor(Accessor.PUBLIC, parameters, mock(When.class), mock(Body.class));
        assertSame(parameters, node.getParameters());
    }

    @Test
    void getBody() {
        var body = mock(Body.class);
        var node = new Constructor(Accessor.PUBLIC, new ArrayList<>(), mock(When.class), body);
        assertSame(body, node.getBody());
    }

    @Test
    void getGuard() {
        var guard = mock(When.class);
        var node = new Constructor(Accessor.PUBLIC, new ArrayList<>(), guard, mock(Body.class));
        assertSame(guard, node.getGuard());
    }

    @Test
    void isConstructor() {
        var node = new Constructor(Accessor.PUBLIC, new ArrayList<>(), mock(When.class), mock(Body.class));
        assertTrue(node.isConstructor());
    }
}
