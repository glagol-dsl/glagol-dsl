package org.glagoldsl.compiler.ast.nodes.declaration.controller.route;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class RouteElementPlaceholderTest {
    @Test
    void accept(@Mock DeclarationVisitor<Void, Void> visitor) {
        var node = new RouteElementPlaceholder("");
        node.accept(visitor, null);
        verify(visitor, times(1)).visitRouteElementPlaceholder(any(), any());
    }

    @Test
    void testToString() {
        var node = new RouteElementPlaceholder("placeholder");
        assertEquals(":placeholder", node.toString());
    }

    @Test
    void testEquals() {
        var node1 = new RouteElementPlaceholder("placeholder");
        var node2 = new RouteElementPlaceholder("placeholder");
        assertEquals(node1, node2);
    }

    @Test
    void testHashCode() {
        var node1 = new RouteElementPlaceholder("placeholder");
        var node2 = new RouteElementPlaceholder("placeholder");
        assertEquals(node1.hashCode(), node2.hashCode());
    }
}
