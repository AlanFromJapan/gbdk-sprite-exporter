# gbdk-sprite-exporter
**[Aseprite][Aseprite]** exporter of sprite to GBDK compatible sprite format (.c). Exports any 4 colors indexed image to GBDK format.

## How to use
Make an image which **size is a multiple of 16x16** (so 16x16, 32x16, 48x32, etc...) in **indexed color mode** (use the GB palette) and get crazy! Once you're happy, all the 16x16 subregions of the image will be exported to a sprite library useable with GBDK.



## Inspirations
Main source of inspiration https://github.com/redboyrave/Aseprite-GB-Exporter.git 
Basically that script nearly does it all, but works with TileSets already setup which was not my wish: I wanted to draw multiple 16x16 monster sprites with my kid on one image (Sprite in Aseprite lingo) and export it easily.

[Aseprite]: https://aseprite.org "Aseprite"