package org.glagoldsl.compiler.ast.nodes.declaration.member;

import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.glagoldsl.compiler.ast.nodes.type.Type;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

import java.util.ArrayList;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.mock;

class SignatureTest {
    @Test
    void equals() {
        var type1 = mock(Type.class);
        var type2 = mock(Type.class);
        var signature1 = new Signature(new Identifier("test"), new ArrayList<>() {{
            add(type1);
            add(type2);
        }});
        var signature2 = new Signature(new Identifier("test"), type1, type2);
        assertEquals(signature1, signature2);
    }

    @Test
    void testToString() {
        var type1 = mock(Type.class);
        var type2 = mock(Type.class);
        var signature = new Signature(new Identifier("test"), new ArrayList<>() {{
            add(type1);
            add(type2);
        }});
        assertEquals("test(" + type1 + ", " + type2 + ")", signature.toString());
    }
}