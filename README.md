# My Emacs cheat sheet

## Modes

- Find out about the major mode and all enabled minor modes for the active
  buffer. This provides, amongst other information, all the key bindings for the
  modes.

```
C-h m
```

## Comment

- Comment a region in any major mode

```
M-;
```

## Insertion

- Insert same character n times

```
C-u 80 k
```

## Git

- Diff buffer with previous revision

```
M-x ediff-revision
```

## Search and Replace

- Search regular expression containing digits

```
C-Alt s
```

or on macOS

```
C-command s
```

- Delete search-matching lines
```
M-x delete-matching-lines
```

- Replace special character (e.g. ^M) with nothing

```
M-x replace-string C-q C-m RET RET
```

- Replace with Carriage Return

```
C-q C-j
```

- Navigate the search history for the previous or next expression

```
M-p
```

or

```
M-n
```

## Code Base Navigation

- Jump to Etags definition in a different frame

```
C-x 4 .
```

## Rectangles

- Kill rectangle selection 

```
C-x r k
```

- Replace rectangle selection

```
M-x string-insert-rectangle
```

## Themes

- Select a theme interactively

```
M-x customize-themes
```

- Display and modify a custom theme

```
custom-theme-visit-theme
```

- Set a cutom variable that is defined with the macro ***defcustom*** in a
  package for instance.

```
(custom-set-variables '(solarized-distinct-fringe-background t))
```
