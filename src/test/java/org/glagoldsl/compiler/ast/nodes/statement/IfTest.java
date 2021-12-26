package org.glagoldsl.compiler.ast.nodes.statement;

import org.glagoldsl.compiler.ast.nodes.expression.Expression;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class IfTest {
    @Test
    void accept(@Mock StatementVisitor<Void, Void> visitor) {
        var node = new If(mock(Expression.class), mock(Statement.class), mock(Statement.class));
        node.accept(visitor, null);
        verify(visitor, times(1)).visitIf(any(), any());
    }
}