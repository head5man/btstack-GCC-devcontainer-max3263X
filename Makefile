.DEFAULT_GOAL:=build

PYTHON ?= python

APPS:=$(subst apps/bin,,$(wildcard apps/*))
MAKEFILES:=$(APPS:=/Makefile)

project: $(MAKEFILES)

build: $(APPS)

apps/%: apps/%/Makefile
	$(MAKE) -C $@

apps/%/Makefile:
	$(PYTHON) scripts/create_project.py $(dir $@)

clean:
	$(foreach d,${APPS},[ ! -f $(d)/Makefile ] || $(MAKE) -C $(d) clean;)

delete: clean
	rm -f $(MAKEFILES)
