package org.glagoldsl.compiler.ast.nodes.declaration.proxy;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.glagoldsl.compiler.ast.nodes.declaration.NamedDeclaration;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ProxyTest {
    @Test
    void accept(@Mock DeclarationVisitor<Void, Void> visitor) {
        var node = new Proxy(mock(PhpLabel.class), mock(NamedDeclaration.class));
        node.accept(visitor, null);
        verify(visitor, times(1)).visitProxy(any(), any());
    }

    @Test
    void getPhpLabel() {
        var phpLabel = mock(PhpLabel.class);
        var node = new Proxy(phpLabel, mock(NamedDeclaration.class));
        assertSame(phpLabel, node.getPhpLabel());
    }

    @Test
    void getDeclaration() {
        var declaration = mock(NamedDeclaration.class);
        var node = new Proxy(mock(PhpLabel.class), declaration);
        assertSame(declaration, node.getDeclaration());
    }

    @Test
    void testToString() {
        var node = new Proxy(mock(PhpLabel.class), mock(NamedDeclaration.class));
        assertEquals("proxy " + node.getIdentifier(), node.toString());
    }
}
