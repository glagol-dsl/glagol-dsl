package org.glagoldsl.compiler.ast.nodes.declaration.controller.route;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class RouteElementLiteralTest {
    @Test
    void accept(@Mock DeclarationVisitor<Void, Void> visitor) {
        var node = new RouteElementLiteral("");
        node.accept(visitor, null);
        verify(visitor, times(1)).visitRouteElementLiteral(any(), any());
    }

    @Test
    void testToString() {
        var node = new RouteElementLiteral("test");
        assertEquals("test", node.toString());
    }

    @Test
    void testEquals() {
        var node1 = new RouteElementLiteral("test");
        var node2 = new RouteElementLiteral("test");
        assertEquals(node1, node2);
    }

    @Test
    void testHashCode() {
        var node1 = new RouteElementLiteral("test");
        var node2 = new RouteElementLiteral("test");
        assertEquals(node1.hashCode(), node2.hashCode());
    }
}
