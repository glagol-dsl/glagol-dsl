package org.glagoldsl.compiler.ast.nodes.query;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.ArrayList;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class QueryOrderByTest {
    @Test
    void accept(@Mock QueryVisitor<Void, Void> visitor) {
        var node = new QueryOrderBy(new ArrayList<>());
        node.accept(visitor, null);
        verify(visitor, times(1)).visitQueryOrderBy(any(), any());
    }
}