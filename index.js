
const url = require('url');

const got = require('got');


// nsp-preprocessor-url to node.js JSON version filenames
const versionArgsToFilenames = new Map([
  ['pkg-url', 'package.json'],
  ['shrinkwrap-url', 'npm-shrinkwrap.json'],
  ['pkg-lock-url', 'package-lock.json']
]);

// nsp-preprocessor-url to nsp args key
const urlArgToArgsKey = new Map([
  ['package.json', 'pkg'],
  ['npm-shrinkwrap.json', 'shrinkwrap'],
  ['package-lock.json', 'packagelock']
]);


// converts args into a Map of version file name to URL to fetch it
// the map can be empty when no args are provided
let parseArgs = function (args) {
  // hash map of pkg key -> URL to fetch its JSON
  let urlArgs = new Map();

  // append trailing slash so url.resolve doesn't replace last path item
  if (args.url && !args.url.endsWith('/')) {
    args.url += '/';
  }

  versionArgsToFilenames.forEach((versionFilename, versionArg) => {
    if (args[versionArg]) {
      urlArgs.set(versionFilename, args[versionArg]);
    } else if (args.url) {
      urlArgs.set(versionFilename, url.resolve(args.url, versionFilename));
    } else if (args.verbose) {
      console.info(`No url provided for ${versionFilename}`);
    }
  });

  return urlArgs;
};

let fetchJsonFile = function (jsonFileUrl) {
  return got(jsonFileUrl, {
    json: true,
    throwHttpErrors: false
  });
};

let fetchJson = function (urlArgs) {
  // node 8 was missing support for MapIterator.map
  let fetchJsonPromises = [];
  for (let jsonFileUrl of urlArgs.values()) {
    fetchJsonPromises.push(fetchJsonFile(jsonFileUrl));
  };
  return Promise.all(fetchJsonPromises);
};

module.exports = {
  check: function (args) {
    // do something to read or generate package.json, npm-shrinkwrap.json and package-lock.json
    // the path to the project can be found as `args.path`
    // `pkg` must be the JSON parsed contents of package.json
    // `shrinkwrap` must be the JSON parsed contents of npm-shrinkwrap.json, if it exists. this may be left out.
    // `packagelock` must be the JSON parsed contents of package-lock.json, if it exists. this may also be left out.
    let urlArgs = parseArgs(args);

    if (urlArgs.size <= 0) {
      throw new Error('Missing url args.');
    } else if (!urlArgs.has('package.json')) {
      throw new Error('Missing required URL for package.json');
    }

    return fetchJson(urlArgs).then(values => {
      let index = 0;
      let newArgs = {};
      for (let urlArg of urlArgs.keys()) {
        let response = values[index];

        if (200 <= response.statusCode && response.statusCode < 300) {
          newArgs[urlArgToArgsKey.get(urlArg)] = response.body;
          if (args.verbose) {
            console.info(`Found ${urlArg}: ${response.statusCode} ${response.url}`);
          }
        } else if (args.verbose) {
          console.info(`Error fetching url ${urlArg}: ${response.statusCode} ${response.url}`);
        }
        index += 1;
      }

      if (args.verbose) {
        console.debug('updating nsp args with:', newArgs);
      }

      // throw an error so we don't use package.json from args.path
      if (!newArgs.pkg) {
        throw new Error('Failed to fetch JSON for package.json');
      }
      return Object.assign(args, newArgs);
    });
  }
};
