package org.glagoldsl.compiler.ast.nodes.expression;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.ArrayList;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class GListTest {
    @Test
    void accept(@Mock ExpressionVisitor<Void, Void> visitor) {
        var node = new GList(new ArrayList<>());
        node.accept(visitor, null);
        verify(visitor, times(1)).visitGList(any(), any());
    }
}