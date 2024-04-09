# Define variables
FLUTTER = fvm flutter
SHARED_COMPONENTS = shared_components

create_package: instance_package remove_unused_files

instance_package:
	@echo "Creating $(PACKAGE_NAME) package..."
	@- cd shared_components && $(FLUTTER) create --template=package $(PACKAGE_NAME)

remove_unused_files:
	@echo "Removing unused files from $(PACKAGE_NAME) package..."
	@- rm -rf $(SHARED_COMPONENTS)/$(PACKAGE_NAME)/LICENSE
	@- rm -rf $(SHARED_COMPONENTS)/$(PACKAGE_NAME)/$(PACKAGE_NAME).iml
	@- rm -rf $(SHARED_COMPONENTS)/$(PACKAGE_NAME)/CHANGELOG.md
	@- rm -rf $(SHARED_COMPONENTS)/$(PACKAGE_NAME)/.metadata
	@- rm -rf $(SHARED_COMPONENTS)/$(PACKAGE_NAME)/.gitignore
	@- rm -rf $(SHARED_COMPONENTS)/$(PACKAGE_NAME)/.dart_tool
	@- rm -rf $(SHARED_COMPONENTS)/$(PACKAGE_NAME)/.

help:
	@echo "Usage:"
	@echo " * create_package   - Create Flutter package and remove unused files"
	@echo " * help         	   - Show this help message"

ifeq ($(PACKAGE_NAME),)
create_package:
	$(error PACKAGE_NAME is required. Example: make create_package PACKAGE_NAME=my_package_name)
endif
