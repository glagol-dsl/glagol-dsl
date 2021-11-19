package org.glagoldsl.compiler.io;

import org.apache.commons.io.FileUtils;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;

import java.io.IOException;
import java.nio.file.FileSystem;
import java.nio.file.Path;
import java.nio.file.spi.FileSystemProvider;

import static org.mockito.Mockito.*;

@RunWith(MockitoJUnitRunner.class)
public class SourceFileTest {

    @Test(expected = IncorrectExtensionException.class)
    public void throws_exception_when_source_file_has_wrong_extension() throws IOException {
        TemporaryFolder testFolder = new TemporaryFolder();
        testFolder.create();

        Path filePath = testFolder.newFile("source.wrong").toPath();

        new SourceFile(filePath);
    }

    @Test
    public void should_create_source_file_from_a_valid_file() throws Exception {
        TemporaryFolder testFolder = new TemporaryFolder();
        testFolder.create();

        Path filePath = testFolder.newFile("source.g").toPath();

        String code = "namespace test;";
        FileUtils.fileWrite(filePath.toString(), code);

        new SourceFile(filePath);
    }
}