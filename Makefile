MAIN_PROJECT := src/Template.Host
TEST_PROJECTS := test/Template.Host.Test

# build the main project first, then the tests
BUILD_PROJECTS := $(MAIN_PROJECT) \
									$(TEST_PROJECTS)

# assume all top level directories in src and test are projects
ALL_PROJECTS := $(wildcard src/*) \
								$(wildcard test/*)

TEST_RESULTS_DIR ?= /tmp/test-results
TEST_RESULTS_JUNIT := $(patsubst test/%, $(TEST_RESULTS_DIR)/junit/%.xml, $(TEST_PROJECTS))

build:
	$(foreach project, $(BUILD_PROJECTS), dotnet build $(project);)

clean:
	$(foreach project, $(ALL_PROJECTS), dotnet clean $(project);)

test: $(TEST_RESULTS_JUNIT)

$(TEST_RESULTS_DIR)/junit/%.xml: $(TEST_RESULTS_DIR)/%.trx
	xsltproc --output $@ .circleci/trx-to-junit.xslt $<

$(TEST_RESULTS_DIR)/%.trx: .FORCE
	dotnet test -l "trx;LogFileName=$(notdir $@)" -r $(dir $@) test/$(basename $(notdir $@))

default: build

.PHONY: build test clean default .FORCE
.FORCE:
