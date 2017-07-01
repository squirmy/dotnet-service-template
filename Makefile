TEST_RESULTS ?= /tmp/test-results
SRC_PROJECTS := $(wildcard src/*/*.csproj)
TEST_PROJECTS := $(wildcard test/*/*.csproj)
TEST_PROJECT_NAMES := $(notdir $(TEST_PROJECTS))
TEST_RESULTS_JUNIT := $(patsubst %.csproj, $(TEST_RESULTS)/junit/%.xml, $(TEST_PROJECT_NAMES))

.PHONY: build test

default: build

build:
	dotnet build src/Template.Host
	@echo $(TEST_PROJECTS) | xargs -n 1 dotnet build

test: prepare-test $(TEST_RESULTS_JUNIT)

$(TEST_RESULTS)/junit/%.xml: $(TEST_RESULTS)/trx/%.trx
	xsltproc --output $@ .circleci/trx-to-junit.xslt $<

$(TEST_RESULTS)/trx/%.trx:
	dotnet test -l "trx;LogFileName=$(notdir $@)" -r $(dir $@) test/$(basename $(notdir $@))

clean: clean-test
	@echo $(SRC_PROJECTS) | xargs -n 1 dotnet clean
	@echo $(TEST_PROJECTS) | xargs -n 1 dotnet clean

create-test:
	mkdir -p $(TEST_RESULTS)

clean-test:
		rm -rf $(TEST_RESULTS)

prepare-test: clean-test create-test
