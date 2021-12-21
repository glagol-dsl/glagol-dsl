package org.glagoldsl.compiler.ast.statement;

import org.glagoldsl.compiler.ast.expression.Expression;
import org.glagoldsl.compiler.ast.identifier.Identifier;

import java.util.List;

public class ForEachWithKey extends ForEach {
    final private Identifier key;

    public ForEachWithKey(
            Expression array,
            Identifier key,
            Identifier variable,
            List<Expression> conditions,
            Statement body
    ) {
        super(
                array,
                variable,
                conditions,
                body
        );
        this.key = key;
    }

    public Identifier getKey() {
        return key;
    }
}
