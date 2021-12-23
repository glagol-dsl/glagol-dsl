package org.glagoldsl.compiler.io;

import org.glagoldsl.compiler.ast.nodes.Node;
import org.glagoldsl.compiler.ast.nodes.meta.SourcePath;
import org.glagoldsl.compiler.ast.walker.Walker;

import java.util.function.Consumer;

public class SourcePathSetter extends Walker<SourcePath> {
    private static class Listener extends org.glagoldsl.compiler.ast.walker.Listener<SourcePath> {
        @Override
        protected Consumer<SourcePath> enter(Node node) {
            return node::setPath;
        }
    }

    public SourcePathSetter() {
        super(new Listener());
    }
}
