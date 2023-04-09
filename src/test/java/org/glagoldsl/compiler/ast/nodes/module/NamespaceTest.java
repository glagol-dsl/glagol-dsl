package org.glagoldsl.compiler.ast.nodes.module;

import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.ArrayList;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class NamespaceTest {
    @Test
    void accept(@Mock ModuleVisitor<Void, Void> visitor) {
        var node = new Namespace(new ArrayList<>());
        node.accept(visitor, null);
        verify(visitor, times(1)).visitNamespace(any(), any());
    }

    @Test
    void equals() {
        var ns1 = new Namespace(new Identifier("Test"));
        var ns2 = new Namespace(new Identifier("Test"));

        assertEquals(ns1, ns2);
    }
}
