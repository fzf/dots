local Size = {}

function Size.moveLocation(direction)
  local win = hs.window.focusedWindow()
  if win == nil then return end

  local winFrame = win:frame()
  local screen = win:screen()
  local screenFrame = screen:frame()

  if(direction == "right") then
    hs.grid.resizeWindowThinner(win)
    hs.grid.pushWindowRight(win)
  elseif(direction == "left") then
    hs.grid.resizeWindowThinner(win)
    -- Check if full screen, only move if not full screen
    if(winFrame:equals(screenFrame) == false) then
      hs.grid.pushWindowLeft(win)
    end
  elseif(direction == "full") then
    hs.grid.maximizeWindow(win)
  end
end

return Size
