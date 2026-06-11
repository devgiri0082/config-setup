local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local ram = sbar.add("graph", "widgets.ram", 42, {
  position = "right",
  graph = { color = colors.blue },
  background = {
    height = 22,
    color = { alpha = 0 },
    border_color = { alpha = 0 },
    drawing = true,
  },
  icon = { string = icons.memory },
  label = {
    string = "ram ??%",
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 9.0,
    },
    align = "right",
    padding_right = 0,
    width = 0,
    y_offset = 4
  },
  padding_right = settings.paddings + 6,
  update_freq = 2.0,
})

local function update_ram()
  sbar.exec([[vm_stat | awk '/page size of/ {pagesize=$8; sub(/\)/, "", pagesize)} /Pages free:/ {free=$3; sub(/\./, "", free)} /Pages active:/ {active=$3; sub(/\./, "", active)} /Pages inactive:/ {inactive=$3; sub(/\./, "", inactive)} /Pages speculative:/ {speculative=$3; sub(/\./, "", speculative)} /Pages wired down:/ {wired=$3; sub(/\./, "", wired)} /Pages occupied by compressor:/ {compressor=$3; sub(/\./, "", compressor)} END { if (!pagesize) pagesize=16384; "sysctl -n hw.memsize" | getline memsize; total_pages = memsize / pagesize; used_pages = active + wired + compressor; used_percent = (used_pages / total_pages) * 100; printf "%.0f\n", used_percent; }']], function(used_percent)
    local load = tonumber(used_percent) or 0
    -- Scale by 0.5 to make the graph smaller so it doesn't overlap the text
    ram:push({ (load / 100.) * 0.5 })

    local color = colors.blue
    if load > 60 then
      if load < 80 then
        color = colors.yellow
      elseif load < 90 then
        color = colors.orange
      else
        color = colors.red
      end
    end

    ram:set({
      graph = { color = color },
      label = "ram " .. load .. "%",
    })
  end)
end

ram:subscribe("routine", update_ram)
update_ram()

ram:subscribe("mouse.clicked", function(env)
  sbar.exec("open -a 'Activity Monitor'")
end)

-- Background around the ram item
sbar.add("bracket", "widgets.ram.bracket", { ram.name }, {
  background = { color = colors.bg1 }
})

-- Padding after the ram item
sbar.add("item", "widgets.ram.padding", {
  position = "right",
  width = settings.group_paddings
})
