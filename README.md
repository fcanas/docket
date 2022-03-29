# docket

Shows a timeline overlay to keep you on schedule.

```
docket [options] [json-filepath]
```

Invoke `docket` with single argument to a json file. Docket will start a new
process to show a timeline at the top of your screen and announce each segment
as you reach it.

A Docket is a JSON object with a single `segments` key for an array of segment
objects. A segment has a "name" string-value and a `duration` number value. The
`name` is shown in a notification bezel at the beginning of a segment. Duration
is expressed in seconds.

```json
  {
      "segments": [
          {
              "name": "Intro",
              "duration": 10
          },
          {
              "name": "Middle",
              "duration": 15
          },
          {
              "name": "Closing",
              "duration": 10
          }
      ]
  }
```

## Installing

`brew install fcanas/tap/docket`

Or `brew tap fcanas/tap` and then `brew install docket`.
