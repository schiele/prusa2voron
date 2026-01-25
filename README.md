# prusa2voron

After building a Voron 2.4r2, I started my Prusa Slicer config off from the
Voron settings found in PrusaSlicer.  During the tuning process I realized
that the fine-tuned Prusa XL settings, despite being for a different printer,
produced way better results after changing just a few technical parameters
that were not correct for a Klipper printer.  So I decided to create a tool
that automatically converts Prusa XL settings to Voron settings.  This comes
with the additional advantage that I get all the print and filament settings
Prusa maintains for their XL on my Voron.  Technically, the tool could also
use other slicer settings as a base and convert to other printer models, since
the code is generic, making this just a matter of configuration.

The code still is a bit experimental, but works for me.  Should you get stuck,
feel free to ask.

The scripts work on Linux.  If you run make it will generate all XL-derived
settings in the out directory.  Copy those that you are interested in to your
PrusaSlicer config directory.  If you like, you may copy them all but in
particular for the filaments this causes the dropdown menus to become very
lengthy.  To prevent that you may want to copy only the settings you plan to
use.  Since your printer might be slightly different to mine, you may want to
tweak the configuration a bit.  Alternatively, you for sure can also configure
your printer exactly like mine.  My current config is published in
https://github.com/schiele/klipper-config
