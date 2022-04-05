@{%

const SPACE = /(?<SPACE>\s+|#[^\n]*)/; SPACE.skip = true;
const tokens = [
    SPACE,
    /(?<lp>\()/,
    /(?<rp>\))/,
    /(?<comma>,)/,
    /(?<semicolon>;)/,
    /(?<fun>fun)/,
    /(?<end>end)/,
    /(?<dolua>do)/,
    /(?<identifier>\b[a-z_][\w_]*\b)/,
];

const { nearleyLexer } = require("../src/main.js");

let lexer = nearleyLexer(tokens);

const getType = ([t]) => t.type;
%}

@lexer lexer

S -> FUN LP name COMMA name COMMA name RP 
      DO 
        DO  END SEMICOLON 
        DO END 
      END
     END
     EOF

name  ->      %identifier {% getType %}
COMMA ->       ","        {% getType %}
LP    ->       "("        {% getType %}
RP    ->       ")"        {% getType %}
END   ->      %end        {% getType %}
DO    ->      %dolua      {% getType %}
FUN   ->      %fun        {% getType %}
SEMICOLON ->  ";"         {% getType %}
EOF   ->      %EOF        {% getType %}
