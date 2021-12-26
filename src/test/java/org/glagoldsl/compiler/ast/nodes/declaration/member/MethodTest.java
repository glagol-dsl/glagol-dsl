package org.glagoldsl.compiler.ast.nodes.declaration.member;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.Body;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.glagoldsl.compiler.ast.nodes.type.Type;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.ArrayList;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class MethodTest {
    @Test
    void accept(@Mock DeclarationVisitor<Void, Void> visitor) {
        var node = new Method(
                Accessor.PUBLIC, mock(Type.class), mock(Identifier.class), new ArrayList<>(), mock(Body.class));
        node.accept(visitor, null);
        verify(visitor, times(1)).visitMethod(any(), any());
    }
}