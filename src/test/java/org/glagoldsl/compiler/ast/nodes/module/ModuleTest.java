package org.glagoldsl.compiler.ast.nodes.module;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationCollection;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.ArrayList;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ModuleTest {
    @Test
    void accept(@Mock ModuleVisitor<Void, Void> visitor) {
        var node = new Module(mock(Namespace.class), new ImportCollection(), new DeclarationCollection());
        node.accept(visitor, null);
        verify(visitor, times(1)).visitModule(any(), any());
    }
}
