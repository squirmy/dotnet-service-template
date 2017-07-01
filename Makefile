SRC_PROJECTS := src/Template.Host
TEST_PROJECTS := test/Template.Host.Test
TEST_RESULTS_DIR ?= /tmp/test-results
TEST_RESULTS_JUNIT := $(patsubst test/%, $(TEST_RESULTS_DIR)/junit/%.xml, $(TEST_PROJECTS))

build:
	$(foreach project, $(SRC_PROJECTS), dotnet build $(project))
	$(foreach project, $(TEST_PROJECTS), dotnet build $(project))

clean:
	$(foreach project, $(SRC_PROJECTS), dotnet clean $(project))
	$(foreach project, $(TEST_PROJECTS), dotnet clean $(project))

test: $(TEST_RESULTS_JUNIT)

$(TEST_RESULTS_DIR)/junit/%.xml: $(TEST_RESULTS_DIR)/%.trx
	xsltproc --output $@ .circleci/trx-to-junit.xslt $<

$(TEST_RESULTS_DIR)/%.trx: .FORCE
	dotnet test -l "trx;LogFileName=$(notdir $@)" -r $(dir $@) test/$(basename $(notdir $@))

default: build

.PHONY: build test clean default .FORCE
.FORCE:
