local runtime = {}

-- Restarts Hammerspoon (calling hs.reload())
runtime.restart = function (message)
  hs.alert.show(message or "Restarting Hammerspoon...")
  -- Give some time for alert to show up before reloading
  hs.timer.doAfter(0.1, hs.reload)
end

local globals = {}

-- Guards an object from garbage collection
runtime.guard = function (object)
  local caller = debug.getinfo(2)
  table.insert(globals, {
      object = object,
      file = caller.source:match("^@?(.+)"),
      line = caller.currentline,
  })
  return object
end

-- Unguards a guarded object
runtime.unguard = function (object)
  for i, tuple in ipairs(globals) do
    if tuple.object == object then
      table.remove(globals, i)
      break
    end
  end
  return object
end

runtime.globals = function ()
  return globals
end

local restarter

-- Enables or disable auto-restart when any of the *.lua files under
-- ~/.hammerspoon/ is modified
runtime.autorestart = function (flag)
  if flag then
    if restarter == nil then
      restarter = hs.pathwatcher.new("./",
        function (files)
          for _, file in ipairs(files) do
            if file:find("/[^./][^/]*%.lua$") then
              knu.runtime.restart()
              return
            end
          end
        end
      )
    end
    restarter:start()
  else
    if restarter then
      restarter:stop()
    end
  end
end

return runtime
