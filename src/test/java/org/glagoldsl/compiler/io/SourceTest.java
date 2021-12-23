package org.glagoldsl.compiler.io;

import org.apache.commons.io.FileUtils;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.assertThrows;

public class SourceTest {

    @Test
    public void throws_exception_when_source_file_has_wrong_extension(@TempDir Path testFolder) {
        Path filePath = testFolder.resolve("source.wrong");

        assertThrows(IncorrectExtensionException.class, () -> {
            new Source(filePath);
        });
    }

    @Test
    public void should_create_source_file_from_a_valid_file(@TempDir Path testFolder) throws Exception {
        Path filePath = testFolder.resolve("source.g");

        String code = "namespace test;";
        FileUtils.fileWrite(filePath.toString(), code);

        new Source(filePath);
    }
}