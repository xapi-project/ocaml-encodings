BUILD_DIR=bin

.PHONY: build_and_install build install clean

build_and_install: build install

build:
	mkdir -p $(BUILD_DIR)
	cd $(BUILD_DIR) && cmake $(CURDIR) && make && make package

install:
	cd $(BUILD_DIR) && rpm -i --force *.rpm

clean:
	rm -rf $(BUILD_DIR)
