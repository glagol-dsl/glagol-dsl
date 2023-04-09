package org.glagoldsl.compiler.ast.nodes.declaration.controller.route;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;

public class RouteElementPlaceholder extends RouteElement {
    final private String placeholder;

    public RouteElementPlaceholder(String placeholder) {
        this.placeholder = placeholder;
    }

    @Override
    public String toString() {
        return ':' + placeholder;
    }

    public <T, C> T accept(DeclarationVisitor<T, C> visitor, C context) {
        return visitor.visitRouteElementPlaceholder(this, context);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        RouteElementPlaceholder that = (RouteElementPlaceholder) o;

        return placeholder.equals(that.placeholder);
    }

    @Override
    public int hashCode() {
        return placeholder.hashCode();
    }
}
