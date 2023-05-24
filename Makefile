#######
# makefile for STM8*_StdPeriph_Lib and SDCC compiler
#
# note: paths in this Makefile assume unmodified SPL folder structure
#
# usage:
#   1. if SDCC not in PATH set path -> CC_ROOT
#   2. set correct STM8 device -> DEVICE
#   3. set project paths -> PRJ_SRC_DIR, PRJ_INC_DIR, PRJ_SRC_FILE
#   4. set SPL paths -> SPL_ROOT
#   5. add required STM8S_EVAL modules -> EVAL_SOURCE, EVAL_128K_SOURCE, EVAL_COMM_SOURCE
#
#######

# STM8 device (for supported devices see stm8s.h)
DEVICE	= STM8S003

# set compiler path & parameters 
CC_ROOT	=
CC      = sdcc
CFLAGS  = -mstm8 -lstm8 --opt-code-size

# set output folder and target name
OUTPUT_DIR 	= ./Build
TARGET_NAME	= main

# set project source and include directories and source files
PRJ_SRC_DIR  	= ./Core/Src
PRJ_INC_DIR  	= ./Core/Inc
PRJ_SRC_FILE	= 

# set SPL paths
SPL_ROOT	= ./SPL

# add required STM8S_EVAL modules
EVAL_SOURCE							= 
EVAL_COMM_SOURCE				= 
EVAL_STM8S_128K_SOURCE	= 


# 
# Do not edit below this line
# 

# collect all source files of project
PRJ_SOURCE := $(notdir $(wildcard $(patsubst %,%/*.c, $(PRJ_SRC_DIR))) $(PRJ_SRC_FILE))
PRJ_OBJECTS := $(addprefix $(OUTPUT_DIR)/, $(PRJ_SOURCE:.c=.rel))

# set SPL source files
SPL_MAKE_DIR = $(SPL_ROOT)/Libraries/STM8S_StdPeriph_Driver
SPL_INC_DIR = $(SPL_ROOT)/Libraries/STM8S_StdPeriph_Driver/inc
SPL_LIB_DIR = $(OUTPUT_DIR)/SPL
SPL_LIB = spl.lib

# collect all STM8S_EVAL
EVAL_DIR = $(SPL_ROOT)/Utilities/STM8S_EVAL
EVAL_COMM_DIR = $(EVAL_DIR)/Common
EVAL_STM8S_128K_DIR = $(EVAL_DIR)/STM8-128_EVAL
EVAL_OBJECTS := $(addprefix $(OUTPUT_DIR)/, $(EVAL_SOURCE:.c=.rel))
EVAL_COMM_OBJECTS := $(addprefix $(OUTPUT_DIR)/, $(EVAL_COMM_SOURCE:.c=.rel))
EVAL_STM8S_128K_OBJECTS := $(addprefix $(OUTPUT_DIR)/, $(EVAL_STM8S_128K_SOURCE:.c=.rel))

# collect all include folders
INCLUDE = -I$(PRJ_SRC_DIR) -I$(PRJ_INC_DIR) -I$(SPL_INC_DIR) -I$(EVAL_DIR) -I$(EVAL_COMM_DIR) -I$(EVAL_STM8S_128K_DIR)

# collect all source directories
VPATH=$(PRJ_SRC_DIR):$(SPL_SRC_DIR):$(EVAL_DIR):$(EVAL_COMM_DIR):$(EVAL_STM8S_128K_DIR)

# target
TARGET = $(OUTPUT_DIR)/$(TARGET_NAME).hex

.PHONY: clean

all: $(OUTPUT_DIR) $(TARGET) $(SPL_LIB)

$(SPL_LIB):
	$(MAKE) -C $(SPL_MAKE_DIR) DEVICE=$(DEVICE)

$(OUTPUT_DIR):
	mkdir -p $(OUTPUT_DIR)

$(OUTPUT_DIR)/%.rel: %.c
	$(CC) $(CFLAGS) $(INCLUDE) -D$(DEVICE) -c $?

$(OUTPUT_DIR)/%.rel: %.c
	$(CC) $(CFLAGS) $(INCLUDE) -D$(DEVICE) -c $? -o $@

$(TARGET): $(PRJ_OBJECTS) $(SPL_LIB) $(EVAL_OBJECTS) $(EVAL_COMM_OBJECTS) $(EVAL_STM8S_128K_OBJECTS)
	$(CC) $(CFLAGS) -o $(TARGET) -L$(SPL_LIB_DIR) -l$(SPL_LIB) $^

clean: 
	$(MAKE) -C $(SPL_MAKE_DIR) DEVICE=$(DEVICE) clean
	rm -fr $(OUTPUT_DIR)

re-build: clean all
