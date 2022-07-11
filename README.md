# Fast in-place Walsh-Hadamard Transform
- Author or source: Timo H Tossavainen
- Type: wavelet transform
- Created: 2002-01-17 01:54:52

IIRC, They're also called walsh-hadamard transforms.
Basically like Fourier, but the basis functions are squarewaves with different sequencies.
I did this for a transform data compression study a while back.
Here's some code to do a walsh hadamard transform on long ints in-place (you need to
divide by n to get transform) the order is bit-reversed at output, IIRC.
The inverse transform is the same as the forward transform (expects bit-reversed input).
i.e. x = 1/n * FWHT(FWHT(x)) (x is a vector)
