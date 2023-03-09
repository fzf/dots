if hs.fs.attributes("Spoons/SpoonInstall.spoon") == nil then
  hs.execute("mkdir -p Spoons; curl -L https://github.com/Hammerspoon/Spoons/raw/master/Spoons/SpoonInstall.spoon.zip | tar xf - -C Spoons/")
end

hs.loadSpoon("SpoonInstall")

spoon.SpoonInstall.repos.Knu = {
  url = "https://github.com/knu/Knu.spoon",
  desc = "Knu.spoon repository",
  branch = "release",
}
spoon.SpoonInstall.use_syncinstall = true
spoon.SpoonInstall:andUse("Knu", { repo = "Knu" })
