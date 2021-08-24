.PHONY: all
all: clean zip

.PHONY: zip
zip:
	zip prometheus.zip node_exporter.service prometheus.service prometheus.yml install.sh

.PHONY: clean
clean:
	rm -f prometheus.zip
