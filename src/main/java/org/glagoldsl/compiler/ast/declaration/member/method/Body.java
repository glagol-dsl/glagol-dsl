package org.glagoldsl.compiler.ast.declaration.member.method;

import org.glagoldsl.compiler.ast.Node;
import org.glagoldsl.compiler.ast.statement.Statement;

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
        return statements.size() == 0 || (statements.size() == 1 && statements.get(0).isEmpty());
    }
}
