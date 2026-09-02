-- Personal monitor profiles, loaded after Omarchy's defaults.

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
