# Lexer Generator Lab

<https://ull-esit-gradoii-pl.github.io/practicas/lexer-generator/>

```js
const buildLexer = (regexps) => {
  let validTokens = new Map();
  regexps.push(/(?<ERROR>.+)/);
  const tokenNames = [];
  regexps.forEach((regexp) => {
    let name = checkRegExpIsNamed(regexp);
    if (!name) {
      throw new Error('Expected named regexp, only one name per regexp');
    }
    tokenNames.push(name);
    validTokens.set(name, regexp);
  });
  const regexp = new RegExp(regexps.map(regexp => regexp.source).join('|'), 'yu');
  let lexer = (string, line=1) => {
    const result = [];
    let match;
    const getToken = (match) => tokenNames.find(token => typeof match[token] !== 'undefined');
    let previousLinePosition = 0;
    while (match = regexp.exec(string)) {
      if (match[0].includes('\n')) {
        line++;
        previousLinePosition = match.index + match[0].length;
      }
      let token = getToken(match.groups) || 'ERROR';
      if (validTokens.get(token).skip) continue;
      let value;
      if (validTokens.get(token).value) value = validTokens.get(token).value(match[0]);
      else value = match[0];
      result.push({
        type: token,
        value: value,
        line: line,
        col: match.index + 1 - previousLinePosition,
        length: match[0].length,
      });
    }
    return result;
  };
  return {validTokens, lexer};
};
```

```js
let validTokens = new Map();
regexps.push(/(?<ERROR>.+)/);
const tokenNames = [];
regexps.forEach((regexp) => {
  let name = checkRegExpIsNamed(regexp);
  if (!name) {
    throw new Error('Expected named regexp, only one name per regexp');
  }
  tokenNames.push(name);
  validTokens.set(name, regexp);
});
```
se validan los tokens
