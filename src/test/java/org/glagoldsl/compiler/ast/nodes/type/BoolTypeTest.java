package org.glagoldsl.compiler.ast.nodes.type;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class BoolTypeTest {
    @Test
    void accept(@Mock TypeVisitor<Void, Void> visitor) {
        var node = new BoolType();
        node.accept(visitor, null);
        verify(visitor, times(1)).visitBoolType(any(), any());
    }
}