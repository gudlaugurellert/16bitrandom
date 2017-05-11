# Author: Eli Birgisson
# S2956190
# Assignment 2
# Milestone 3 Makefile
# random

c=random
space=" "

bsuc="<><> Build Success <><>"
move="*** Move Completed ***"
end="||| All Done |||"

.PHONY: $c

all: $c move clean end

$c:
	@cd $c/Sources && swift build
	@echo $(space)
	@echo $(bsuc) $c
	@echo $(space)


move:
	@cp $c/.build/debug/$c .bin/
	@echo $(space)
	@echo $(move)
	@echo $(space)

clean:
	@rm -rf $c/.build

end:
	@echo $(space)
	@echo $(end)
