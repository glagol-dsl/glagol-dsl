package org.glagoldsl.compiler.ast.nodes.statement;

import org.glagoldsl.compiler.ast.nodes.expression.Expression;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.ArrayList;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ForEachWithKeyTest {
    @Test
    void accept(@Mock StatementVisitor<Void, Void> visitor) {
        var node = new ForEachWithKey(
                mock(Expression.class), mock(Identifier.class), mock(Identifier.class), new ArrayList<>(),
                mock(Statement.class)
        );
        node.accept(visitor, null);
        verify(visitor, times(1)).visitForEachWithKey(any(), any());
    }
}