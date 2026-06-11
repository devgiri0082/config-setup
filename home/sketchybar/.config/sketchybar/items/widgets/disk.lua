local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local disk = sbar.add("item", "widgets.disk", {
  position = "right",
  icon = {
    string = icons.disk,
    font = {
      style = settings.font.style_map["Regular"],
      size = 14.0,
    },
    padding_left = 6,
    padding_right = 6,
  },
  label = {
    string = "disk ??%",
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 10.0,
    },
    padding_right = 6,
  },
  update_freq = 60.0,
})

local function update_disk()
  sbar.exec([[df -lh /System/Volumes/Data / 2>/dev/null | grep -v "Mounted on" | head -1 | awk '{print $5}' | sed 's/%//']], function(used_percent)
    local load = tonumber(used_percent) or 0
    local color = colors.blue
    if load > 80 then
      if load < 90 then
        color = colors.orange
      else
        color = colors.red
      end
    end

    disk:set({
      icon = { color = color },
      label = "disk " .. load .. "%",
    })
  end)
end

disk:subscribe("routine", update_disk)
update_disk()

disk:subscribe("mouse.clicked", function(env)
  sbar.exec("open -a 'Disk Utility'")
end)

-- Background around the disk item
sbar.add("bracket", "widgets.disk.bracket", { disk.name }, {
  background = { color = colors.bg1 }
})

-- Padding after the disk item
sbar.add("item", "widgets.disk.padding", {
  position = "right",
  width = settings.group_paddings
})
