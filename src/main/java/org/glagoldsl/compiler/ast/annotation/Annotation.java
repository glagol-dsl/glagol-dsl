package org.glagoldsl.compiler.ast.annotation;

import org.glagoldsl.compiler.ast.Node;
import org.glagoldsl.compiler.ast.identifier.Identifier;

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
}
