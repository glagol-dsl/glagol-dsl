package org.glagoldsl.compiler.ast.nodes.type;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class GListTypeTest {
    @Test
    void accept(@Mock TypeVisitor<Void, Void> visitor) {
        var node = new GListType(any());
        node.accept(visitor, any());
        verify(visitor, times(1)).visitGListType(any(), any());
    }
}