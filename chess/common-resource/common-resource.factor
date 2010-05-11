USING: accessors arrays constructors math namespaces ;
IN: chess.common-resource




TUPLE: position
    { x integer } { y integer } ;

TUPLE: move
    { from position } { to position } ;

SINGLETONS: +white+ +black+ ;

TUPLE: piece
    color
    { number-of-moves initial: 0 }
    { initial-xy array } ; ! this can also serve as an id for the piece.


TUPLE: pawn < piece ;
TUPLE: bishop < piece ;
TUPLE: king < piece ;
TUPLE: queen < piece ;
TUPLE: rook < piece ;
TUPLE: knight < piece ;



TUPLE: chess-position < position
    { piece piece initial: f } ;

CONSTRUCTOR: chess-position (  x y -- chess-pos ) ;


TUPLE: board
    { chess-positions array } ;

TUPLE: player
    # name type color checked? ;

TUPLE: game
    player1 player2 who-played-last board over? moves winner type ;

SYMBOL: current-game
SINGLETONS: +remote+ +local+ ;

: GAME ( -- current-game ) 
    current-game get ;
