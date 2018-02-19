# NSP URL preprocessor

An [NSP](https://github.com/nodesecurity/nsp) input processor for URLs


## use cases

For check for vulnerabilities in node.js dependencies in projects:

* without cloning large repos (or checking out specific branches or tags)

* with non-standard version file names

* with multiple package.json and other version files (e.g. if we have
  version files at `https://github.com/me/myrepo/blob/master/frontend`
  and `https://github.com/me/myrepo/blob/master/old-frontend` run this
  twice with both urls)


## example usage

To install:

```console
npm install -g nsp nsp-preprocessor-url
/usr/local/bin/nsp -> /usr/local/lib/node_modules/nsp/bin/nsp
+ nsp-preprocessor-url@0.2.0
+ nsp@3.2.1
updated 2 packages in 4.094s
```

To fetch and check standard version file names (`package.json`,`npm-shrinkwrap.json` and `package-lock.json`):

```console
nsp check --preprocessor url --url https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/2.1.1/ --verbose
Found package.json: 200 https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/2.1.1/package.json
Error fetching url npm-shrinkwrap.json: 404 https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/2.1.1/npm-shrinkwrap.json
Error fetching url package-lock.json: 404 https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/2.1.1/package-lock.json
(+) 1 vulnerability found
┌────────────┬────────────────────────────────────────────────────────────────────┐
│            │ Prototype pollution attack                                         │
├────────────┼────────────────────────────────────────────────────────────────────┤
│ Name       │ hoek                                                               │
├────────────┼────────────────────────────────────────────────────────────────────┤
│ CVSS       │ 4 (Medium)                                                         │
├────────────┼────────────────────────────────────────────────────────────────────┤
│ Installed  │ 2.16.3                                                             │
├────────────┼────────────────────────────────────────────────────────────────────┤
│ Vulnerable │ <= 4.2.0 || >= 5.0.0 < 5.0.3                                       │
├────────────┼────────────────────────────────────────────────────────────────────┤
│ Patched    │ > 4.2.0 < 5.0.0 || >= 5.0.3                                        │
├────────────┼────────────────────────────────────────────────────────────────────┤
│ Path       │ ip-reputation-js-client@2.1.1 > request@2.75.0 > hawk@3.1.3 >      │
│            │ hoek@2.16.3                                                        │
├────────────┼────────────────────────────────────────────────────────────────────┤
│ More Info  │ https://nodesecurity.io/advisories/566                             │
└────────────┴────────────────────────────────────────────────────────────────────┘
```

For non-standard version file names use args `--pkg-url`, `--shrinkwrap-url`, `--pkg-lock-url` respectively:

```console
nsp check --preprocessor url --url https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/master/ --pkg-lock-url https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/master/weird-pkg-lock.json --verbose
Found package.json: 200 https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/master/package.json
Found npm-shrinkwrap.json: 200 https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/master/npm-shrinkwrap.json
Error fetching url package-lock.json: 404 https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/master/weird-pkg-lock.json
(+) No known vulnerabilities found
```

Or a combination of them (package lock override 404):

```console
nsp check --preprocessor url --url https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/master/ --pkg-lock-url https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/master/weird-pkg-lock.json --verbose
Found package.json: 200 https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/master/package.json
Found npm-shrinkwrap.json: 200 https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/master/npm-shrinkwrap.json
Error fetching url package-lock.json: 404 https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/master/weird-pkg-lock.json
(+) No known vulnerabilities found
```

Overriding npm-shrinkwrap.json (200 via different tag):

```console
nsp check --preprocessor url --url https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/master/ --shrinkwrap-url https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/2.1.3/npm-shrinkwrap.json --verbose 2>&1
Found package.json: 200 https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/master/package.json
Found npm-shrinkwrap.json: 200 https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/2.1.3/npm-shrinkwrap.json
Error fetching url package-lock.json: 404 https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/master/package-lock.json
(+) 2 vulnerabilities found
┌────────────┬────────────────────────────────────────────────────────────────────┐
│            │ Prototype pollution attack                                         │
├────────────┼────────────────────────────────────────────────────────────────────┤
│ Name       │ hoek                                                               │
├────────────┼────────────────────────────────────────────────────────────────────┤
│ CVSS       │ 4 (Medium)                                                         │
├────────────┼────────────────────────────────────────────────────────────────────┤
│ Installed  │ 4.2.0                                                              │
├────────────┼────────────────────────────────────────────────────────────────────┤
│ Vulnerable │ <= 4.2.0 || >= 5.0.0 < 5.0.3                                       │
├────────────┼────────────────────────────────────────────────────────────────────┤
│ Patched    │ > 4.2.0 < 5.0.0 || >= 5.0.3                                        │
├────────────┼────────────────────────────────────────────────────────────────────┤
│ Path       │ ip-reputation-js-client@2.1.4 > joi@12.0.0 > hoek@4.2.0            │
├────────────┼────────────────────────────────────────────────────────────────────┤
│ More Info  │ https://nodesecurity.io/advisories/566                             │
└────────────┴────────────────────────────────────────────────────────────────────┘

┌────────────┬────────────────────────────────────────────────────────────────────┐
│            │ Prototype pollution attack                                         │
├────────────┼────────────────────────────────────────────────────────────────────┤
│ Name       │ hoek                                                               │
├────────────┼────────────────────────────────────────────────────────────────────┤
│ CVSS       │ 4 (Medium)                                                         │
├────────────┼────────────────────────────────────────────────────────────────────┤
│ Installed  │ 4.2.0                                                              │
├────────────┼────────────────────────────────────────────────────────────────────┤
│ Vulnerable │ <= 4.2.0 || >= 5.0.0 < 5.0.3                                       │
├────────────┼────────────────────────────────────────────────────────────────────┤
│ Patched    │ > 4.2.0 < 5.0.0 || >= 5.0.3                                        │
├────────────┼────────────────────────────────────────────────────────────────────┤
│ Path       │ ip-reputation-js-client@2.1.4 > request@2.83.0 > hawk@6.0.2 >      │
│            │ hoek@4.2.0                                                         │
├────────────┼────────────────────────────────────────────────────────────────────┤
│ More Info  │ https://nodesecurity.io/advisories/566                             │
└────────────┴────────────────────────────────────────────────────────────────────┘
```

Explicit package.json with no base/root `--url`:

```console
nsp check --preprocessor url --pkg-url https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/2.1.4/package.json --verbose 2>&1
No url provided for npm-shrinkwrap.json
No url provided for package-lock.json
Found package.json: 200 https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/2.1.4/package.json
(+) No known vulnerabilities found
```


### errors

Missing `package.json`:

```console
nsp check --preprocessor url --shrinkwrap-url https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/master/npm-shrinkwrap.json --verbose
No url provided for package.json
No url provided for package-lock.json
(+) Missing required URL for package.json (use --url or --pkg-url if the filename isn't package.json)
```

Missing all args:

```console
nsp check --preprocessor url --verbose
No url provided for package.json
No url provided for npm-shrinkwrap.json
No url provided for package-lock.json
(+) Missing url args.
```

Bad response from `--url` (406 since we can't fetch JSON directly from github):

```console
nsp check --preprocessor url --url https://github.com/mozilla-services/ip-reputation-js-client/blob/master/ --verbose
Error fetching url package.json: 406 https://github.com/mozilla-services/ip-reputation-js-client/blob/master/package.json
Error fetching url npm-shrinkwrap.json: 406 https://github.com/mozilla-services/ip-reputation-js-client/blob/master/npm-shrinkwrap.json
Error fetching url package-lock.json: 404 https://github.com/mozilla-services/ip-reputation-js-client/blob/master/package-lock.json
(+) Failed to fetch JSON for package.json
```
