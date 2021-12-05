package org.glagoldsl.compiler.ast.annotation;

import org.glagoldsl.compiler.ast.Node;
import org.glagoldsl.compiler.ast.expression.Expression;

public class AnnotationArgument extends Node {
    final private Expression expression;

    public AnnotationArgument(Expression expression) {
        this.expression = expression;
    }

    public Expression getExpression() {
        return expression;
    }
}
