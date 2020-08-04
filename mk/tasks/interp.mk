# A very basic interpolation function:

# $(call interp, \
#  FOO BAR BAAZ QUUX, \
#  "target_file")

# In target_file, replaces all occurrances of {{ FOO }} with the value of
# $(FOO), all occurrances of {{ BAR }} with $(BAR), etc.

_sedi = sed -i '' -e 's/$(1)/$(2)/g' $(3)
interp = $(foreach repl,$(1),$(call _sedi,{{ $(repl) }},$(value $(repl)),$(2));)
