# Variables
DEB_DIR := debs                    # Path to debs directory
PACKAGES_FILE := Packages         # Packages file
PACKAGES_GZ := Packages.gz        # Compressed Packages file
PACKAGES_BZ2 := Packages.bz2      # Compressed Packages file (bz2)
RELEASE_FILE := Release           # Release file
ARCHITECTURE := iphoneos-arm      # Architecture (iphoneos-arm for rootless)
REPO_NAME := funnyjailbreakrepo   # Repository origin
LABEL := funnyjbrepo              # Label for the repository
DIST_DIR := $(shell pwd)          # Distribution directory (current directory)

# Default target
all: package update-repo

# Package your tweak into a .deb file using your build system (e.g., Theos)
package:
	@echo "Packaging tweak..."
	# Assuming you're running your build system (like Theos) here:
	# make -C $(BUILD_DIR) package   # Adjust as needed for your setup

# Update the repository: regenerate Packages, Release, etc.
update-repo: $(PACKAGES_FILE) $(PACKAGES_GZ) $(PACKAGES_BZ2) $(RELEASE_FILE)
	@echo "Updating repository..."
	@# Ensure the DEB_DIR exists
	@mkdir -p $(DEB_DIR)
	@# Generate the Packages file
	@dpkg-scanpackages $(DEB_DIR) /dev/null > $(PACKAGES_FILE)
	@# Generate the compressed Packages files
	@gzip -9c $(PACKAGES_FILE) > $(PACKAGES_GZ)
	@bzip2 -9c $(PACKAGES_FILE) > $(PACKAGES_BZ2)
	@# Generate the Release file with metadata
	@echo "Generating Release file..."
	@echo "Origin: $(REPO_NAME)" > $(RELEASE_FILE)
	@echo "Label: $(LABEL)" >> $(RELEASE_FILE)
	@echo "Suite: stable" >> $(RELEASE_FILE)
	@echo "Version: 1.0" >> $(RELEASE_FILE)
	@echo "Codename: ios" >> $(RELEASE_FILE)
	@echo "Architectures: iphoneos-arm64" >> $(RELEASE_FILE)
	@echo "Components: main" >> $(RELEASE_FILE)
	@echo "Description: MEOW" >> $(RELEASE_FILE)
	@echo "Repository update complete!"

# Clean up generated files (optional)
clean:
	@echo "Cleaning up..."
	@rm -f $(PACKAGES_FILE) $(PACKAGES_GZ) $(PACKAGES_BZ2) $(RELEASE_FILE)

.PHONY: all package update-repo clean

