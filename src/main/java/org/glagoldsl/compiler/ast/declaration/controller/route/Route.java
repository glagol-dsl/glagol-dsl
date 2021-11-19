package org.glagoldsl.compiler.ast.declaration.controller.route;

import org.glagoldsl.compiler.ast.Node;

import java.util.List;

public final class Route extends Node {
    private final List<RouteElement> routeElements;

    public Route(
            List<RouteElement> routeElements) {
        this.routeElements = routeElements;
    }

    public List<RouteElement> getRouteElements() {
        return routeElements;
    }

    @Override
    public String toString() {
        return routeElements.stream().map(RouteElement::toString).reduce("", (path, e) -> path + '/' + e);
    }
}
