.PHONY: build
build: proto_ts_definitions
	npm run build

dist: proto_ts_definitions
	npm run dist

# Generate typescript definitions for our protobuf messages
.PHONY: proto_ts_definitions
proto_ts_definitions: node_modules
	./node_modules/protobufjs/bin/pbjs -t static-module -w commonjs -o modules/proto/index.js \
	../proto/{client,markets,stream}/*.proto
	./node_modules/protobufjs/bin/pbjs \
		-t static-module ../proto/{client,markets,stream}/*.proto \
		| ./node_modules/protobufjs/bin/pbts -o proto.d.ts -
	# disbale tslint in here because pbts tool complains; it works fine though
	echo "/* tslint:disable */" > modules/proto/index.d.ts
	echo "\n/* GENERATED BY MAKEFILE */\n" >> modules/proto/index.d.ts
	cat proto.d.ts >> modules/proto/index.d.ts
	rm proto.d.ts

node_modules:
	npm i

.PHONY: test
test: node_modules
	npm test

.PHONY: clean
clean:
	rm -rf build dist