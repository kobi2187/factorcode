USING: accessors combinators combinators.smart kernel math
chess.common-resource chess.util ;

IN: chess.engine.movement



: <position> ( x y -- position )
    position new
    swap >>y
    swap >>x ;

: [+|-] ( step ? -- [step+/-] )
    [ + ] [ - ] ? curry [ call( x -- x' ) ] curry ; inline

! direction words are based on the player's view, changing structures is based on absolute board view.

: right ( chess-position n -- chess-position ) 
    over white?      [+|-] change-x ; ! white is plus, black is minus

: left  ( position n -- position ) 
    over white? not  [+|-] change-x ; ! black is plus, white is minus

: up    ( position n -- position ) 
    over white?      [+|-] change-y ; ! white is plus, black is minus

: down  ( position n -- position ) 
    over white? not  [+|-] change-y ; ! black is plus, white is minus

! for example: position 2 right 1 up


: vertical-sides ( position step -- up down )
    [ up ] [ down ] 2bi ;
: horizontal-sides ( position step -- right left )
    [ right ] [ left ] 2bi ;



: all-sides ( position step -- seq )
    [
        {
            [ 1 vertical-sides 2dup [ 1 horizontal-sides ] bi@ ] ! n s ne nw se sw
            [ 1 horizontal-sides ] ! e w
        } 2cleave
    ] output>array ;
    
    

    