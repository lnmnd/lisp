# Lisp interpreter

## Running

The REPL reads from stdin and writes to stdout.

```sh
csi -s lisp.scm
```

Running example code:

```sh
csi -s lisp.scm < example.scm
```

Loading stdlib first:

```sh
cat stdlib.scm myscript.scm | csi -s lisp.scm
```
