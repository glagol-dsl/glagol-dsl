package org.glagoldsl.compiler.ast.nodes.annotation;

public interface AnnotationVisitor<T, C> {
    T visitAnnotation(Annotation node, C context);
    T visitAnnotationArgument(AnnotationArgument node, C context);
}
