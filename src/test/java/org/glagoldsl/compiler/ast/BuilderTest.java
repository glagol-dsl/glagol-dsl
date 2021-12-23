package org.glagoldsl.compiler.ast;

import org.glagoldsl.compiler.io.Source;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.*;

class BuilderTest {
    @Test
    public void should_parse_source_file(@TempDir Path sourcesPath) throws IOException {
        var input = sourcesPath.resolve("input.g");
        Files.writeString(input, """
            namespace test;
        """);

        var builder = new Builder();
        var source = new Source(input);

        var ast = builder.build(source);

        assertEquals(1, ast.getLocation().getLine());
        assertEquals(4, ast.getLocation().getColumn());
        assertEquals(sourcesPath + "/input.g", ast.getPath().toString());
    }
}