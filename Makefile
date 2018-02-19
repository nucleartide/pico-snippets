# Serve app.
#
# Note that `clean` is a prerequisite step. This ensures that Parcel reports
# TypeScript errors on first build.
serve: clean
	@./node_modules/.bin/parcel client/index.html
.PHONY: serve

# Clean up Parcel's generated files.
clean:
	@rm -rf .cache/
	@rm -rf dist/
.PHONY: clean
