# Define the directory where your .deb files are located
DEB_DIR := debs
# Define the output file names
PACKAGES := Packages
PACKAGES_GZ := Packages.gz
PACKAGES_BZ2 := Packages.bz2

# Default target
all: $(PACKAGES) $(PACKAGES_GZ) $(PACKAGES_BZ2)

# Generate the Packages file
$(PACKAGES):
	@echo "Generating Packages file..."
	dpkg-scanpackages $(DEB_DIR) /dev/null > $(PACKAGES)

# Generate the gzipped version of Packages
$(PACKAGES_GZ): $(PACKAGES)
	@echo "Generating Packages.gz..."
	gzip -9c $(PACKAGES) > $(PACKAGES_GZ)

# Generate the bzip2-compressed version of Packages
$(PACKAGES_BZ2): $(PACKAGES)
	@echo "Generating Packages.bz2..."
	bzip2 -9c $(PACKAGES) > $(PACKAGES_BZ2)

# Clean up generated files
clean:
	@echo "Cleaning up..."
	rm -f $(PACKAGES) $(PACKAGES_GZ) $(PACKAGES_BZ2)

.PHONY: all clean

