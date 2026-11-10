.SUFFIXES:
ifeq ($(strip $(DEVKITPRO)),)
$(error "Define DEVKITPRO")
endif
TOPDIR ?= $(CURDIR)
include $(DEVKITPRO)/wut/share/wut_rules

TARGET   := CapibaraRoyale
BUILD    := build
SOURCES  := src
DATA     :=
INCLUDES := src
CONTENT  := assets
ICON     := icon.png

APP_NAME       := Capibara Royale
APP_SHORTNAME  := Capibara Royale
APP_AUTHOR     := Jhon Londoño

CFLAGS   := -g -Wall -O2 -ffunction-sections $(MACHDEP)
CFLAGS   += $(INCLUDE) -D__WIIU__ -D__WUT__ $(shell $(PORTLIBS_PPC)/bin/sdl2-config --cflags 2>/dev/null)
CXXFLAGS := $(CFLAGS) -std=c++17
ASFLAGS  := -g $(ARCH)
LDFLAGS  = -g $(ARCH) $(RPXSPECS) -Wl,-Map,$(notdir $*.map)
LIBS     := -lSDL2_image -lSDL2_mixer -lSDL2_ttf -lSDL2 -lwut
LIBDIRS  := $(PORTLIBS) $(WUT_ROOT)

ifneq ($(BUILD),$(notdir $(CURDIR)))
export OUTPUT  := $(CURDIR)/$(TARGET)
export TOPDIR  := $(CURDIR)
export VPATH   := $(foreach dir,$(SOURCES),$(CURDIR)/$(dir))
export DEPSDIR := $(CURDIR)/$(BUILD)
CFILES   := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.c)))
CPPFILES := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.cpp)))
export LD := $(CXX)
export OFILES := $(CPPFILES:.cpp=.o) $(CFILES:.c=.o)
export INCLUDE := $(foreach dir,$(INCLUDES),-I$(CURDIR)/$(dir)) \
                  $(foreach dir,$(LIBDIRS),-I$(dir)/include)
export LIBPATHS := $(foreach dir,$(LIBDIRS),-L$(dir)/lib)
export APP_CONTENT := $(TOPDIR)/$(CONTENT)
export APP_ICON    := $(TOPDIR)/$(ICON)
.PHONY: $(BUILD) clean all
all: $(BUILD)
$(BUILD):
	@[ -d $@ ] || mkdir -p $@
	@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile
clean:
	@rm -fr $(BUILD) $(TARGET).wuhb $(TARGET).rpx $(TARGET).elf
else
DEPENDS := $(OFILES:.o=.d)
all: $(OUTPUT).wuhb
$(OUTPUT).wuhb: $(OUTPUT).rpx
$(OUTPUT).rpx: $(OUTPUT).elf
$(OUTPUT).elf: $(OFILES)
-include $(DEPENDS)
endif
