package org.glagoldsl.compiler.ast;

import org.junit.Test;

import static org.junit.Assert.*;

public class NodeTest {
    @Test(expected = RuntimeException.class)
    public void should_throw_exception_when_getting_line_without_location_set()
    {
        var node = new Node() {};
        node.getLocation().getLine();
    }

    @Test(expected = RuntimeException.class)
    public void should_throw_exception_when_getting_column_without_location_set()
    {
        var node = new Node() {};
        node.getLocation().getColumn();
    }

    @Test
    public void should_get_undefined_location_as_string()
    {
        var node = new Node() {};
        assertEquals("line: undefined, column: undefined", node.getLocation().toString());
    }

    @Test
    public void should_get_undefined_source_path_without_location_set()
    {
        var node = new Node() {};

        assertEquals("undefined source path", node.getPath().toString());
    }
}