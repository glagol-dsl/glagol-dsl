package org.glagoldsl.compiler.ast.nodes.expression.literal;

import org.glagoldsl.compiler.ast.nodes.expression.ExpressionVisitor;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class DecimalLiteralTest {
    @Test
    void accept(@Mock ExpressionVisitor<Void, Void> visitor) {
        var node = new DecimalLiteral(mock(BigDecimal.class));
        node.accept(visitor, null);
        verify(visitor, times(1)).visitDecimalLiteral(any(), any());
    }
}