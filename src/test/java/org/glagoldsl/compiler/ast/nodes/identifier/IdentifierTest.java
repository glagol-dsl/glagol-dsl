package org.glagoldsl.compiler.ast.nodes.identifier;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class IdentifierTest {
    @Test
    void accept(@Mock IdentifierVisitor<Void, Void> visitor) {
        var node = new Identifier(anyString());
        node.accept(visitor, any());
        verify(visitor, times(1)).visitIdentifier(any(), any());
    }
}