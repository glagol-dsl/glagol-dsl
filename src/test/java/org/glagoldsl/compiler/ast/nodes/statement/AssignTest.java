package org.glagoldsl.compiler.ast.nodes.statement;

import org.glagoldsl.compiler.ast.nodes.statement.assignable.Assignable;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AssignTest {
    @Test
    void accept(@Mock StatementVisitor<Void, Void> visitor) {
        var node = new Assign(mock(Assignable.class), AssignOperator.DEFAULT, mock(Statement.class));
        node.accept(visitor, null);
        verify(visitor, times(1)).visitAssign(any(), any());
    }
}