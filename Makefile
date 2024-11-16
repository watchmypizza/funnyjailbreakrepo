# Variables
DEB_DIR := debs                                    # Path to debs directory
DIST_DIR := dists/stable/main/binary-arm64         # Distribution directory for Sileo (architecture-specific)
PACKAGES_FILE := dists/stable/main/binary-arm64/Packages             # Path to the Packages file
PACKAGES_GZ := dists/stable/main/binary-arm64/Packages.gz            # Path to the compressed Packages file (gzip)
PACKAGES_BZ2 := dists/stable/main/binary-arm64/Packages.bz2          # Path to the compressed Packages file (bzip2)
RELEASE_FILE := dists/stable/Release              # Path to the Release file (this goes in the stable directory)

# Directories
DEB_FILES := $(wildcard $(DEB_DIR)/*.deb)         # List of all .deb files in debs directory

# Default target
all: update-repo

# Update the repository by regenerating Packages, Packages.gz, Packages.bz2, and Release files
update-repo:
	@echo "Updating repository..."
	@# Ensure the DIST_DIR exists
	@mkdir -p dists/stable/main/binary-arm64         # Create the binary directory for architecture (arm64)

	@# Generate the Packages file (listing all .deb files)
	@dpkg-scanpackages $(DEB_DIR) /dev/null > $(PACKAGES_FILE)

	@# Compress the Packages file with gzip and bzip2
	@gzip -9c $(PACKAGES_FILE) > $(PACKAGES_GZ)
	@bzip2 -9c $(PACKAGES_FILE) > $(PACKAGES_BZ2)

	@# Generate the Release file (this goes in dists/stable, not binary-arm64)
	@apt-ftparchive release dists/stable/ > $(RELEASE_FILE)

	@echo "Repository update complete!"

# Clean up generated files (optional)
clean:
	@echo "Cleaning up..."
	@rm -rf dists/stable/main/binary-arm64  # Remove architecture-specific folder
	@rm -f $(PACKAGES_FILE) $(PACKAGES_GZ) $(PACKAGES_BZ2) $(RELEASE_FILE)

.PHONY: all update-repo clean

