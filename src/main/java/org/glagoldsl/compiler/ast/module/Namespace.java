package org.glagoldsl.compiler.ast.module;

import org.glagoldsl.compiler.ast.Node;
import org.glagoldsl.compiler.ast.identifier.Identifier;

import java.util.List;
import java.util.Objects;

public class Namespace extends Node {
    private final List<Identifier> names;

    public Namespace(List<Identifier> names) {
        this.names = names;
    }

    public List<Identifier> getNames() {
        return names;
    }

    @Override
    public String toString() {
        return String.join("::", names.stream().map(Identifier::toString).toList());
    }
}
