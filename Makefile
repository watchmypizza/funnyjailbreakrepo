# Variables
REPO_DIR := $(shell pwd)
DEB_DIR := $(REPO_DIR)/debs
DIST_DIR := $(REPO_DIR)/dists/stable/main/binary-arm64
PACKAGES_FILE := $(REPO_DIR)/Packages
PACKAGES_GZ := $(REPO_DIR)/Packages.gz
PACKAGES_BZ2 := $(REPO_DIR)/Packages.bz2
RELEASE_FILE := $(REPO_DIR)/dists/stable/Release

# Directories
DEB_FILES := $(wildcard $(DEB_DIR)/*.deb)

# Default target
all: update-repo

# Update the repository by regenerating Packages and Release files
update-repo:
	@echo "Updating repository..."
	@if [ ! -d "$(DIST_DIR)" ]; then mkdir -p "$(DIST_DIR)"; fi
	@dpkg-scanpackages "$(DEB_DIR)" /dev/null > "$(PACKAGES_FILE)"
	@gzip -9c "$(PACKAGES_FILE)" > "$(PACKAGES_GZ)"
	@bzip2 -9c "$(PACKAGES_FILE)" > "$(PACKAGES_BZ2)"
	@apt-ftparchive release "$(REPO_DIR)/dists/stable/" > "$(RELEASE_FILE)"
	@echo "Repository update complete!"

# Clean up generated files (optional)
clean:
	@echo "Cleaning up..."
	rm -f "$(PACKAGES_FILE)" "$(PACKAGES_GZ)" "$(PACKAGES_BZ2)" "$(RELEASE_FILE)"

.PHONY: all update-repo clean

