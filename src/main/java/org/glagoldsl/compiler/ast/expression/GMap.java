package org.glagoldsl.compiler.ast.expression;

import java.util.Map;

public class GMap extends Expression {
    final private Map<Expression, Expression> pairs;

    public GMap(Map<Expression, Expression> pairs) {
        this.pairs = pairs;
    }

    public Map<Expression, Expression> getPairs() {
        return pairs;
    }
}
