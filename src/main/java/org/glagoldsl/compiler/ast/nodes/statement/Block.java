package org.glagoldsl.compiler.ast.nodes.statement;

import java.util.List;

public class Block extends Statement {
    final private List<Statement> statements;

    public Block(List<Statement> statements) {
        this.statements = statements;
    }

    public List<Statement> getStatements() {
        return statements;
    }

    public <T, C> T accept(StatementVisitor<T, C> visitor, C context) {
        return visitor.visitBlock(this, context);
    }
}
