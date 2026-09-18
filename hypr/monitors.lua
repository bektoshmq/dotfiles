-- Personal monitor profiles, loaded after Omarchy's defaults.

-- LG UltraGear+ 27-inch 5K. Match by EDID description so the profile follows
-- the display across ports; 2x gives a Retina-style 2560x1440 logical desktop.
hl.monitor({
  output = "desc:LG Electronics LG ULTRAGEAR+ 605NTGYM7223",
  mode = "5120x2880@165.06",
  position = "auto",
  scale = 2,
})

-- HCS PXG27QX (EDID serial 0000000000001). Match by description so the
-- profile follows the display across ports.
hl.monitor({
  output = "desc:HCS PXG27QX 0000000000001",
  mode = "2560x1440@240",
  position = "auto",
  scale = 1.1,
})

-- Any monitor without a dedicated profile uses its preferred mode and scale.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
