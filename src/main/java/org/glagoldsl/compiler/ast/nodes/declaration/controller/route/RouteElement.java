package org.glagoldsl.compiler.ast.nodes.declaration.controller.route;

import org.glagoldsl.compiler.CodeCoverageIgnore;
import org.glagoldsl.compiler.ast.nodes.Node;
import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;

@CodeCoverageIgnore
public abstract class RouteElement extends Node {
    abstract public <T, C> T accept(DeclarationVisitor<T, C> visitor, C context);
}
