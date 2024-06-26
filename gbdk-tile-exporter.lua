--Processes a 8x8 sector of an image and generate the GBDK C code representing its content as a GB sprite
--row & col are expressed as blocks of 8 pixels
local function exportTile2String (row, col, img)
    local output = ""

    --x,y are the PIXEL we look at in the Sprite coordinate (0,0) = top-left most point
    for y = row * 8, (row + 1) * 8 -1, 1
    do
        local b1 = 0
        local b2 = 0

        for x = col * 8, (col +1) * 8 -1, 1
        do
            --indexed palette: get the color index of that pixel
            idx = img:getPixel(x, y)

            b1 = b1 << 1
            b2 = b2 << 1

            --from my C# program "GbReaper - Tile.cs" : the top and low part of the 2bit index of the color is split on 2 bytes
            b1 = b1 | (0x01 & idx)
            b2 = b2 | ((0x02 & idx) >> 1)

        end --x    

        if output ~= "" then
            output = output .. ","
        end
        output = output .. string.format("0x%02x,0x%02x", b1, b2)
    end --y

    return output
end


--Returns the path of the current executing script (on linux)
--Thanks ! https://stackoverflow.com/questions/6380820/get-containing-path-of-lua-file
local function script_path()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*/)")
 end


--Exports the C file based on the template and content
 local function export_C(fpath, fnameonly, output)

    local ftemplateC = io.open(script_path() ..  "template.c","r")
    local content = ftemplateC:read("*all")
    ftemplateC:close()
    
    local foutC = io.open(fpath .. "/" .. fnameonly ..".c","w")
    content = content:gsub("%%%%CONTENT%%%%", output)
    content = content:gsub("%%%%HFILENAME%%%%", fnameonly)
    foutC:write(content)
    foutC:close()
 end

--Exports the H file based on the template and content
local function export_H(fpath, fnameonly, defines)

    local ftemplateH = io.open(script_path() ..  "template.h","r")
    local content = ftemplateH:read("*all")
    ftemplateH:close()
    
    local foutH = io.open(fpath .. "/" .. fnameonly ..".h","w")
    content = content:gsub("%%%%DEFINES%%%%", defines)
    foutH:write(content)
    foutH:close()
 end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

local cel = app.activeCel
if not cel then
  return app.alert("There is no active image")
end

--To iterate through the WHOLE SPRITE (what a noob would the image which is NOT what Aseprite calls an image)
--and ignore the Cel concept, make a new image, write there the *flattened* source Sprite and work with that: no Cel, so (0,0) is really the top-left pixel! 
--and not the top-left pixel of the bitmap (Image) in the active Cel that is maybe not the whole Sprite.
--https://community.aseprite.org/t/how-to-iterate-through-pixels-of-an-image/14155/5
local copyImg = Image(app.activeSprite.width, app.activeSprite.height, app.activeSprite.colorMode )
copyImg:drawSprite (app.activeSprite, app.activeFrame)
--current image
local img = copyImg 
if img.colorMode ~= ColorMode.INDEXED then
    return app.alert("This works only with indexed palettes.")
end

--Correct image size is stored in app.activeSprite, cel is a subset of the sprite (visible by pressing Ctrl)
--https://community.aseprite.org/t/lua-scripts-image-size-does-not-match-actual-image-size/9766
--print ("h " .. app.activeSprite.height .. " / w " .. app.activeSprite.width)
if not (app.activeSprite.height % 8 == 0 and app.activeSprite.width % 8 == 0) then
    return app.alert("This works only with images that sizes are multiples of 8x8.")
end


local output = ""
local defines = ""
local tilecount = 1
local n = #app.activeSprite.palettes[1]
if n > 2 then
  local mask = img.spec.transparentColor

  --GB sprites are 8x8 pixels
  local row = 0
  local col = 0
  
  while (row * 8 < app.activeSprite.height)
  do
    col = 0
    while (col * 8 < app.activeSprite.width)
    do
        --Save 8x8 tiles individually 
        output = output .. (output == "" and "" or ",\n\n") 
        output = output .. string.format("// Sprite #%d at (line %d, col %d)\n", tilecount, row, col)
        output = output .. exportTile2String(row, col, img)

        defines = defines .. string.format("#define TILE_%d\t\t%d\n", tilecount, (tilecount -1 ) * 4)

        col = col + 1
        tilecount = tilecount + 1
    end --while col

    row = row + 1
  end --while row
end

--These regex work on linux, on windows should trade \ for / ...
local fnameonly = app.activeSprite.filename:match("^.+/(.+)$"):gsub(".aseprite", "")
local fpath = app.activeSprite.filename:match("^(.+)/.+$")

--Exports the C file
export_C(fpath, fnameonly, output)

--Exports the H file
defines = string.format("#define TILE_COUNT\t\t%d\n\n", (tilecount-1)) .. defines
export_H(fpath, fnameonly, defines)

return app.alert("Done!")