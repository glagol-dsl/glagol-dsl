package org.glagoldsl.compiler.ast.nodes.statement.assignable;

import org.glagoldsl.compiler.ast.nodes.expression.Expression;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ListValueAssignTest {
    @Test
    void accept(@Mock AssignableVisitor<Void, Void> visitor) {
        var node = new ListValueAssign(mock(Assignable.class), mock(Expression.class));
        node.accept(visitor, null);
        verify(visitor, times(1)).visitListValueAssign(any(), any());
    }
}