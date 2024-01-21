package org.glagoldsl.compiler.ast.walker;

import org.glagoldsl.compiler.CodeCoverageIgnore;
import org.glagoldsl.compiler.ast.nodes.Node;
import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationCollection;
import org.glagoldsl.compiler.ast.nodes.declaration.member.Accessor;
import org.glagoldsl.compiler.ast.nodes.declaration.member.MemberCollection;
import org.glagoldsl.compiler.ast.nodes.statement.AssignOperator;

@CodeCoverageIgnore
public abstract class Listener {
    public void enter(Node node) {
    }

    public void leave(Node node) {
    }

    // Following methods are for nodes that do not extend the Node class

    public void enter(Accessor node) {
    }

    public void leave(Accessor node) {
    }

    public void enter(AssignOperator node) {
    }

    public void leave(AssignOperator node) {
    }

    public void enter(MemberCollection node) {
    }

    public void leave(MemberCollection node) {
    }

    public void enter(DeclarationCollection node) {

    }

    public void leave(DeclarationCollection node) {

    }
}
