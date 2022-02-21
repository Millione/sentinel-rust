SRC_FILES := $(shell find . -name '*.rs' -print)

check:
	cargo check --all-features

clippy:
	cargo clippy --all-targets

doc: clean
	cargo doc --no-deps 

clean:
	cargo clean

fmt:
	@rustfmt --edition 2018 $(SRC_FILES)

unit: unit_single unit_parallel

unit_single:
	cargo test --workspace --exclude sentinel-envoy-module -- --ignored --test-threads=1 --nocapture

unit_parallel:
	cargo test --workspace --exclude sentinel-envoy-module -- --nocapture

envoy:
	cargo build --target wasm32-unknown-unknown --release -p sentinel-envoy-module
	cp target/wasm32-unknown-unknown/release/sentinel_envoy_module.wasm examples/proxy/envoy/docker/sentinel_envoy_module.wasm
	cd examples/proxy/envoy && docker-compose up --build

.PHONY: clean clippy doc fmt unit unit_single unit_parallel check envoy
