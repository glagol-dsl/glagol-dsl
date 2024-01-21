package org.glagoldsl.compiler.ast.nodes.annotation;

import org.glagoldsl.compiler.CodeCoverageIgnore;

@CodeCoverageIgnore
public interface AnnotationVisitor<T, C> {
    default T visitAnnotation(Annotation node, C context) {
        return null;
    }

    default T visitAnnotationArgument(AnnotationArgument node, C context) {
        return null;
    }
}
