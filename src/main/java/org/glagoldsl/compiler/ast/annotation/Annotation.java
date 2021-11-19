package org.glagoldsl.compiler.ast.annotation;

import org.glagoldsl.compiler.ast.Node;
import org.glagoldsl.compiler.ast.identifier.Identifier;

public class Annotation extends Node {
    final private Identifier name;

    public Annotation(Identifier name) {
        this.name = name;
    }

    public Identifier getName() {
        return name;
    }
}
