# set flash tool path & parameters
FASH_TOOL 	= stm8flash
PROGRAMMER	= stlinkv2

.PHONY: all

all:
	$(FASH_TOOL) -c $(PROGRAMMER) -p $(DEVICE)$(DEVICE_SUFFIX) -s flash -w $(TARGET)
