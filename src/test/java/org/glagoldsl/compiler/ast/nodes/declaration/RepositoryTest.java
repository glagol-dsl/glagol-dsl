package org.glagoldsl.compiler.ast.nodes.declaration;

import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.ArrayList;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class RepositoryTest {

    @Test
    void accept(@Mock DeclarationVisitor<Void, Void> visitor) {
        var node = new Repository(mock(Identifier.class), new ArrayList<>());
        node.accept(visitor, null);
        verify(visitor, times(1)).visitRepository(any(), any());
    }
}