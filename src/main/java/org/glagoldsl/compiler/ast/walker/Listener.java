package org.glagoldsl.compiler.ast.walker;

import org.glagoldsl.compiler.ast.nodes.Node;
import org.glagoldsl.compiler.ast.nodes.declaration.member.Accessor;
import org.glagoldsl.compiler.ast.nodes.statement.AssignOperator;

public abstract class Listener {
    public void enter(Node node) {
    }

    public void leave(Node node) {
    }

    // Accessor does not extend Node
    // therefore we need separate methods for it
    public void enter(Accessor node) {
    }

    public void leave(Accessor node) {
    }

    // AssignOperator does not extend Node
    // therefore we need separate methods for it
    public void enter(AssignOperator node) {
    }

    public void leave(AssignOperator node) {
    }
}
