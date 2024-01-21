package org.glagoldsl.compiler.ast.nodes.module;

import org.glagoldsl.compiler.CodeCoverageIgnore;
import org.glagoldsl.compiler.ast.nodes.Node;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Namespace extends Node {
    public static final String NAMESPACE_DELIMITER = "::";

    private final List<Identifier> names;

    public Namespace(List<Identifier> names) {
        this.names = names;
    }

    public Namespace(Identifier... names) {
        this.names = new ArrayList<>() {{
            addAll(Arrays.asList(names));
        }};
    }

    public List<Identifier> getNames() {
        return names;
    }

    @Override
    public String toString() {
        return String.join(NAMESPACE_DELIMITER, names.stream().map(Identifier::toString).toList());
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Namespace namespace = (Namespace) o;

        return names.equals(namespace.names);
    }

    @Override
    @CodeCoverageIgnore
    public int hashCode() {
        return names.hashCode();
    }

    public <T, C> T accept(ModuleVisitor<T, C> visitor, C context) {
        return visitor.visitNamespace(this, context);
    }
}
