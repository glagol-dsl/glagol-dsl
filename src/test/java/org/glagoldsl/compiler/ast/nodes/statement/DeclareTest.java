package org.glagoldsl.compiler.ast.nodes.statement;

import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.glagoldsl.compiler.ast.nodes.type.Type;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class DeclareTest {
    @Test
    void accept(@Mock StatementVisitor<Void, Void> visitor) {
        var node = new Declare(mock(Type.class), mock(Identifier.class), mock(Statement.class));
        node.accept(visitor, null);
        verify(visitor, times(1)).visitDeclare(any(), any());
    }
}