lexer grammar GlagolLexer;

@header {
package org.glagoldsl.compiler.syntax.concrete;
}

Namespace: 'namespace';
Entity: 'entity';
Value: 'value';
Repository: 'repository';
Controller: 'controller';
Import: 'import';
Alias: 'as';
Rest: 'rest';
Utility: 'util';
Service: 'service';
Proxy: 'proxy';
New: 'new';
This: 'this';
Public: 'public';
Private: 'private';
If: 'if';
Else: 'else';
ElseIf: 'elseif';
Return: 'return';
For: 'for';
Persist: 'persist';
Flush: 'flush';
Remove: 'remove';
Break: 'break';
Continue: 'continue';
Select: 'SELECT';
From: 'FROM';
Where: 'WHERE';
Order: 'ORDER';
By: 'BY';
Limit: 'LIMIT';
Is: 'IS';
Ascending: 'ASC';
Descending: 'DESC';
Offset: 'OFFSET';
Integer: 'int';
Float: 'float';
Bool: 'bool';
Void: 'void';
String: 'string';
Require: 'require';
OpenBracket: '[';
CloseBracket: ']';
OpenParen: '(';
CloseParen: ')';
OpenBrace: '{';
CloseBrace: '}';
SemiColon: ';';
Comma: ',';
Assign: '=';
QuestionMark: '?';
DoubleColon: '::';
Colon: ':';
Dot: '.';
PlusPlus: '++';
MinusMinus: '--';
Plus: '+';
Minus: '-';
BitNot: '~';
Not: '!';
NotALT: 'NOT';
NullAlt: 'NULL';
Multiply: '*';
Divide: '/';
Modulus: '%';
Power: '**';
NullCoalesce: '??';
Hashtag: '#';
LessThan: '<';
MoreThan: '>';
LessThanEquals: '<=';
GreaterThanEquals: '>=';
Equals: '==';
NotEquals: '!=';
BitAnd: '&';
BitXOr: '^';
BitOr: '|';
And: '&&';
Or: '||';
AndAlt: 'AND';
OrAlt: 'OR';
MultiplyAssign: '*=';
DivideAssign: '/=';
ModulusAssign: '%=';
PlusAssign: '+=';
MinusAssign: '-=';
BitAndAssign: '&=';
BitXorAssign: '^=';
BitOrAssign: '|=';
Arrow: '=>';
RightShiftArithmetic: '>>';
LeftShiftArithmetic: '<<';
True: 'true';
False: 'false';

AnnotationName: '@' Identifier;

Identifier : [a-zA-Z][a-zA-Z0-9_]*;

Whitespace  :  [ \t\r\n\u000C]+ -> skip
    ;

PhpClass : ('\\' [a-zA-Z0-9_]+)+;

// literal
StringLiteral : '"' (EscapeQuote | ~ ["\\])* '"';
DecimalLiteral : [0-9]+ '.' [0-9]+;
IntegerLiteral : [0-9]+;

fragment EscapeQuote
   : '\\' (["\\/bfnrt] | Unicode)
   ;
fragment Unicode
   : 'u' Hex Hex Hex Hex
   ;
fragment Hex
   : [0-9a-fA-F]
   ;