# Lisp interpreter

## Running

The REPL reads from stdin and writes to stdout.

```sh
csi -s lisp.scm
```

Running example code:

```sh
csi -s lisp.scm < example.l
```

Loading stdlib first:

```sh
cat stdlib.l myscript.l | csi -s lisp.scm
```
