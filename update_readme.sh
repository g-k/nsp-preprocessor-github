#!/usr/bin/env bash

## Helper script to run cargo show and update the README.md
# run from project root

cat > README.md <<EOF
# NSP URL preprocessor

An [NSP](https://github.com/nodesecurity/nsp) input processor for URLs


## use cases

For check for vulnerabilities in node.js dependencies in projects:

* without cloning large repos (or checking out specific branches or tags)

* with non-standard version file names

* with multiple package.json and other version files (e.g. if we have
  version files at \`https://github.com/me/myrepo/blob/master/frontend\`
  and \`https://github.com/me/myrepo/blob/master/old-frontend\` run this
  twice with both urls)


## example usage

To install:

\`\`\`console
npm install -g nsp nsp-preprocessor-url
$(npm install -g nsp nsp-preprocessor-url 2>&1)
\`\`\`

To fetch and check standard version file names (\`package.json\`,\`npm-shrinkwrap.json\` and \`package-lock.json\`):

\`\`\`console
nsp check --preprocessor url --url https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/2.1.1/ --verbose
$(nsp check --preprocessor url --url https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/2.1.1/ --verbose 2>&1)
\`\`\`

For non-standard version file names use args \`--pkg-url\`, \`--shrinkwrap-url\`, \`--pkg-lock-url\` respectively:

\`\`\`console
nsp check --preprocessor url --url https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/master/ --pkg-lock-url https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/master/weird-pkg-lock.json --verbose
$(nsp check --preprocessor url --url https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/master/ --pkg-lock-url https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/master/weird-pkg-lock.json --verbose 2>&1)
\`\`\`

Or a combination of them (package lock override 404):

\`\`\`console
nsp check --preprocessor url --url https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/master/ --pkg-lock-url https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/master/weird-pkg-lock.json --verbose
$(nsp check --preprocessor url --url https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/master/ --pkg-lock-url https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/master/weird-pkg-lock.json --verbose 2>&1)
\`\`\`

Overriding npm-shrinkwrap.json (200 via different tag):

\`\`\`console
nsp check --preprocessor url --url https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/master/ --shrinkwrap-url https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/2.1.3/npm-shrinkwrap.json --verbose 2>&1
$(nsp check --preprocessor url --url https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/master/ --shrinkwrap-url https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/2.1.3/npm-shrinkwrap.json --verbose 2>&1)
\`\`\`

Explicit package.json with no base/root \`--url\`:

\`\`\`console
nsp check --preprocessor url --pkg-url https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/2.1.4/package.json --verbose 2>&1
$(nsp check --preprocessor url --pkg-url https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/2.1.4/package.json --verbose 2>&1)
\`\`\`


### errors

Missing \`package.json\`:

\`\`\`console
nsp check --preprocessor url --shrinkwrap-url https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/master/npm-shrinkwrap.json --verbose
$(nsp check --preprocessor url --shrinkwrap-url https://raw.githubusercontent.com/mozilla-services/ip-reputation-js-client/master/npm-shrinkwrap.json --verbose 2>&1)
\`\`\`

Missing all args:

\`\`\`console
nsp check --preprocessor url --verbose
$(nsp check --preprocessor url --verbose 2>&1)
\`\`\`

Bad response from \`--url\` (406 since we can't fetch JSON directly from github):

\`\`\`console
nsp check --preprocessor url --url https://github.com/mozilla-services/ip-reputation-js-client/blob/master/ --verbose
$(nsp check --preprocessor url --url https://github.com/mozilla-services/ip-reputation-js-client/blob/master/ --verbose 2>&1)
\`\`\`
EOF

## if the readme changed in unexpected ways the command is broken or we're offline
git diff
