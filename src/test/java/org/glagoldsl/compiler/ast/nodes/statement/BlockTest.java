package org.glagoldsl.compiler.ast.nodes.statement;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class BlockTest {
    @Test
    void accept(@Mock StatementVisitor<Void, Void> visitor) {
        var node = new Block(any());
        node.accept(visitor, any());
        verify(visitor, times(1)).visitBlock(any(), any());
    }
}