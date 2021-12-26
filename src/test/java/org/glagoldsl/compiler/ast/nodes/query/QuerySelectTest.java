package org.glagoldsl.compiler.ast.nodes.query;

import org.glagoldsl.compiler.ast.nodes.query.expression.QueryExpression;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class QuerySelectTest {
    @Test
    void accept(@Mock QueryVisitor<Void, Void> visitor) {
        var node = new QuerySelect(
                mock(QuerySpec.class), mock(QuerySource.class), mock(QueryExpression.class), mock(QueryOrderBy.class),
                mock(QueryLimit.class)
        );
        node.accept(visitor, null);
        verify(visitor, times(1)).visitQuerySelect(any(), any());
    }
}