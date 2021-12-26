package org.glagoldsl.compiler.ast.nodes.annotation;

import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.ArrayList;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AnnotationTest {
    @Test
    void accept(@Mock AnnotationVisitor<Void, Void> visitor) {
        var node = new Annotation(mock(Identifier.class), new ArrayList<>());

        node.accept(visitor, null);

        verify(visitor, times(1)).visitAnnotation(any(), any());
    }
}