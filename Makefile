.PHONY: build test

TEST_RESULTS ?= /tmp/test-results

default: build

build:
	dotnet build src/Template.Host
	dotnet build test/Template.Host.Test

test:
	dotnet test -l trx -r $(TEST_RESULTS) test/Template.Host.Test
