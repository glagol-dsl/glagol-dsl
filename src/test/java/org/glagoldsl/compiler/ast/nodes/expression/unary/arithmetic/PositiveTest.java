package org.glagoldsl.compiler.ast.nodes.expression.unary.arithmetic;

import org.glagoldsl.compiler.ast.nodes.expression.Expression;
import org.glagoldsl.compiler.ast.nodes.expression.ExpressionVisitor;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class PositiveTest {
    @Test
    void accept(@Mock ExpressionVisitor<Void, Void> visitor) {
        var node = new Positive(mock(Expression.class));
        node.accept(visitor, null);
        verify(visitor, times(1)).visitPositive(any(), any());
    }
}