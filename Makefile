.PHONY: release release_targets release-exists missing-name

check_prerequisites = release-exists

ifeq ($(NAME), )
	check_prerequisites := missing-name $(check_prerequisites)
endif

release: $(check_prerequisites)
	cp -r templates/RELEASE_NAME releases/$(NAME)
	sed -i releases/$(NAME)/*.* -e 's/%%RELEASE_NAME%%/$(NAME)/'

missing-name:
	@echo "==> Use make release NAME=foo"
	@exit 1

release-exists:
	@if [ -d "releases/$(NAME)" ]; then \
		echo "==> Can't regenrate release"; \
		exit 1; \
	fi
