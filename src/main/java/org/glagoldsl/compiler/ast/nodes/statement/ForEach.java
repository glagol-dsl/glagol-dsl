package org.glagoldsl.compiler.ast.nodes.statement;

import org.glagoldsl.compiler.ast.nodes.expression.Expression;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;

import java.util.List;

public class ForEach extends Statement {
    final private Expression array;
    final private Identifier variable;
    final private List<Expression> conditions;
    final private Statement body;

    public ForEach(
            Expression array,
            Identifier variable,
            List<Expression> conditions,
            Statement body
    ) {
        this.array = array;
        this.variable = variable;
        this.conditions = conditions;
        this.body = body;
    }

    public Expression getArray() {
        return array;
    }

    public Identifier getVariable() {
        return variable;
    }

    public List<Expression> getConditions() {
        return conditions;
    }

    public Statement getBody() {
        return body;
    }

    public <T, C> T accept(StatementVisitor<T, C> visitor, C context) {
        return visitor.visitForEach(this, context);
    }
}
