# Summarise rubbish collected by the Trash Wheels

Summarises the estimated item counts in
[trash_collections](https://etc5523-2026.github.io/etc5523-assignment-4-kjam0022/reference/trash_collections.md)
for chosen wheels, rubbish types and years. When a rubbish type was not
recorded for a collection, that collection is left out of the type's
summary rather than being counted as zero.

## Usage

``` r
summarise_trash(data, wheels = NULL, trash_types = NULL, years = NULL)
```

## Arguments

- data:

  A data frame in the same format as
  [trash_collections](https://etc5523-2026.github.io/etc5523-assignment-4-kjam0022/reference/trash_collections.md),
  with columns `name`, `year`, `dumpster`, `trash_type` and `count`.

- wheels:

  Character vector of Trash Wheel names to include. The default `NULL`
  keeps all wheels.

- trash_types:

  Character vector of rubbish types to include. The default `NULL` keeps
  all types.

- years:

  Numeric vector of length two giving the first and last year to
  include. The default `NULL` keeps all years.

## Value

A data frame with one row per wheel, year and rubbish type:

- `name`: Trash Wheel name

- `year`: year of collection

- `trash_type`: rubbish type

- `collections`: number of dumpster collections that recorded the type

- `total_items`: estimated total items collected

- `items_per_collection`: mean estimated items per collection

The data frame has zero rows when no recorded counts match the
selection.

## Examples

``` r
summarise_trash(
  trash_collections,
  wheels = "Mister Trash Wheel",
  years = c(2020, 2023)
)
#> # A tibble: 28 × 6
#>    name             year trash_type collections total_items items_per_collection
#>    <chr>           <dbl> <chr>            <int>       <dbl>                <dbl>
#>  1 Mister Trash W…  2020 Cigarette…          72      335900               4665. 
#>  2 Mister Trash W…  2020 Glass Bot…          72         961                 13.3
#>  3 Mister Trash W…  2020 Plastic B…          72       33434                464. 
#>  4 Mister Trash W…  2020 Plastic B…          72      138560               1924. 
#>  5 Mister Trash W…  2020 Polystyre…          72       88810               1233. 
#>  6 Mister Trash W…  2020 Sports Ba…          72         856                 11.9
#>  7 Mister Trash W…  2020 Wrappers            72       53240                739. 
#>  8 Mister Trash W…  2021 Cigarette…          58      213100               3674. 
#>  9 Mister Trash W…  2021 Glass Bot…          58        1015                 17.5
#> 10 Mister Trash W…  2021 Plastic B…          58       21625                373. 
#> # ℹ 18 more rows

# Cigarette butts per collection for every wheel in 2022
summarise_trash(
  trash_collections,
  trash_types = "Cigarette Butts",
  years = c(2022, 2022)
)
#> # A tibble: 4 × 6
#>   name              year trash_type collections total_items items_per_collection
#>   <chr>            <dbl> <chr>            <int>       <dbl>                <dbl>
#> 1 Captain Trash W…  2022 Cigarette…           3        9900                3300 
#> 2 Gwynnda Trash W…  2022 Cigarette…          85      205410                2417.
#> 3 Mister Trash Wh…  2022 Cigarette…          57      205000                3596.
#> 4 Professor Trash…  2022 Cigarette…          16       87200                5450 
```
