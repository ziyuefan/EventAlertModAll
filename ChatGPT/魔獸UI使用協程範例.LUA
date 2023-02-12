-- Initialize our variables and create our frame
local frame = CreateFrame("Frame")
local timer = 0

-- Our OnUpdate function that will run every frame
frame:SetScript("OnUpdate", function(self, elapsed)
  timer = timer + elapsed
  if timer >= 0.5 then
    -- Resume our coroutine
    local success, message = coroutine.resume(co)
    if not success then
      print(message)
    end
    timer = 0
  end
end)

-- Our coroutine function
local function MyCoroutine()
  while true do
    -- Do some logic here
    print("Running coroutine...")
    coroutine.yield()
  end
end

-- Start our coroutine
local co = coroutine.create(MyCoroutine)
