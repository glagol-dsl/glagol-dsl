package org.glagoldsl.compiler;

import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.UnbufferedCharStream;
import org.glagoldsl.compiler.syntax.concrete.GlagolLexer;
import org.glagoldsl.compiler.syntax.concrete.GlagolParser;
import org.glagoldsl.compiler.io.Source;

import java.io.IOException;
import java.nio.file.Paths;

public class App {
    public static void main(String[] args) {
        try {
            Source file = new Source(Paths.get(args[0]));
            GlagolParser parser = new GlagolParser(createTokenStream(file));
        } catch (IOException e) {
            System.out.println("Cannot load file: " + e.getMessage());
            System.exit(1);
        }
    }

    private static CommonTokenStream createTokenStream(Source file) {
        return new CommonTokenStream(new GlagolLexer(new UnbufferedCharStream(file.getInputStream())));
    }
}
