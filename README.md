# gbdk-sprite-exporter
**[Aseprite][Aseprite]** exporter of sprite to GBDK compatible sprite format (.c). Exports any 4 colors indexed image to GBDK format.

## How to use
Make an image which **size is a multiple of 16x16** (so 16x16, 32x16, 48x32, etc...) in **indexed color mode** (use the GB palette) and get crazy! Once you're happy, all the 16x16 subregions of the image will be exported to a sprite library useable with GBDK.

### Example
Start from this image in 32x32 (indexed 4 colors GB mode!)
![Image](img/aseprite-sprite.png?raw=true)
Then it's exported to that code. The .h and .c file have the same name as the original .aseprite file, and are generated in the same folder (make sure to have write access).
![Image](img/c-code.png?raw=true)
And with the minimum GBDK code it builds to something like that.
![Image](img/gb-sample.png?raw=true)

## How to install
On Linux, go to where Aseprite stores the scripts (usually `/home/<your user name>/.config/aseprite/scripts/`) and clone that project with:
`git clone https://github.com/AlanFromJapan/gbdk-sprite-exporter.git`

Restart Aseprite or refresh the scripts, you should see it now.

## Misc comments
Tested only on Linux, pretty sure that it will fail on Windows (path for sure!) but should work with minor adjustments.

Coded at night after work, and though I'm a professional coder, my prodessional coding years are long behind me so induldge my mistakes. Or you can report them and I can fix it (maybe). Or fork this and do it yourself. Maybe the later (^_~)b

It was a good occasion to fix an old time feud with Lua, and now I have to admit: I like that language. It's not python but I totally see why it's gaining popularity, will be happy to play with it again later.

## Inspirations
Main source of inspiration https://github.com/redboyrave/Aseprite-GB-Exporter.git 
Basically that script nearly does it all, but works with TileSets already setup which was not my wish: I wanted to draw multiple 16x16 monster sprites with my kid on one image (Sprite in Aseprite lingo) and export it easily.

[Aseprite]: https://aseprite.org "Aseprite"