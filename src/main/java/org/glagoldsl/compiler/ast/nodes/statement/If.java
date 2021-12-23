package org.glagoldsl.compiler.ast.nodes.statement;

import org.glagoldsl.compiler.ast.nodes.expression.Expression;

public class If extends Statement {
    final private Expression condition;
    final private Statement then;
    final private Statement elseStmt;

    public If(
            Expression condition,
            Statement then,
            Statement elseStmt
    ) {
        this.condition = condition;
        this.then = then;
        this.elseStmt = elseStmt;
    }

    public Expression getCondition() {
        return condition;
    }

    public Statement getThen() {
        return then;
    }

    public Statement getElse() {
        return elseStmt;
    }

    public <T, C> T accept(StatementVisitor<T, C> visitor, C context) {
        return visitor.visitIf(this, context);
    }
}
