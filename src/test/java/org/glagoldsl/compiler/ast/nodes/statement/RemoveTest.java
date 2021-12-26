package org.glagoldsl.compiler.ast.nodes.statement;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class RemoveTest {
    @Test
    void accept(@Mock StatementVisitor<Void, Void> visitor) {
        var node = new Remove(any());
        node.accept(visitor, any());
        verify(visitor, times(1)).visitRemove(any(), any());
    }
}