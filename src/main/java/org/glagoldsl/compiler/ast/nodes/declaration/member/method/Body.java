package org.glagoldsl.compiler.ast.nodes.declaration.member.method;

import org.glagoldsl.compiler.ast.nodes.Node;
import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.glagoldsl.compiler.ast.nodes.statement.Statement;

import java.util.List;

public class Body extends Node {
    final private List<Statement> statements;

    public Body(List<Statement> statements) {
        this.statements = statements;
    }

    public List<Statement> getStatements() {
        return statements;
    }

    public boolean isEmpty() {
        return statements.isEmpty() || (statements.size() == 1 && statements.get(0).isEmpty());
    }

    public <T, C> T accept(DeclarationVisitor<T, C> visitor, C context) {
        return visitor.visitBody(this, context);
    }
}
