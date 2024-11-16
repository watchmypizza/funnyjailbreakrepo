# Variables
REPO_DIR := $(shell pwd)                # Current directory (where Makefile is located)
DEB_DIR := $(REPO_DIR)/debs              # Path to debs directory
DIST_DIR := $(REPO_DIR)/dists/stable/main/binary-arm64 # Distribution directory for Sileo
PACKAGES_FILE := $(REPO_DIR)/Packages
PACKAGES_GZ := $(REPO_DIR)/Packages.gz
PACKAGES_BZ2 := $(REPO_DIR)/Packages.bz2
RELEASE_FILE := $(REPO_DIR)/dists/stable/Release

# Directories
BUILD_DIR := $(REPO_DIR)/build
DEB_FILES := $(wildcard $(DEB_DIR)/*.deb)

# Default target
all: package update-repo

# Package your tweak into a .deb file using your build system (e.g., Theos)
package:
	@echo "Packaging tweak..."
	make -C $(BUILD_DIR) package   # Adjust this to match your build system if needed

# Update the repository by regenerating Packages and Release files
update-repo:
	@echo "Updating repository..."
	@# Ensure the DIST_DIR exists
	@if [ ! -d "$(DIST_DIR)" ]; then mkdir -p $(DIST_DIR); fi
	@# Generate the Packages file
	@dpkg-scanpackages $(DEB_DIR) /dev/null > $(PACKAGES_FILE)
	@# Generate the compressed Packages files
	@gzip -9c $(PACKAGES_FILE) > $(PACKAGES_GZ)
	@bzip2 -9c $(PACKAGES_FILE) > $(PACKAGES_BZ2)
	@# Generate the Release file
	@apt-ftparchive release $(REPO_DIR)/dists/stable/ > $(RELEASE_FILE)
	@echo "Repository update complete!"

# Clean up generated files (optional)
clean:
	@echo "Cleaning up..."
	rm -f $(PACKAGES_FILE) $(PACKAGES_GZ) $(PACKAGES_BZ2) $(RELEASE_FILE)

.PHONY: all package update-repo clean

