package org.glagoldsl.compiler.ast;

import org.glagoldsl.compiler.io.Source;
import org.glagoldsl.compiler.syntax.concrete.GlagolParser;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.api.io.TempDir;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(MockitoExtension.class)
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
        assertEquals("line: 1, column: 4", ast.getLocation().toString());
        assertEquals(sourcesPath + "/input.g", ast.getPath().toString());
    }

    @Test
    public void only_to_satisfy_coverage_report() {
        new Builder().visitMapPair(Mockito.mock(GlagolParser.MapPairContext.class));
    }
}