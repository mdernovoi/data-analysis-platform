
.PHONY: find-todo-replace-placeholders

find-todo-replace-placeholders :
	@echo "#######################################################################"
	@echo "#"
	@echo "# Searching for placeholders that have to be replaced with actual values..."
	@echo "# Please review and replace them with actual values before continuing."
	@echo "#"
	@echo "#######################################################################"
	-egrep -r --with-filename --line-number --context=6 '{{TODO:REPLACE}}' --exclude=Makefile --exclude=README.md --exclude-dir=.git ./
	

