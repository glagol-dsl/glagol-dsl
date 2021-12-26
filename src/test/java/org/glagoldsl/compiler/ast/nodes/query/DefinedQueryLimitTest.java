package org.glagoldsl.compiler.ast.nodes.query;

import org.glagoldsl.compiler.ast.nodes.query.expression.QueryExpression;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class DefinedQueryLimitTest {
    @Test
    void accept(@Mock QueryVisitor<Void, Void> visitor) {
        var node = new DefinedQueryLimit(mock(QueryExpression.class), mock(QueryExpression.class));
        node.accept(visitor, null);
        verify(visitor, times(1)).visitDefinedQueryLimit(any(), any());
    }
}