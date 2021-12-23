package org.glagoldsl.compiler.ast.nodes.expression;

import java.util.Map;

public class GMap extends Expression {
    final private Map<Expression, Expression> pairs;

    public GMap(Map<Expression, Expression> pairs) {
        this.pairs = pairs;
    }

    public Map<Expression, Expression> getPairs() {
        return pairs;
    }

    public <T, C> T accept(ExpressionVisitor<T, C> visitor, C context) {
        return visitor.visitGMap(this, context);
    }
}
