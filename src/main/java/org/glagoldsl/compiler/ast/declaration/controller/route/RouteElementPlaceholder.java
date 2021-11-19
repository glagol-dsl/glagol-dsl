package org.glagoldsl.compiler.ast.declaration.controller.route;

public class RouteElementPlaceholder extends RouteElement {
    final private String placeholder;

    public RouteElementPlaceholder(String placeholder) {
        this.placeholder = placeholder;
    }

    @Override
    public String toString() {
        return placeholder;
    }
}
