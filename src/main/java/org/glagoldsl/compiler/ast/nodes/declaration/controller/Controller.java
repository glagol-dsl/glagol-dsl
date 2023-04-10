package org.glagoldsl.compiler.ast.nodes.declaration.controller;

import org.glagoldsl.compiler.ast.nodes.declaration.Declaration;
import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationPointer;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.route.Route;
import org.glagoldsl.compiler.ast.nodes.module.Module;

public abstract class Controller extends Declaration {
    final private Route route;

    public Controller(Route route) {
        this.route = route;
    }

    public Route getRoute() {
        return route;
    }

    @Override
    public DeclarationPointer pointer(Module module) {
        return new DeclarationPointer(module, this);
    }
}
