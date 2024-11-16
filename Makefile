# Variables
DEB_DIR := debs                               # Path to debs directory
PACKAGES_FILE := Packages                     # Path to the Packages file (root of repo)
PACKAGES_GZ := Packages.gz                    # Path to the compressed Packages file (gzip)
PACKAGES_BZ2 := Packages.bz2                  # Path to the compressed Packages file (bzip2)
RELEASE_FILE := Release                       # Path to the Release file (root of repo)

# Directories
DEB_FILES := $(wildcard $(DEB_DIR)/*.deb)      # List of all .deb files in debs directory

# Default target
all: update-repo

# Update the repository by regenerating Packages, Packages.gz, Packages.bz2, and Release files
update-repo:
	@echo "Updating repository..."
	@# Generate the Packages file (listing all .deb files)
	@dpkg-scanpackages $(DEB_DIR) /dev/null > $(PACKAGES_FILE)

	@# Compress the Packages file with gzip and bzip2
	@gzip -9c $(PACKAGES_FILE) > $(PACKAGES_GZ)
	@bzip2 -9c $(PACKAGES_FILE) > $(PACKAGES_BZ2)

	@# Generate the Release file (this will go in the root of the repo)
	@apt-ftparchive release . > $(RELEASE_FILE)

	@# Add architecture info to Release file to ensure it works with Sileo
	@echo "Architecture: arm64" >> $(RELEASE_FILE)
	@echo "Component: main" >> $(RELEASE_FILE)
	@echo "Origin: MyRepo" >> $(RELEASE_FILE)
	@echo "Label: MyRepo" >> $(RELEASE_FILE)

	@echo "Repository update complete!"

# Clean up generated files (optional)
clean:
	@echo "Cleaning up..."
	@rm -f $(PACKAGES_FILE) $(PACKAGES_GZ) $(PACKAGES_BZ2) $(RELEASE_FILE)

.PHONY: all update-repo clean

