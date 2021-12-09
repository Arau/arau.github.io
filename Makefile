DAPPER_ENV	?=
DAPPER_ARGS	?=
DAPPER_RUN	= env $(DAPPER_ENV) dapper --keep --mode bind $(DAPPER_ARGS)

port="1313"
bind="0.0.0.0"
baseurl="http://localhost" # set to the DNS name of your site or the ip of your local machine
						   # i.e: baseurl=http://mymachine.storageos.net or
						   # http://mymachine.storageos.net/v2
conf="./config/v2.4.toml" # set the default one

.PHONY: all clean build serve prepare

all: clean build serve

serve:
	$(DAPPER_RUN) -- server --renderToDisk --forceSyncStatic --debug --verbose --config ${conf} --bind ${bind} --port ${port} --baseURL ${baseurl}

prepare:
	$(DAPPER_RUN) -- --config ${conf}

build:
	@./build/_generate-site-output.sh ${conf}

clean:
	rm -rf sites/stable/public/*
