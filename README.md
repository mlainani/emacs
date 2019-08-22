# My Emacs cheat sheet

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
