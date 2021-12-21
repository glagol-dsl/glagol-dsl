package org.glagoldsl.compiler.ast.statement;

import org.glagoldsl.compiler.ast.Node;

public abstract class Statement extends Node {
    public boolean isEmpty() {
        return false;
    }
}
