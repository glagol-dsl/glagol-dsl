package org.glagoldsl.compiler.ast.nodes.expression.literal;

import org.glagoldsl.compiler.ast.nodes.expression.ExpressionVisitor;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class IntegerLiteralTest {
    @Test
    void accept(@Mock ExpressionVisitor<Void, Void> visitor) {
        var node = new IntegerLiteral(anyInt());
        node.accept(visitor, any());
        verify(visitor, times(1)).visitIntegerLiteral(any(), any());
    }
}