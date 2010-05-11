USING: accessors arrays chess.common-resource
chess.engine.board chess.engine.piece chess.engine.player
chess.engine.rules chess.queries chess.util combinators fry
kernel locals math namespaces random sequences sets ;
IN: chess.engine

! the chess engine. validates moves.




: set-colors ( player1 player2 -- player1' player2' )
    choose-colors swapd [ >>color ] 2bi@ ;

: set-numbers ( player1 player2 -- player1' player2' )
    [ 1 >># ] [ 2 >># ] bi* ;

: <game> ( player1 player2 -- game )
    set-colors
    set-numbers
    game new
    swap >>player2
    swap >>player1
    initial-board >>board
    f >>over? ;

: new-local-game ( -- game )
    +human+ +human+ [ <player> ] bi@ <game> ;


GENERIC: request-move ( -- move )
! GENERIC: opposite ( object -- other-object )


: validate-move ( game move -- ok/err )  ! TODO
    2drop "ok" ;

: xy= ( pos1 pos2 -- ? )
    [ [ x>> ] [ y>> ] bi 2array ] bi@ = ;
    ! { x1 y1 } { x2 y2 } =

: valid-move? ( game move -- ok/err t/f ) ! TODO
    validate-move
    dup "ok" =    t f ? ;

: valid-moves ( player -- seq )
    all-player-pieces [ piece's-valid-moves ] map concat  ;



: threatened? ( position -- ? )
    dup piece-color opposite-color positions [ swap reachable? ] with any? ;


: stale-mate? ( player -- ? )
    [ valid-moves empty? ] [ checked?>> not ] bi and ;

: check-mate? ( player -- ? )
    [ valid-moves empty? ] [ checked?>> ] bi and ;


: change-state-game-end ( game -- game' )
    dup [ stale-mate? ] [ check-mate? ] bi or
    [ t >>over? ] when ;



: maybe-set-checked ( player -- )
    dup get-king threatened? >>checked? drop ;

: at-final-position? ( position -- ? )
    [ piece-color final-row ] [ y>> ] bi = ;


: update-cell ( board position -- )
    [ position>index ] keep swapd '[ drop _ ] change-at ;

: <promoted-piece> ( color number-of-moves initial-location class -- piece )
    new
    swap >>initial-xy
    swap >>number-of-moves
    swap >>color ;

GENERIC: choose-promotion ( player-type -- char )



: promote-pawn ( position -- position' )
    [
        {   [ color>> ]               ! extract all piece data
            [ number-of-moves>> ]
            [ initial-xy>> ]
            ! ...more?
        } cleave 

        player-after-move type>> choose-promotion (char>piece) <promoted-piece>
    ] change-piece ;

:: do-promotion ( position -- )
    position promote-pawn :> position'
    current-game [ [ position' update-cell ] change-board ] change ;

: maybe-set-promotion ( player -- )
    dup get-pawns [ at-final-position? ] filter [ do-promotion ] map ;

: threatened? ( position -- ? )
    dup color>> opposite-color positions swap '[ _ reachable? ] any? ;



: checked? ( player -- ? )
    get-king threatened? ;

    
: update-player-object ( game player -- )
    #>> { { 1 [ >>player1 ] } { 2 [ >>player2 ] } } case ;

: change-state-player-check ( game -- )
    dup 
    who-played-last>> opposite-player 
    dup maybe-set-checked 
    update-player-object ;

: change-state-promotions ( game -- )
    who-played-last>> maybe-set-promotion ;

    
: change-state-enpassant ( game -- )
    enpassant-location >>last-enpassant drop ; ! in both cases (f or a valid position), store it in. 
    
:: change-state-took-enpassant ( game -- )
    ! if last move took the enpassant from the previous move, remove the related pawn.
    game moves>> :> moves 
    moves last to>> :> last-move-target
    
    moves length 2 >= 
    [
        last-move-target game last-enpassant>> = 
        [ last-move-target 1 down game board>> delete-board-cell ] when
    ] when ;

: process-new-condition ( game -- game' )  ! change state after adding move to board.
    dup {
        [ change-state-player-check  ]
        [ change-state-game-end ]
        [ change-state-promotions ]
        [ change-state-enpassant ]
        [ change-state-took-enpassant ]
    } cleave ;




<PRIVATE
: (cells-after-movement) ( move -- pos1 pos2 )
    [ from>>                             ! position1
        dup [ piece>> ] [ f >>piece ] bi ! piece (and set f in piece slot.)
    ] [ to>>                             ! position2
        swap >>piece ] bi ;

: do-movement ( game move -- )
    swap [ (cells-after-movement) ] dip board>> '[ _ set-board-cell ] bi ;


: parse-move ( pgn-notation -- move-object )
    ! TODO 
    ... ;
    
ERROR: invalid-move move ;
: add-move ( game move -- game' )
    dup string? [ parse-move ] when
    2dup valid-move? [ invalid-move ] unless
    dupd do-movement ;
PRIVATE>


: <middle-game> ( moves-list -- game' )     ! TODO move will need to be enhanced to include information as in pgn files, for example promotion.
    new-local-game swap [ add-move ] with each ;
