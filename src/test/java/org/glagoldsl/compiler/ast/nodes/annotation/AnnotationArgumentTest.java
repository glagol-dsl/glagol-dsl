package org.glagoldsl.compiler.ast.nodes.annotation;

import org.glagoldsl.compiler.ast.nodes.expression.Expression;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.ArrayList;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AnnotationArgumentTest {
    @Test
    void accept(@Mock AnnotationVisitor<Void, Void> visitor) {
        var node = new AnnotationArgument(mock(Expression.class));

        node.accept(visitor, null);

        verify(visitor, times(1)).visitAnnotationArgument(any(), any());
    }
}