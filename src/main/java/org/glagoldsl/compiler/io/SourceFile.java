package org.glagoldsl.compiler.io;

import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.UnbufferedCharStream;
import org.glagoldsl.compiler.syntax.concrete.GlagolLexer;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;

public class SourceFile {
    private final InputStream inputStream;

    public SourceFile(Path file) throws IOException {
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
