USING: accessors chess.common-resource chess.util fry kernel
  sequences ;
IN: chess.engine.player



: <player> ( type -- player )
    player new
    swap >>type ;

SINGLETONS: +human+ +ai+ ;

TUPLE: human < player ;
TUPLE: ai < player ;

! later in their own vocabs
TUPLE: dumb < ai ;
TUPLE: material < ai ;
TUPLE: defender < ai ;
TUPLE: path-finder < ai ;



