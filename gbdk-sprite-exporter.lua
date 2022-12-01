
local cel = app.activeCel
if not cel then
  return app.alert("There is no active image")
end

--current image
local img = cel.image
if img.colorMode ~= ColorMode.INDEXED then
    return app.alert("This works only with indexed palettes.")
end

--Correct image size is stored in app.activeSprite, cel is a subset of the sprite
--https://community.aseprite.org/t/lua-scripts-image-size-does-not-match-actual-image-size/9766
--print ("h " .. app.activeSprite.height .. " / w " .. app.activeSprite.width)
if not (app.activeSprite.height % 16 == 0 and app.activeSprite.width % 16 == 0) then
    return app.alert("This works only with images that sizes are multiples of 16x16.")
end

local output = ""
local n = #app.activeSprite.palettes[1]
if n > 2 then
  local mask = img.spec.transparentColor

  --GB sprites are 8x8 pixels, and we expect here to deal with 16x16 so 4 GBSprites
  --but there might be many in the same image so use the row and col to be understood as multiples of 8px
  local row = 0
  local col = 0

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
      -- b1 = (byte)(b1 | (byte)(0x01 & vIdx));
      -- b2 = (byte)(b2 | (byte)((0x02 & vIdx) >> 1));
      b1 = b1 | (0x01 & idx)
      b2 = b2 | ((0x02 & idx) >> 1)

    end --x    

    if output ~= "" then
      output = output .. ","
    end
    output = output .. string.format("0x%02x,0x%02x", b1, b2)
  end --y
end

print(output)