# HirstGenerator
Generator for Damien Hirst style spot paintings in IgorPro

The Igor Procedure File `HirstGenerator.ipf` will harvest the colour palette from a Damien Hirst spot painting and recreate it. Instructions to do this are in the ipf.

![img](/img/Replica.png?raw=true "image")

An Igor Binary Wave is included where the palette from ‘Abalone Acetone Powder’ (1991) have been extracted. Load this wave and then generate your own spot paintings using

`HirstGenerator(16,15)` for a similar sized picture generated with a random sample of colours

![img](/img/spotTest1.png?raw=true "image")

or `HirstGenerator(ww,hh)` for any shape picture.

![img](/img/spotTest2.png?raw=true "image")

--

### Note
The original idea was to determine unique colours from the extracted palette using distances in RGB (or other) colour space. The frequency of colours in the original adds to the composition and so the palette is left intact. 