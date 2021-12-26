package org.glagoldsl.compiler.ast.nodes.query;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class UndefinedQueryLimitTest {
    @Test
    void accept(@Mock QueryVisitor<Void, Void> visitor) {
        var node = new UndefinedQueryLimit();
        node.accept(visitor, null);
        verify(visitor, times(1)).visitUndefinedQueryLimit(any(), any());
    }
}