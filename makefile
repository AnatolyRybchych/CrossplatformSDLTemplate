nothing: null

#SHARED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
objects	:= main.o

#DESKTOP!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
DESKTOP_BIN_DIR := bin_desktop
DESKTOP_OBJ_DIR := obj_desktop

DESKTOP_INCLUDE_PATHS := -IC:\include
DESKTOP_LIB_PATH := -LC:\bin
DESKTOP_LIBS := -lsdl2

$(DESKTOP_OBJ_DIR)/%.o: src/%.c
	@mkdir -p $(DESKTOP_OBJ_DIR)
	gcc $(DESKTOP_INCLUDE_PATHS) -c -o $@ $^ 

build_desktop: $(addprefix $(DESKTOP_OBJ_DIR)/,$(objects))
	@mkdir -p $(DESKTOP_BIN_DIR)
	gcc $(DESKTOP_INCLUDE_PATHS) -o $(DESKTOP_BIN_DIR)/run $^ $(DESKTOP_LIB_PATH) $(DESKTOP_LIBS)


#ANDROID!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
DESKTOP_BIN_DIR := bin_android
DESKTOP_OBJ_DIR := obj_android



#WASM!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
WASM_BIN_DIR := bin_wasm
WASM_OBJ_DIR := obj_wasm
WASM_RESOURCES_DIR := wasm

$(WASM_OBJ_DIR)/%.o: src/%.c
	@mkdir -p $(WASM_OBJ_DIR)
	emcc -O2 -c -o $@ $^ 

build_wasm: $(addprefix $(WASM_OBJ_DIR)/,$(objects))
	@mkdir -p $(WASM_BIN_DIR)
	cp $(WASM_RESOURCES_DIR)/* $(WASM_BIN_DIR)
	emcc \
	-s WASM=1 \
	-s USE_SDL=2 \
	-O2 $^ \
	-o $(WASM_BIN_DIR)/index.js


#messages
null:
	@echo "missing required argument"
	@echo "you can use one of this commands:"
	@echo "    make build_desktop"
	@echo "    make build_wasm"
