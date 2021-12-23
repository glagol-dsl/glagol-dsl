package org.glagoldsl.compiler.ast.nodes.module;

import org.glagoldsl.compiler.ast.nodes.Node;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;

import java.util.List;

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

    public <T, C> T accept(ModuleVisitor<T, C> visitor, C context) {
        return visitor.visitNamespace(this, context);
    }
}
