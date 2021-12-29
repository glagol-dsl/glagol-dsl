package org.glagoldsl.compiler.io;

import org.glagoldsl.compiler.ast.nodes.meta.SourcePath;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Path;

public class Source {
    private final InputStream inputStream;
    private final SourcePath sourcePath;

    public Source(SourcePath sourcePath) throws IOException {
        this.sourcePath = sourcePath;

        if (!isExtensionCorrect(sourcePath.getPath())) {
            throw new IncorrectExtensionException();
        }

        inputStream = new FileInputStream(sourcePath.getPath().toFile());
    }

    public InputStream getInputStream() {
        return inputStream;
    }

    private boolean isExtensionCorrect(Path file) {
        return file.getFileName().toString().matches("^.+?\\." + extension() + "$");
    }

    private String extension() {
        return "g";
    }

    public SourcePath getSourcePath() {
        return sourcePath;
    }
}
