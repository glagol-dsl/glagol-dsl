package org.glagoldsl.compiler.ast.nodes.identifier;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.ArrayList;

import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(MockitoExtension.class)
class IdentifierTest {
    @Test
    void accept(@Mock IdentifierVisitor<Void, Void> visitor) {
        var node = new Identifier(anyString());
        node.accept(visitor, any());
        verify(visitor, times(1)).visitIdentifier(any(), any());
    }

    @Test
    void equals() {
        var id1 = new Identifier("test");
        var id2 = new Identifier("test");

        assertEquals(id1, id2);
        assertEquals(id2, id1);

        var list1 = new ArrayList<Identifier>() {{
            add(new Identifier("test"));
            add(new Identifier("test"));
        }};
        var list2 = new ArrayList<Identifier>() {{
            add(new Identifier("test"));
            add(new Identifier("test"));
        }};
        var list3 = new ArrayList<Identifier>() {{
            add(new Identifier("test"));
            add(new Identifier("test2"));
        }};
        var list4 = new ArrayList<Identifier>() {{
            add(new Identifier("test"));
            add(new Identifier("test"));
            add(new Identifier("test"));
        }};

        assertEquals(list1, list2);
        assertNotEquals(list1, list3);
        assertNotEquals(list1, list4);
    }
}
