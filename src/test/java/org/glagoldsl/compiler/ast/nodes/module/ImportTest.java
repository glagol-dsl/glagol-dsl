package org.glagoldsl.compiler.ast.nodes.module;

import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ImportTest {
    @Test
    void accept(@Mock ModuleVisitor<Void, Void> visitor) {
        var node = new Import(mock(Namespace.class), mock(Identifier.class), mock(Identifier.class));
        node.accept(visitor, null);
        verify(visitor, times(1)).visitImport(any(), any());
    }
}