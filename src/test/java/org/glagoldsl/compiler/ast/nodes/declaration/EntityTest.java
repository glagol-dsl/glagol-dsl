package org.glagoldsl.compiler.ast.nodes.declaration;

import org.glagoldsl.compiler.ast.nodes.declaration.member.MemberCollection;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class EntityTest {
    @Test
    void accept(@Mock DeclarationVisitor<Void, Void> visitor) {
        var node = new Entity(mock(Identifier.class), new MemberCollection());
        node.accept(visitor, null);

        verify(visitor, times(1)).visitEntity(any(), any());
    }

    @Test
    void getMembers() {
        var members = new MemberCollection();
        var node = new Entity(mock(Identifier.class), members);
        assertSame(members, node.getMembers());
    }

    @Test
    void testToString() {
        var node = new Entity(mock(Identifier.class), new MemberCollection());
        assertEquals("entity", node.toString());
    }
}
