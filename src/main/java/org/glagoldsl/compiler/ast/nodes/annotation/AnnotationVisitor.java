package org.glagoldsl.compiler.ast.nodes.annotation;

public interface AnnotationVisitor<T, C> {
    default T visitAnnotation(Annotation node, C context) {
        return null;
    }

    default T visitAnnotationArgument(AnnotationArgument node, C context) {
        return null;
    }
}
