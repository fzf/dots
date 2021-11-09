local Size = {}

function Size.moveLocation(direction)
  local win = hs.window.focusedWindow()
  if win == nil then return end
  hs.grid.setGrid('2x1')
  hs.grid.setMargins({0, 0})
  hs.window.animationDuration = 0

  if(direction == "right")
  then
    if (win.isMaximizable)
    then
      hs.grid.resizeWindowThinner(win)
    end
    hs.grid.pushWindowRight(win)
  elseif(direction == "left")
  then
    if (win.isMaximizable)
    then
      hs.grid.resizeWindowThinner(win)
    end
    hs.grid.pushWindowLeft(win)
  else
    hs.grid.maximizeWindow(win)
  end
end

return Size
