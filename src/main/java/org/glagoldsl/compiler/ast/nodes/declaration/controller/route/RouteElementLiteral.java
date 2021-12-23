package org.glagoldsl.compiler.ast.nodes.declaration.controller.route;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;

public class RouteElementLiteral extends RouteElement {
    final private String value;

    public RouteElementLiteral(String value) {
        this.value = value;
    }

    @Override
    public String toString() {
        return value;
    }

    public <T, C> T accept(DeclarationVisitor<T, C> visitor, C context) {
        return visitor.visitRouteElementLiteral(this, context);
    }
}
