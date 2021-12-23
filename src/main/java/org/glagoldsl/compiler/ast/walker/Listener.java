package org.glagoldsl.compiler.ast.walker;

import org.glagoldsl.compiler.ast.nodes.Node;
import org.glagoldsl.compiler.ast.nodes.declaration.member.Accessor;
import org.glagoldsl.compiler.ast.nodes.statement.AssignOperator;

import java.util.function.Consumer;

public abstract class Listener<T> {
    protected Consumer<T> enter(Node node) {
        return context -> {
        };
    }

    protected Consumer<T> leave(Node node) {
        return context -> {
        };
    }

    protected Consumer<T> enter(Accessor node) {
        return context -> {
        };
    }

    protected Consumer<T> leave(Accessor node) {
        return context -> {
        };
    }

    protected Consumer<T> enter(AssignOperator node) {
        return context -> {
        };
    }

    protected Consumer<T> leave(AssignOperator node) {
        return context -> {
        };
    }
}
