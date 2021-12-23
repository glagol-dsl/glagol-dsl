package org.glagoldsl.compiler.ast.nodes.declaration.controller.route;

import org.glagoldsl.compiler.ast.nodes.Node;
import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;

import java.util.List;

public class Route extends Node {
    private final List<RouteElement> routeElements;

    public Route(
            List<RouteElement> routeElements) {
        this.routeElements = routeElements;
    }

    @Override
    public String toString() {
        return routeElements.stream().map(RouteElement::toString).reduce("", (path, e) -> path + '/' + e);
    }

    public List<RouteElement> getRouteElements() {
        return routeElements;
    }

    public <T, C> T accept(DeclarationVisitor<T, C> visitor, C context) {
        return visitor.visitRoute(this, context);
    }
}
