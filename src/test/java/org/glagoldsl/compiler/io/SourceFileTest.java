package org.glagoldsl.compiler.io;

import org.apache.commons.io.FileUtils;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;

import java.io.IOException;
import java.nio.file.FileSystem;
import java.nio.file.Path;
import java.nio.file.spi.FileSystemProvider;

import static org.mockito.Mockito.*;

public class SourceFileTest {

    @Test(expected = IncorrectExtensionException.class)
    public void throws_exception_when_source_file_has_wrong_extension() throws IOException {
        TemporaryFolder testFolder = new TemporaryFolder();
        testFolder.create();

        Path filePath = testFolder.newFile("source.wrong").toPath();

        new SourceFile(filePath);
    }

    @Test(expected = FileNotFoundException.class)
    public void throws_exception_when_source_file_does_not_exist() throws IOException {
        Path filePath = mock(Path.class);
        FileSystem fileSystem = mock(FileSystem.class);
        FileSystemProvider fileSystemProvider = mock(FileSystemProvider.class);

        when(fileSystem.provider()).thenReturn(fileSystemProvider);
        when(filePath.getFileSystem()).thenReturn(fileSystem);

        doThrow(IOException.class).when(fileSystemProvider).checkAccess(any(Path.class));

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