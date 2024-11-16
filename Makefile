# Variables
DEB_DIR := debs                    # Path to debs directory
PACKAGES_FILE := Packages         # Packages file
PACKAGES_GZ := Packages.gz        # Compressed Packages file
PACKAGES_BZ2 := Packages.bz2      # Compressed Packages file (bz2)
RELEASE_FILE := Release           # Release file
ARCHITECTURE := arm64              # Architecture for the repo (adjust if needed)
REPO_NAME := funnyjailbreakrepo   # Name of the repository
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
	@echo "Archive: stable" > $(RELEASE_FILE)
	@echo "Component: main" >> $(RELEASE_FILE)
	@echo "Origin: $(REPO_NAME)" >> $(RELEASE_FILE)
	@echo "Label: $(LABEL)" >> $(RELEASE_FILE)
	@echo "Architecture: $(ARCHITECTURE)" >> $(RELEASE_FILE)
	@echo "Description: $(REPO_NAME) repository" >> $(RELEASE_FILE)
	@echo "" >> $(RELEASE_FILE)
	@echo "SHA256:" >> $(RELEASE_FILE)
	@sha256sum $(PACKAGES_FILE) >> $(RELEASE_FILE)
	@sha256sum $(PACKAGES_GZ) >> $(RELEASE_FILE)
	@sha256sum $(PACKAGES_BZ2) >> $(RELEASE_FILE)
	@echo "Repository update complete!"

# Clean up generated files (optional)
clean:
	@echo "Cleaning up..."
	@rm -f $(PACKAGES_FILE) $(PACKAGES_GZ) $(PACKAGES_BZ2) $(RELEASE_FILE)

.PHONY: all package update-repo clean

