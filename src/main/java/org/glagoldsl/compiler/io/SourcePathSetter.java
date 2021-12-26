package org.glagoldsl.compiler.io;

import org.glagoldsl.compiler.ast.nodes.Node;
import org.glagoldsl.compiler.ast.nodes.meta.SourcePath;
import org.glagoldsl.compiler.ast.walker.Listener;
import org.glagoldsl.compiler.ast.walker.Walker;

public class SourcePathSetter extends Walker {
    public SourcePathSetter(SourcePath sourcePath) {
        super(new Listener() {
            @Override
            public void enter(Node node) {
                node.setPath(sourcePath);
            }
        });
    }
}
