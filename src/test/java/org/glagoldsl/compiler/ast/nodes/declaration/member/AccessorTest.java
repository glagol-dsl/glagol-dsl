package org.glagoldsl.compiler.ast.nodes.declaration.member;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AccessorTest {
    @Test
    void accept(@Mock DeclarationVisitor<Void, Void> visitor) {
        var node = Accessor.PUBLIC;
        node.accept(visitor, null);
        verify(visitor, times(1)).visitAccessor(any(), any());
    }
}