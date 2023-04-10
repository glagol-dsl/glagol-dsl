package org.glagoldsl.compiler.ast.nodes.declaration.controller;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.route.Route;
import org.glagoldsl.compiler.ast.nodes.declaration.member.MemberCollection;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.ArrayList;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class RestControllerTest {
    @Test
    void accept(@Mock DeclarationVisitor<Void, Void> visitor) {
        var node = new RestController(mock(Route.class), new MemberCollection());
        node.accept(visitor, null);
        verify(visitor, times(1)).visitRestController(any(), any());
    }

    @Test
    void getMembers() {
        var node = new RestController(mock(Route.class), new MemberCollection());
        assertEquals(new MemberCollection(), node.getMembers());
    }

    @Test
    void testToString() {
        var node = new RestController(mock(Route.class), new MemberCollection());
        assertEquals("rest controller", node.toString());
    }
}
