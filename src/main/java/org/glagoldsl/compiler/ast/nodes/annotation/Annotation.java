package org.glagoldsl.compiler.ast.nodes.annotation;

import org.glagoldsl.compiler.ast.nodes.Node;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;

import java.util.List;

public class Annotation extends Node {
    final private Identifier name;
    final private List<AnnotationArgument> arguments;

    public Annotation(Identifier name, List<AnnotationArgument> arguments) {
        this.name = name;
        this.arguments = arguments;
    }

    public Identifier getName() {
        return name;
    }

    public List<AnnotationArgument> getArguments() {
        return arguments;
    }

    public <T, C> T accept(AnnotationVisitor<T, C> visitor, C context) {
        return visitor.visitAnnotation(this, context);
    }
}
