WIP effort getting .NET to run in sandstorm, using docker-spk.

# Building

Due to the need to work around `/proc` being unavailable, and the fact
that docker-spk doesn't currently support `searchPath`, getting a
working spk is slightly fiddly:

```
docker-spk build
spk unpack 'Example App-0.0.0.spk' oldspk
spk dev # Or spk pack
```

Note that this doesn't quite work yet; see:

<https://github.com/dotnet/runtime/issues/2534>
