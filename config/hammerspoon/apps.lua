local function toggleApplication(name)
  local app = hs.application.find(name)
  if not app or app:isHidden() then
    hs.application.launchOrFocus(name)
  elseif hs.application.frontmostApplication() ~= app then
    app:activate()
  else
    app:hide()
  end
end

hs.hotkey.bind(mash, "t", function() toggleApplication("iTerm") end)
hs.hotkey.bind(mash, "c", function() toggleApplication("Google Chrome") end)
hs.hotkey.bind(mash, "f", function() toggleApplication("Firefox") end)
hs.hotkey.bind(mash, "p", function() toggleApplication("1Password 7") end)