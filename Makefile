# vim: noexpandtab filetype=make

DOCKER_IMAGE_FOO ?=micro-backend-foo
DOCKER_IMAGE_BAR ?=micro-backend-bar
VERSION1 ?=v1
VERSION2 ?=v2
ACR ?= kube3421.azurecr.io
INGRESS_HOST ?=$(shell kubectl get svc/micro-frontend -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

.PHONY: build-backend
build-backend:
	docker build --no-cache -t melvinlee/$(DOCKER_IMAGE_FOO):$(VERSION1) ./backend
	docker build --no-cache --build-arg service_name=foo --build-arg version=v2 -t melvinlee/$(DOCKER_IMAGE_FOO):$(VERSION2) ./backend
	docker build --no-cache --build-arg service_name=bar -t melvinlee/$(DOCKER_IMAGE_BAR):$(VERSION1) ./backend

.PHONY: push-backend
push-backend:
	docker push melvinlee/$(DOCKER_IMAGE_FOO):$(VERSION1)
	docker push melvinlee/$(DOCKER_IMAGE_FOO):$(VERSION2)
	docker push melvinlee/$(DOCKER_IMAGE_BAR):$(VERSION1)

.PHONY: build-frontend
build-frontend:
	docker build --no-cache -t melvinlee/micro-frontend:$(VERSION1) ./frontend
	docker build --no-cache --build-arg version=v2 -t melvinlee/micro-frontend:$(VERSION2) ./frontend

.PHONY: push-frontend
push-frontend:
	docker push melvinlee/micro-frontend:$(VERSION1)
	docker push melvinlee/micro-frontend:$(VERSION2)

.PHONY: tag-acr
tag-acr:
	#############################################################
	# Re-tag docker image with ACR address
	#############################################################
	docker tag melvinlee/micro-frontend:$(VERSION1) $(ACR)/ping/micro-frontend:$(VERSION1)
	docker tag melvinlee/micro-frontend:$(VERSION2) $(ACR)/ping/micro-frontend:$(VERSION2)

	docker tag melvinlee/$(DOCKER_IMAGE_FOO):$(VERSION1) $(ACR)/ping/$(DOCKER_IMAGE_FOO):$(VERSION1)
	docker tag melvinlee/$(DOCKER_IMAGE_FOO):$(VERSION2) $(ACR)/ping/$(DOCKER_IMAGE_FOO):$(VERSION2)
	docker tag melvinlee/$(DOCKER_IMAGE_BAR):$(VERSION1) $(ACR)/ping/$(DOCKER_IMAGE_BAR):$(VERSION1)

.PHONY: push-acr
push-acr:
	#############################################################
	# Push docker image to ACR
	#############################################################	
	docker push $(ACR)/ping/micro-frontend:$(VERSION1) 
	docker push $(ACR)/ping/micro-frontend:$(VERSION2)

	docker push $(ACR)/ping/$(DOCKER_IMAGE_FOO):$(VERSION1)
	docker push $(ACR)/ping/$(DOCKER_IMAGE_FOO):$(VERSION2)
	docker push $(ACR)/ping/$(DOCKER_IMAGE_BAR):$(VERSION1)

.PHONY: deploy
deploy:
	kubectl apply -f ./kube/backend-foo-v1.yaml
	kubectl apply -f ./kube/backend-bar-v1.yaml
	kubectl apply -f ./kube/frontend.yaml
	kubectl apply -f ./kube/config-frontend.yaml

.PHONY: cleanup
cleanup:
	kubectl delete -f ./kube/

.PHONY: status
status:
	kubectl get deploy,pod,svc

.PHONY: curl
curl:
	http $(INGRESS_HOST)
