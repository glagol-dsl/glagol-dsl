package org.glagoldsl.compiler.ast.nodes.declaration.member.proxy;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.ArrayList;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ProxyConstructorTest {
    @Test
    void accept(@Mock DeclarationVisitor<Void, Void> visitor) {
        var node = new ProxyConstructor(new ArrayList<>());
        node.accept(visitor, null);
        verify(visitor, times(1)).visitProxyConstructor(any(), any());
    }
}