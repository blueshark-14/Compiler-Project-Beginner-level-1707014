# Mini Compiler with Flex and Bison

A small language processor written in C with **Flex** (lexical analysis) and **Bison** (LALR(1) parsing). It reads a program written in a custom, C-like language with Bangla-inspired keywords, checks its syntax against a context-free grammar, and evaluates it using syntax-directed translation.

> **Course project:** CSE3212 Compiler Design Laboratory, Department of CSE, Khulna University of Engineering & Technology (KUET), June 2021.
> **Author:** Rakib Hasan (Roll 1707014)
> A full write-up (tokens, grammar, discussion) is in [`Report_on_project_1707014.pdf`](Report_on_project_1707014.pdf).

---

## Features

- **Lexical analysis** (`cp.l`): tokenizes keywords, operators, punctuation, integer literals, and variables, and reports unknown characters.
- **Parsing** (`cp.y`): a bottom-up (LALR(1)) parser built with Bison, with operator precedence and associativity declared for comparison, additive, and multiplicative operators.
- **Declarations:** `int`, `float`, `char`, with several variables per declaration and a duplicate-declaration warning.
- **Expressions:** `+ - * / %`, `<`, `>`, and parentheses, with **division-by-zero and mod-by-zero** detection.
- **Assignment** and **print** statements.
- **Control-flow syntax:** `if` / `else`, a counting `loop`, and `switch` / `case` / `default` / `break`.
- **Syntax-directed evaluation:** semantic actions in the grammar evaluate expressions as the input is parsed.
- Prints `Successful compilation.` when the whole program matches the grammar.

## Language Reference

Keywords and operators are spelled so that the lexer can match them as whole tokens.

| Construct | Syntax | Meaning |
|---|---|---|
| Program | `MAIN Sf Ef Ss ... Es` | Entry point; `Sf`/`Ef` are `(` `)`, `Ss`/`Es` are `{` `}` |
| Declaration | `int a COMA b SEMI` | Declare variables (`COMA` = `,`, `SEMI` = `;`) |
| Assignment | `a (=) 10 SEMI` | Assign a value |
| Add / Subtract | `(+)`  `(-)` | `Jug`, `Biyog` |
| Multiply / Divide / Mod | `(*)`  `(/)`  `(%)` | `Gun`, `Vaag`, `Vgses` |
| Compare | `CHOTO`  `BORO` | Less than / greater than |
| If / Else | `JODI Sf cond Ef Ss ... Es NAHOLE Ss ... Es` | Conditional |
| Loop | `LOOP Sf 1 CHOTO 3 Ef Ss ... Es` | Counting loop from the first number up to (not including) the second |
| Print | `PF Sf expr Ef SEMI` | Print an expression |
| Switch | `SWITCH Sf x Ef Ss CASE n (:) ... BREAK SEMI ... DEFAULT (:) ... Es` | Multi-way branch (syntax-checked) |

Variables are single lowercase letters (`a` to `z`).

## Example

**`input.txt`**

```
MAIN Sf Ef
Ss
int a COMA b COMA c SEMI
int d SEMI

a (=) 10 SEMI
b (=) 4 SEMI
c (=) b (+) a SEMI
d (=) 100 SEMI

JODI Sf 5 (%) 2 Ef
Ss
5 (+) 4 SEMI
Es

JODI Sf 1 BORO 2 Ef
Ss
3 (+) 2 SEMI
Es
NAHOLE
Ss
2 (+) 1 SEMI
Es

LOOP Sf 1 CHOTO 3 Ef
Ss
d (=) d (+) 100 SEMI
Es
Es
```

**Output** (blank lines omitted)

```
valid declaration.
valid declaration.
Value of the variable: 10
Value of the variable: 4
Plus er kaj : 14
Value of the variable: 14
Value of the variable: 100
Plus er kaj : 9
value of expression in IF: 9
Plus er kaj : 5
Plus er kaj : 3
value of expression in ELSE : 3
Plus er kaj : 200
Value of the variable: 200
value of the for loop: 1 expression value: 200
value of the for loop: 2 expression value: 200
Successful compilation.
```

(`Plus er kaj` is the program's trace message for an addition.)

## Build and Run

You need a C compiler plus Flex and Bison.

**Linux / macOS**

```bash
bison -d cp.y
flex cp.l
gcc lex.yy.c cp.tab.c -o ex -lm
./ex
```

**Windows** (MinGW or WSL with Flex/Bison, or `win_flex` / `win_bison`)

```bat
bison -d cp.y
flex cp.l
gcc lex.yy.c cp.tab.c -o ex
ex
```

The program reads its source from **`input.txt`** in the current directory. A prebuilt Windows binary (`ex.exe`) and the generated files (`lex.yy.c`, `cp.tab.c`, `cp.tab.h`) are included, so you can also compile with `gcc` directly without Flex and Bison installed.

> **Line endings:** `input.txt` must use LF line endings on Linux/macOS. If you see repeated `Unknown Character.` messages, convert the file with `tr -d '\r' < input.txt > tmp && mv tmp input.txt`.

## How It Works

```
input.txt ──► Lexer (Flex, cp.l) ──► tokens ──► Parser (Bison, cp.y) ──► actions / output
```

1. **Lexer:** regular expressions in `cp.l` turn the character stream into tokens, and numbers and variable indices are passed to the parser through `yylval`.
2. **Parser:** the grammar in `cp.y` accepts the language described above. Precedence rules (`%left`) resolve ambiguity in expressions.
3. **Semantic actions:** each production carries C code that computes values, updates the variable table (`sym[26]`), and tracks declarations (`store[26]`).

## Project Structure

| File | Purpose |
|---|---|
| `cp.l` | Flex lexer specification |
| `cp.y` | Bison grammar and semantic actions |
| `lex.yy.c`, `cp.tab.c`, `cp.tab.h` | Generated scanner and parser |
| `input.txt` | Sample input program |
| `ex.exe` | Prebuilt Windows executable |
| `Report_on_project_1707014.pdf` | Project report |

## Limitations and Future Work

This is a beginner-level, single-pass design. The main limitations are known and are good directions to extend:

- **No syntax tree or intermediate code.** Expressions are evaluated while parsing, so `if`, `loop`, and `switch` bodies are evaluated when they are parsed rather than executed with true control flow. `switch` is syntax-checked only.
- **Single-letter variables** (`a`–`z`) and **integer values only**; `float` and `char` are accepted in declarations but stored as integers.
- **Limited semantic checks:** duplicate declarations are reported, but use-before-declaration and type checking are not.
- **Fixed input file** (`input.txt`) and error messages without line numbers.

Possible next steps: build an AST, add a typed symbol table and semantic analysis, generate three-address code, execute control flow properly, support multi-character identifiers, and add error recovery with line numbers.

## Author

**Rakib Hasan**, B.Sc. in Computer Science and Engineering, KUET.
