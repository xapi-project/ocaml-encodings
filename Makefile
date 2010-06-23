BUILD_DIR=bin

.PHONY: build install clean

build:
	mkdir -p $(BUILD_DIR)
	cd $(BUILD_DIR) && cmake $(CURDIR) && make && make package

install: build
	cd $(BUILD_DIR) && rpm -i --force *.rpm

clean:
	rm -rf $(BUILD_DIR)
