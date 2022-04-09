! Copyright (C) 2022 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: arrays help.markup help.syntax kernel sequences ;
IN: bresenham

HELP: bresenham
{ $values
    { "p0" sequence } { "p1" sequence }
    { "points" array }
}
{ $description "Takes two points and computes every point between them, returning the result as an array of points." } 
;

ARTICLE: "bresenham" "Bresenham's Line Algorithm"
{ $vocab-link "bresenham" }
"\nThis vocab contains an implementation of Bresenham's Line Drawing Algorithm."
"It provides the word bresenham which returns the resulting line a series of"
"{x,y} points. This word can be used as followed:"
{ $code "{ 0 0 } { 4 9 } bresenham" }
;

ABOUT: "bresenham"