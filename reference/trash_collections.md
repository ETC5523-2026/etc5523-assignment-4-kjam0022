# Rubbish collected by Baltimore's Trash Wheels

Dumpster collections from four Trash Wheels operating in Baltimore's
waterways: Mister, Professor, Captain and Gwynnda. Each row describes
one rubbish type in one dumpster collection, so each collection appears
seven times. Item counts are estimates based on samples taken during
collection. A missing count means the rubbish type was not recorded for
that collection; it does not mean that no items were collected.

## Usage

``` r
trash_collections
```

## Format

A data frame with 6,951 rows and 11 variables:

- id:

  Short identifier for the Trash Wheel.

- name:

  Name of the Trash Wheel.

- dumpster:

  Dumpster collection number for that wheel.

- month:

  Month of collection.

- year:

  Year of collection.

- date:

  Date of collection.

- weight:

  Weight of collected rubbish, in US tons.

- volume:

  Volume of collected rubbish, in cubic yards.

- homes_powered:

  Source estimate of the number of homes that could be powered using
  energy generated from the collected rubbish.

- trash_type:

  Type of rubbish counted: Plastic Bottles, Polystyrene, Cigarette
  Butts, Glass Bottles, Plastic Bags, Wrappers or Sports Balls.

- count:

  Estimated number of items of that type in the collection; missing when
  the type was not recorded.

## Source

TidyTuesday, Trash Wheel Collection Data (2024-03-05),
<https://github.com/rfordatascience/tidytuesday/tree/main/data/2024/2024-03-05>;
original data from Baltimore's Healthy Harbor initiative,
<https://www.mrtrashwheel.com/>.

## Details

`weight`, `volume` and `homes_powered` describe the whole collection, so
they repeat on each of its seven rows. Do not add them up across rubbish
types. The wheels began operating in different years (Mister 2014,
Professor 2017, Captain 2018, Gwynnda 2021), and not every wheel records
every rubbish type.
