# Shellac

A cache server similar to Varnish all written in elixir.

## Idea
Not currently in a working state, but the idea would be that you would boot the Shellac server on port 80 for your website, and it would run similar to how varnish does

## Installing

* `clone` this repo
* `cd` into repo
* `mix deps.get`

## Running

* `iex -S mix`
* `Shellac.Proxy.start`
* `Cauldron.start(Shellac.Server, port: 3000)`

## Stats
`ab -c 20 -n 1000 'http://127.0.0.1:9292/'`

Specs:
* Sinatra 1.4.5
* Thin 1.6.3
* No cache

```text
Requests per second:    670.92 [#/sec] (mean)
Time per request:       29.810 [ms] (mean)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
