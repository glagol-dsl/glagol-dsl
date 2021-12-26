package org.glagoldsl.compiler.ast.nodes.expression;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class EmptyExpressionTest {
    @Test
    void accept(@Mock ExpressionVisitor<Void, Void> visitor) {
        var node = new EmptyExpression();
        node.accept(visitor, null);
        verify(visitor, times(1)).visitEmptyExpression(any(), any());
    }
}