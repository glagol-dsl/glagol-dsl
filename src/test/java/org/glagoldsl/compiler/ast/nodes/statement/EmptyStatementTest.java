package org.glagoldsl.compiler.ast.nodes.statement;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class EmptyStatementTest {
    @Test
    void accept(@Mock StatementVisitor<Void, Void> visitor) {
        var node = new EmptyStatement();
        node.accept(visitor, null);
        verify(visitor, times(1)).visitEmptyStatement(any(), any());
    }
}