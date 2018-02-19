# NSP URL preprocessor

An [NSP](https://github.com/nodesecurity/nsp) input processor for URLs


## use cases

For check for vulnerabilities in node.js dependencies in projects:

* without cloning large repos

* with non-standard verion file names

* with multiple package.json and other version files (e.g. if we have
  version files at `https://github.com/me/myrepo/blob/master/frontend`
  and `https://github.com/me/myrepo/blob/master/old-frontend` run this
  twice with both urls)


## example usage

To install:

```console
npm install -g nsp nsp-preprocessor-url
```

To fetch and check standard version file names (`package.json`,`npm-shrinkwrap.json` and `package-lock.json`):

```console
nsp check --preprocessor url --url https://github.com/mozilla-services/ip-reputation-js-client/blob/master/
```

For non-standard version file names use args `--pkg-url`, `--shrinkwrap-url`, `--pkg-lock-url` respectively:

```console
nsp check --preprocessor url --pkg-url https://github.com/mozilla-services/ip-reputation-js-client/blob/master/weird-pkg.json
```
