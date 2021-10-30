builddir = ../K8SFramework/build
registry = tarscloud
tag = v1.0.0

tars: tarsweb tarsagent tarscontroller tarsregistry tarsnode tarsimage tarsconfig tarslog tarsnotify tarsproperty tarsqueryproperty tarsquerystat tarsstat

php74base:
	mkdir -p $@/files
	cp $(builddir)/files/entrypoint.sh $@/files
	docker build -t $(registry)/tars.$@:$(tag) -f tars.$@.Dockerfile $@

tarsconfig tarslog tarsnotify tarsproperty tarsqueryproperty tarsquerystat tarsstat:
	mkdir -p $@/files/binary
	cp $(builddir)/files/entrypoint.sh $@/files
	cp $(builddir)/files/binary/$@ $@/files/binary/
	sed 's/{{app}}/'$@'/' tars.app.Dockerfile > $@/Dockerfile
	docker build -t $(registry)/tars.$@:$(tag) -f $@/Dockerfile $@

tarsregistry tarsnode tarsimage:
	mkdir -p $@/files/binary $@/files/template
	cp $(builddir)/files/binary/$@ $@/files/binary/
	cp -r $(builddir)/files/template/$@ $@/files/template/
	docker build -t $(registry)/tars.$@:$(tag) -f $(builddir)/tars.$@.Dockerfile $@

tarscontroller: 
	mkdir -p $@/files/binary $@/files/template
	cp $(builddir)/files/binary/$@ $@/files/binary/
	cp -r $(builddir)/files/template/$@ $@/files/template/
	docker build -t $(registry)/$@:$(tag) -f $(builddir)/$@.Dockerfile $@

# tarsgent: 
# 	mkdir -p $@/files/binary $@/files/template
# 	cp $(builddir)/files/binary/$@ $@/files/binary/
# 	cp -r $(builddir)/files/template/tarsimage $@/files/template/
# 	docker build -t $(registry)/$@:$(tag) -f $(builddir)/$@.Dockerfile $@

tarsweb: 
	docker pull $(registry)/tars.tarsweb:$(tag)

tarsagent:
	docker pull $(registry)/tarsagent:$(tag)

.PHONY : tarscontroller tarsimage tarsgent tarsregistry tarsnode tarsconfig tarslog tarsnotify tarsproperty tarsqueryproperty tarsquerystat tarsstat php74base

tag:
	docker tag tarscloud/tars.tarsconfig:$(tag)         $(registry)/tars.tarsconfig:$(tag)
	docker tag tarscloud/tars.tarsimage:$(tag)          $(registry)/tars.tarsimage:$(tag)
	docker tag tarscloud/tars.tarslog:$(tag)            $(registry)/tars.tarslog:$(tag)
	docker tag tarscloud/tars.tarsnotify:$(tag)         $(registry)/tars.tarsnotify:$(tag)
	docker tag tarscloud/tars.tarsproperty:$(tag)       $(registry)/tars.tarsproperty:$(tag)
	docker tag tarscloud/tars.tarsqueryproperty:$(tag)  $(registry)/tars.tarsqueryproperty:$(tag)
	docker tag tarscloud/tars.tarsquerystat:$(tag)      $(registry)/tars.tarsquerystat:$(tag)
	docker tag tarscloud/tars.tarsregistry:$(tag)       $(registry)/tars.tarsregistry:$(tag)
	docker tag tarscloud/tars.tarsstat:$(tag)           $(registry)/tars.tarsstat:$(tag)
	docker tag tarscloud/tars.tarsweb:$(tag)            $(registry)/tars.tarsweb:$(tag)
	docker tag tarscloud/tarsagent:$(tag)               $(registry)/tarsagent:$(tag)
	docker tag tarscloud/helm.wait:$(tag)               $(registry)/helm.wait:$(tag)

push pull:
	docker $@ $(registry)/tars.tarsconfig:$(tag)
	docker $@ $(registry)/tars.tarsimage:$(tag)
	docker $@ $(registry)/tars.tarslog:$(tag)
	docker $@ $(registry)/tars.tarsnode:$(tag)
	docker $@ $(registry)/tars.tarsnotify:$(tag)
	docker $@ $(registry)/tars.tarsproperty:$(tag)
	docker $@ $(registry)/tars.tarsqueryproperty:$(tag)
	docker $@ $(registry)/tars.tarsquerystat:$(tag)
	docker $@ $(registry)/tars.tarsregistry:$(tag)
	docker $@ $(registry)/tars.tarsstat:$(tag)
	docker $@ $(registry)/tars.tarsweb:$(tag)
	docker $@ $(registry)/tarsagent:$(tag)
	docker $@ $(registry)/tarscontroller:$(tag)
	docker $@ $(registry)/helm.wait:$(tag)
