USING: accessors arrays assocs chess.common-resource
chess.engine.piece chess.util combinators fry kernel
math.ranges multiline sequences ;
IN: chess.engine.board

: <chess-position> ( x y piece -- position )
    [ 2dup 2array ] dip >>initial-xy ! x y populated-piece
    chess-position new
    { [ >>x ] [ >>y ] [ >>piece ] } spread ;


: new-board ( -- positions )
    8 [1,b] dup '[ _ [ swap f <chess-position> ] with map ] map concat ;


CONSTANT: initial-text-board "rsbqkbsrpppppppp--------------------------------PPPPPPPPRSBQKBSR"
! the board representation takes whites at the start and finishes with blacks.

: text>board ( text -- board )
    [ swap [ index>xy ] dip char>piece <chess-position> ] map-index ;

: initial-board ( -- board )
    initial-text-board text>board ;


    
ERROR: can-only-insert-a-chess-position ;

: set-board-cell ( chess-position board -- )
    over chess-position? [ can-only-insert-a-chess-position ] unless
    [ dup position>index ] dip set-at ;

:: delete-board-cell ( position board -- )
    f position position>index board set-at ;
    

: calcs>actuals ( seq -- seq' )
    [ dup chess-position? [ calc>actual ] unless ] map sift ;


!    TODO: verify behaviours using boards and unit tests.

!    future todo: draw a board. unicode would be nice, but usually no font for it.
!    for example CHAR: \u00265f     http://en.wikipedia.org/wiki/Chess_symbols_in_Unicode
!    this should be in the client code.
