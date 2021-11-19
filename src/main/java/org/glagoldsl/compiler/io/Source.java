package org.glagoldsl.compiler.io;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Path;

public class Source {
    private final InputStream inputStream;

    public Source(Path file) throws IOException {
        if (!isExtensionCorrect(file)) {
            throw new IncorrectExtensionException();
        }

        inputStream = new FileInputStream(file.toFile());
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
}
