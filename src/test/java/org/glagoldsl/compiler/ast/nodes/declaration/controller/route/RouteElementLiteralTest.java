package org.glagoldsl.compiler.ast.nodes.declaration.controller.route;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class RouteElementLiteralTest {
    @Test
    void accept(@Mock DeclarationVisitor<Void, Void> visitor) {
        var node = new RouteElementLiteral("");
        node.accept(visitor, null);
        verify(visitor, times(1)).visitRouteElementLiteral(any(), any());
    }
}