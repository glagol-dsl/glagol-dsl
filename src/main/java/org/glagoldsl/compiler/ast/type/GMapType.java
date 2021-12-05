package org.glagoldsl.compiler.ast.type;

public class GMapType extends Type {
    final private Type keyType;
    final private Type valueType;

    public GMapType(Type keyType, Type valueType) {
        this.keyType = keyType;
        this.valueType = valueType;
    }

    public Type getKeyType() {
        return keyType;
    }

    public Type getValueType() {
        return valueType;
    }

    @Override
    public String toString() {
        return "{" + keyType + ',' + valueType + '}';
    }
}
