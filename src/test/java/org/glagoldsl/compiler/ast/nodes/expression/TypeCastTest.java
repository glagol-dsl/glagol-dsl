package org.glagoldsl.compiler.ast.nodes.expression;

import org.glagoldsl.compiler.ast.nodes.type.Type;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class TypeCastTest {
    @Test
    void accept(@Mock ExpressionVisitor<Void, Void> visitor) {
        var node = new TypeCast(mock(Type.class), mock(Expression.class));
        node.accept(visitor, null);
        verify(visitor, times(1)).visitTypeCast(any(), any());
    }
}