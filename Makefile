ERL=erl
REBAR=rebar3
GIT = git
REBAR_VER = 3.6.2
DB_CONFIG_DIR=priv/test_db_config

.PHONY: test

all: compile

compile:
	@$(REBAR) compile

rebar_src:
	@rm -rf $(PWD)/rebar_src
	@$(GIT) clone https://github.com/erlang/rebar3.git rebar_src
	@$(GIT) -C rebar_src checkout tags/$(REBAR_VER)
	@cd $(PWD)/rebar_src/; ./bootstrap
	@cp $(PWD)/rebar_src/rebar3 $(PWD)
	@rm -rf $(PWD)/rebar_src

get-deps:
	@$(REBAR) upgrade

deps:
	@$(REBAR) compile

.PHONY: dialyze
dialyze:
	@$(REBAR) dialyzer || [ $$? -eq 1 ];

clean:
	@$(REBAR) clean
	rm -fv erl_crash.dump

test:
	@$(REBAR) eunit
