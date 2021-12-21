package org.glagoldsl.compiler.ast.statement;

import org.glagoldsl.compiler.ast.expression.Expression;

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

    public Statement getElseStmt() {
        return elseStmt;
    }
}
