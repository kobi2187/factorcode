IN: chess.engine.piece.targets
USING: chess.engine.rules chess.engine.movement chess.engine.piece

kernel arrays  ;

 

: pawn-potential-eat ( position -- seq )
    1 up 1 horizontal-sides 2array ;

DEFER: enpassant-location

: enpassant-location? ( position -- ? )
    dup [ enpassant-location = ] when ;
 
: pawn-valid-targets ( orig-position -- seq )
    [ 
        pawn-potential-eat
        [ [ enpassant-location? ] [ opposite-colored-piece? ] bi or ] filter
    ] 
    [
        [ [ 1 up ] until-blocked- ] keep 
        piece>> first-move? 2 1 ? short head
    ] bi append calcs>actuals ;

: queen-valid-targets ( position -- seq )
  [
    {
        [ [ 1 up ] until-blocked ]
        [ [ 1 down ] until-blocked ]
        [ [ 1 right ] until-blocked ]
        [ [ 1 left ] until-blocked ]
        [ [ 1 up 1 right ] until-blocked ]
        [ [ 1 down 1 left ] until-blocked ]
        [ [ 1 down 1 right ] until-blocked ]
        [ [ 1 up 1 left ] until-blocked ]
    } cleave
    ] output>array within-board-bounds sift-same-color  ;

: bishop-valid-targets ( position -- seq )
 [
    {
        [ [ 1 up 1 right ] until-blocked ]
        [ [ 1 down 1 left ] until-blocked ]
        [ [ 1 down 1 right ] until-blocked ]
        [ [ 1 up 1 left ] until-blocked ]
    } cleave
    ] output>array within-board-bounds sift-same-color ;

: rook-valid-targets ( position -- seq )
    [
    {
        [ [ 1 up ] until-blocked ]
        [ [ 1 down ] until-blocked ]
        [ [ 1 right ] until-blocked ]
        [ [ 1 left ] until-blocked ]
    } cleave
    ] output>array within-board-bounds sift-same-color ;

: maybe-castling ( -- target-positions/empty )
    player-before-move
    [ dup right-castling-allowed? [ right-castling-move ] [ drop f ] if  ]
    [ dup left-castling-allowed?  [ left-castling-move  ] [ drop f ] if  ] bi 2array sift ;

    
: king-valid-targets ( position -- seq )
    [ 1 all-sides within-board-bounds sift-same-color ] keep
    maybe-castling append ;

: knight-valid-targets ( position -- seq )
    [
        [ 2 vertical-sides      [ 1 horizontal-sides ] bi@  ]
        [ 2 horizontal-sides    [ 1 vertical-sides ]   bi@  ] bi
    ] output>array within-board-bounds ;

: valid-targets ( position -- seq )
    dup piece>> { 
        { [ dup queen?  ] [ drop queen-valid-targets ]    }
        { [ dup pawn?   ] [ drop pawn-valid-targets  ]    }
        { [ dup rook?   ] [ drop rook-valid-targets ]     } 
        { [ dup bishop? ] [ drop bishop-valid-targets ]   } 
        { [ dup king?   ] [ drop king-valid-targets ]     } 
        { [ dup knight? ] [ drop knight-valid-targets ]   }  
        [ "unknown-piece" throw ] 
    } case ;
    
