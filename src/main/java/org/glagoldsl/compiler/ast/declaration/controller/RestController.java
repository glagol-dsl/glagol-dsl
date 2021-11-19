package org.glagoldsl.compiler.ast.declaration.controller;

import org.glagoldsl.compiler.ast.declaration.Controller;
import org.glagoldsl.compiler.ast.declaration.controller.route.Route;

public class RestController extends Controller {
    public RestController(Route route) {
        super(route);
    }
}
