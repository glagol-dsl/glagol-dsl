package org.glagoldsl.compiler.typechecker;

import org.glagoldsl.compiler.ast.nodes.Node;

public record Error(Node node, String message) {
}
