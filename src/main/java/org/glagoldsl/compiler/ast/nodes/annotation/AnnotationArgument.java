package org.glagoldsl.compiler.ast.nodes.annotation;

import org.glagoldsl.compiler.ast.nodes.Node;
import org.glagoldsl.compiler.ast.nodes.expression.Expression;

public class AnnotationArgument extends Node {
    final private Expression expression;

    public AnnotationArgument(Expression expression) {
        this.expression = expression;
    }

    public Expression getExpression() {
        return expression;
    }

    public <T, C> T accept(AnnotationVisitor<T, C> visitor, C context) {
        return visitor.visitAnnotationArgument(this, context);
    }
}
