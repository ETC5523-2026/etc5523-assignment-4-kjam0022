# Launch the Trash Wheel explorer app

Opens a Shiny app for exploring which types of rubbish each of
Baltimore's Trash Wheels collects per dumpster load, and how this has
changed over the years. The app uses the packaged
[trash_collections](https://etc5523-2026.github.io/etc5523-assignment-4-kjam0022/reference/trash_collections.md)
data and
[`summarise_trash()`](https://etc5523-2026.github.io/etc5523-assignment-4-kjam0022/reference/summarise_trash.md).

## Usage

``` r
run_app()
```

## Value

No return value; called for its side effect of launching the app.

## Examples

``` r
if (interactive()) {
  run_app()
}
```
