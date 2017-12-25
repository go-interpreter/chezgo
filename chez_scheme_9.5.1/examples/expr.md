# The grammar

## The section

#### *identifier* {#identifier}
  
aliases: *x*, *y*

An identifier is ...

#### *integer* {#integer}
  
aliases: *i*

An integer literal is ...

#### *expr* {#expr}
  
aliases: *e*

syntax:
  : _right-associative, highest precedence:_
    : expr = expr
  : _left-associative:_
    : expr + expr
    : expr - expr
  : _left-associative, lowest precedence:_
    : expr * expr
    : expr / expr
  : _leaves:_
    : &nbsp;&nbsp;[*t*](#term)

#### *term* {#term}
  
aliases: *t*

syntax:
  : &nbsp;&nbsp;sepplus&nbsp;&nbsp;(&nbsp;&nbsp;[*e*](#expr)&nbsp;&nbsp;;&nbsp;&nbsp;`...`&nbsp;&nbsp;)
  : &nbsp;&nbsp;sepstar&nbsp;&nbsp;(&nbsp;&nbsp;OPT([*e*](#expr)&nbsp;&nbsp;,&nbsp;&nbsp;`...`)&nbsp;&nbsp;)
  : &nbsp;&nbsp;opt&nbsp;&nbsp;(&nbsp;&nbsp;[*e*](#expr)~opt~&nbsp;&nbsp;)
  : &nbsp;&nbsp;kplus&nbsp;&nbsp;(&nbsp;&nbsp;[*e*](#expr)&nbsp;&nbsp;`...`&nbsp;&nbsp;)
  : &nbsp;&nbsp;kstar&nbsp;&nbsp;(&nbsp;&nbsp;OPT([*e*](#expr))&nbsp;&nbsp;)
  : &nbsp;&nbsp;[*x*](#identifier)
  : &nbsp;&nbsp;[*i*](#integer)
  : &nbsp;&nbsp;(&nbsp;&nbsp;[*e*](#expr)&nbsp;&nbsp;)
