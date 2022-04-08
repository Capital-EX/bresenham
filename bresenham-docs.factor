! Copyright (C) 2022 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: arrays help.markup help.syntax kernel sequences ;
IN: bresenham

HELP: bresenham
{ $values
    { "u" sequence } { "v" sequence }
    { "points" array }
}
{ $description "Takes two points and computes every point between them, returning the result as an array of points." } ;

ARTICLE: "bresenham" "bresenham"
{ $vocab-link "bresenham" }
;

ABOUT: "bresenham"
