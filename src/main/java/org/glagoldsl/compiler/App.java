package org.glagoldsl.compiler;

import org.glagoldsl.compiler.ast.Builder;
import org.glagoldsl.compiler.ast.nodes.meta.SourcePath;
import org.glagoldsl.compiler.io.Source;

import java.io.IOException;
import java.nio.file.Paths;

public class App {
    public static void main(String[] args) {
        try {
            var module = new Builder().build(new Source(new SourcePath(Paths.get(args[0]))));
        } catch (IOException e) {
            System.err.println(e.getMessage());
            System.exit(1);
        }
    }
}
