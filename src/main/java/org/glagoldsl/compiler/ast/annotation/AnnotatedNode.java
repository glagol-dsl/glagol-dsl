package org.glagoldsl.compiler.ast.annotation;

import org.glagoldsl.compiler.ast.Node;

import java.util.ArrayList;
import java.util.List;

public abstract class AnnotatedNode extends Node {
    final private List<Annotation> annotations = new ArrayList<>();

    public List<Annotation> getAnnotations() {
        return annotations;
    }

    public void addAnnotation(Annotation annotation) {
        annotations.add(annotation);
    }
}
