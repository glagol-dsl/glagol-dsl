package org.glagoldsl.compiler.ast.nodes.expression;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.HashMap;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class GMapTest {
    @Test
    void accept(@Mock ExpressionVisitor<Void, Void> visitor) {
        var node = new GMap(new HashMap<>());
        node.accept(visitor, null);
        verify(visitor, times(1)).visitGMap(any(), any());
    }
}