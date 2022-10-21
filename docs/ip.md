---
permalink: /ip/
---

# package ip

```jsonnet
local ip = import "github.com/jsonnet-libs/xtd/ip.libsonnet"
```

`ip` implements helper functions for ip addresses and networks calculation

## Index

* [`fn addIPv6(ip, increment=true, init=[], r=0)`](#fn-addipv6)
* [`fn block(ip, prefix=true)`](#fn-block)
* [`fn identify(ip)`](#fn-identify)
* [`fn isIPv(ip)`](#fn-isipv)
* [`fn isIn(ip, block)`](#fn-isin)
* [`fn parseString(ip)`](#fn-parsestring)
* [`fn toString(ip, compressIPv6=true)`](#fn-tostring)

## Fields

### fn addIPv6

```ts
addIPv6(ip, increment=true, init=[], r=0)
```

As IPv6 is stored into an array, this function can be used to perform rudimentary `add` operation recursivly.

### fn block

```ts
block(ip, prefix=true)
```

return a structure with several information related to an IP block.

### fn identify

```ts
identify(ip)
```

`identify` return an array of matching IANA reserved block names.

### fn isIPv

```ts
isIPv(ip)
```

return `4` if `ip` is IPv4, and `6` if IPv6.

### fn isIn

```ts
isIn(ip, block)
```

return `true` if `ip` is contained in `block` (e.g. `10.8.5.28` is contained in `block("10.8.4.0",23)`).

### fn parseString

```ts
parseString(ip)
```

return a numeric version of IPv4, and an array representation of IPv6.

### fn toString

```ts
toString(ip, compressIPv6=true)
```

return a string version of IP. When IPv6, you can choose if you need a compressed or uncompressed representation.