package org.glagoldsl.compiler.ast.nodes.expression;

import java.util.List;

public class GList extends Expression {
    final private List<Expression> expressions;

    public GList(List<Expression> expressions) {
        this.expressions = expressions;
    }

    public List<Expression> getExpressions() {
        return expressions;
    }

    public <T, C> T accept(ExpressionVisitor<T, C> visitor, C context) {
        return visitor.visitGList(this, context);
    }
}
