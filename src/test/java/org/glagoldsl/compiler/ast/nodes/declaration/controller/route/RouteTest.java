package org.glagoldsl.compiler.ast.nodes.declaration.controller.route;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.ArrayList;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class RouteTest {
    @Test
    void accept(@Mock DeclarationVisitor<Void, Void> visitor) {
        var node = new Route(new ArrayList<>());
        node.accept(visitor, null);
        verify(visitor, times(1)).visitRoute(any(), any());
    }

    @Test
    void equals() {
        var node = new Route(new ArrayList<>());
        var node2 = new Route(new ArrayList<>());
        assertEquals(node, node2);
    }
    @Test
    void hash_code() {
        var node = new Route(new ArrayList<>());
        var node2 = new Route(new ArrayList<>());
        assertEquals(node.hashCode(), node2.hashCode());
    }
}
