package org.glagoldsl.compiler.ast.nodes.type;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class GMapTypeTest {
    @Test
    void accept(@Mock TypeVisitor<Void, Void> visitor) {
        var node = new GMapType(mock(Type.class), mock(Type.class));
        node.accept(visitor, null);
        verify(visitor, times(1)).visitGMapType(any(), any());
    }
}