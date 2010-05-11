

SYMBOL: myboard
initial-board myboard set
! 0 is white rook, 1 is white knight, 63 is black rook, 60 black king, 59 black queen, 2 is white bishop, 3 white queen 4 white king

: get-piece-color ( board n -- piece color )
    swap nth piece>> dup color>> ;


[ t ] [ myboard get 0 get-piece-color [ rook? ] [ white? ] bi* and ] unit-test
[ t ] [ myboard get 1 get-piece-color [ knight? ] [ white? ] bi* and ] unit-test

[ t ] [ myboard get 59 get-piece-color [ queen? ] [ black? ] bi* and ] unit-test
[ t ] [ myboard get 60 get-piece-color [ king? ] [ black? ] bi* and ] unit-test
[ t ] [ myboard get 63 get-piece-color [ rook? ] [ black? ] bi* and ] unit-test
[ t ] [ myboard get 2 get-piece-color [ bishop? ] [ white? ] bi* and ] unit-test
[ t ] [ myboard get 3 get-piece-color [ queen? ] [ white? ] bi* and ] unit-test
[ t ] [ myboard get 4 get-piece-color [ king? ] [ white? ] bi* and ] unit-test