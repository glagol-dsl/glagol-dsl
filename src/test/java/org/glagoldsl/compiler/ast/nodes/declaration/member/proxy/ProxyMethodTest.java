package org.glagoldsl.compiler.ast.nodes.declaration.member.proxy;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.glagoldsl.compiler.ast.nodes.type.Type;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.ArrayList;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ProxyMethodTest {
    @Test
    void accept(@Mock DeclarationVisitor<Void, Void> visitor) {
        var node = new ProxyMethod(mock(Type.class), mock(Identifier.class), new ArrayList<>());
        node.accept(visitor, null);
        verify(visitor, times(1)).visitProxyMethod(any(), any());
    }
}