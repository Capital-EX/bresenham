# Bresenham

An implementation of Bresenham's Line Algorithm written in [Factor](https://factorcode.org/). The `bresenham` word takes two points and returns a sequences of `{ x y }` pairs representing each point on the line. 

## Example of Usage
```factor
{ 0 0 } { 4 9 } bresenham 
```
```factor
{
    { 0 0 }
    { 0 1 }
    { 1 2 }
    { 1 3 }
    { 2 4 }
    { 2 5 }
    { 3 6 }
    { 3 7 }
    { 4 8 }
    { 4 9 }
}
```