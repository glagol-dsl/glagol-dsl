package org.glagoldsl.compiler.ast.nodes.statement.assignable;

import org.glagoldsl.compiler.ast.nodes.expression.Expression;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class PropertyAssignTest {
    @Test
    void accept(@Mock AssignableVisitor<Void, Void> visitor) {
        var node = new PropertyAssign(mock(Expression.class), mock(Identifier.class));
        node.accept(visitor, null);
        verify(visitor, times(1)).visitPropertyAssign(any(), any());
    }
}