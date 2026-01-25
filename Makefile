BASECONF = defaults.ini PrusaSlicer-settings-prusa-fff/PrusaResearch/2.4.5.ini
VORONCONF = voron.ini generated.ini

all: out

out: genvoron $(BASECONF) $(VORONCONF)
	./$^

ref: genxl $(BASECONF)
	./$^

generated.ini: gens $(BASECONF)
	./$^ > $@.tmp
	mv $@.tmp $@

test: tst $(BASECONF) $(VORONCONF)
	./$^

clean:
	rm -rf out ref generated.ini
