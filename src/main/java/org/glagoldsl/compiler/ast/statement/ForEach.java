package org.glagoldsl.compiler.ast.statement;

import org.glagoldsl.compiler.ast.expression.Expression;
import org.glagoldsl.compiler.ast.identifier.Identifier;

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
}
