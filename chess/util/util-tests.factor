IN: util.tests
USING: ;

[ { 2 3 4 5 6 7 8 9 } ]     [ 1 [ 8 > ] [ 1 + ]  collect-until ] unit-test
[ { 2 3 4 5 6 7 8 } ]       [ 1 [ 8 > ] [ 1 + ]  collect-until- ] unit-test