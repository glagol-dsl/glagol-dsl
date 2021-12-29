package org.glagoldsl.compiler.ast.nodes.meta;

import java.nio.file.Path;

public class SourcePath {
    final private Path path;

    public SourcePath(Path path) {
        this.path = path;
    }

    public Path getPath() {
        return path;
    }

    @Override
    public String toString() {
        return path.toString();
    }
}
