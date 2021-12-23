package org.glagoldsl.compiler.ast.nodes.declaration.controller;

import org.glagoldsl.compiler.ast.nodes.declaration.Declaration;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.route.Route;

public abstract class Controller extends Declaration {
    final private Route route;

    public Controller(Route route) {
        this.route = route;
    }

    public Route getRoute() {
        return route;
    }
}
