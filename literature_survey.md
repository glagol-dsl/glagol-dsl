### Glagol DSL - literature survey

#### Domain-Driven Design, Eric Evans
The book that coined the term DDD will be used as a key reference point for implementing the Model-Driven Design within the grammar of Glagol DSL. In his book, Eric Evans describes the Model-Driven Design as the compilation of several patterns can stand in the core of Domain-Driven Design. As formalized package of patterns, this documentation will be used to extract and insert the patterns into the Glagol DSL grammar.
The following language declarations will reflect the Model-Driven Design: 
    - Entity (entity NAME)
    - Repository (repository for NAME)
    - Value Object (value NAME)
    - Services (util|service NAME)

#### Theory of programming languages (Теория на езиците за програмиране), Juliana Doshkova
A distilled reference book for basic mathematical principles behind formal languages. Includes explanataions about Automata theory, State machines, Turing Machine. Furthermore, the book describes a procedural language in a BNF format, which will be helpful when writing the IntelliJ Idea plugin for Glagol DSL.

#### The Definitive ANTLR 4 Reference, Terrance Parr
As the antlr4 parser generator can be used for writing IntelliJ Idea plugins, this book will be useful to understand the underlying concepts of ANTLR v4. With the help of the large database of already defined grammars for popular languages, the Glagol DSL syntax should be translated into ANTLR 4 and colorized using IntelliJ Idea plugin library. 
The reason behind researching into ANTLR v4 alongside the standard IntelliJ Idea BNF parser generator is because of the lack of documentation from JetBrains. On the other hand, ANTLR 4 has adoption layers so it can be used for plugin writing as well.

#### Metamorphic Domain-Specific Languages: A Journey Into the Shapes of a Language, Mathieu Acher, Benoit Combemale, Philippe Collet 
In this paper the authors describe the pitfalls with using external and internal DSLs. They suggest a an approach where a DSL is embedded within a general-purpose language. A similar approach has been applied within the Doctrine ORM project - the DQL (Doctrine Query Language) language.
A similar way of querying the database from withing the repositories could be applied with Glagol DSL as well.

#### Can domain-specific languages be implemented by service-oriented architecture?, Shih-Hsi Liu, Adam Cardenas, Xang Xiong, Marjan Mernik, Barrett R. Bryant, Jeff Gray  

#### Domain-Specific Languages, Martin Fowler
In his typical style, Fowler organizes his book about DSLs on narrative and catalog parts. The catalog contains a list of patterns (as he refers to the listed concepts) which can be applied when managing DSLs. Generally speaking, Fowler's approach is usually more practical than theoretical, as he grasps the needs of the enterprise into his books. 
Therefore, this book will be useful in depicting the common and popular techniques when engineering the models which Glagol DSL will compile into. Furthermore, many of the concepts described in the book are distilled from other literature in a easy to understand way.  

#### Patterns of Enterprise Application Architecture, Martin Fowler
Despite the Model-Driven Design layer that is going to reflect Eric Evan's concepts, the framework part of the Glagol DSL should reflect standard controller patterns described by Fowler.
Furthermore, with the evolution of the project itself, some other patterns from P of EAA may find a place in the grammar defintion of Glagol DSL. The point of research is Query Builder patterns and how it can be implemented with a Familiar (SQL-like) DSL.

#### Functional Programming for Domain-Specific Languages, Jeremy Gibbons
Functions within declarations in Glagol DSL can have some simple higher-order behaviours. The lectures in this paper are focused on higher-order functions and algebratic data types which can be of a great help when compiling Glagol DSL higher order functions into a language that naturally does not support such (like PHP for example).

