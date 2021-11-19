package org.glagoldsl.compiler.ast.declaration.controller.route;

public class RouteElementLiteral extends RouteElement {
    final private String value;

    public RouteElementLiteral(String value) {
        this.value = value;
    }

    public String toString() {
        return value;
    }
}
