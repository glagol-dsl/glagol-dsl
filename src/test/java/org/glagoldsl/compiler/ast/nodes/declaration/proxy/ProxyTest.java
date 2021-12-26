package org.glagoldsl.compiler.ast.nodes.declaration.proxy;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.glagoldsl.compiler.ast.nodes.declaration.NamedDeclaration;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ProxyTest {
    @Test
    void accept(@Mock DeclarationVisitor<Void, Void> visitor) {
        var node = new Proxy(mock(PhpLabel.class), mock(NamedDeclaration.class));
        node.accept(visitor, null);
        verify(visitor, times(1)).visitProxy(any(), any());
    }
}