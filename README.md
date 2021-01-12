# dart_todo

A todo CLI tool, written in dart.

## Getting started

```bash
# add todo
todo -a Pet the cat
todo --add Pet the cat
todo a Pet the cat
todo add Pet the cat
todo -f path/to/todo.md a Pet the cat

# use gui to manage todos
todo
todo -f path/to/todo.md
```

## Example file

The default file is `.todo` in the current directory, but one can be specified with the `-f` argument.

It is a "markdown"-like file, with only an unordered list of checkboxes, so it can be directly parsed by other software,
if needed.

```plaintext
- [x] done
- [ ] not done
```

## Command line options

| Option          | Description                                                                       | Default Value | example                    |
| :-------------- | :-------------------------------------------------------------------------------- | :-----------: | :------------------------- |
| `--add`, `-a`   | The dashes are optional. Adds a todo entry to the file.                           |     None      | `todo a My todo title`     |
| `--file`, `-f`  | Specify path to use. May be relative path or absolute path.                       |    `.todo`    | `todo -f my/todo.md`       |
| `--quiet`, `-q` | Will not echo results in operations, such as confirmation for adding to do entry. |     false     | `todo -q -a My todo title` |
