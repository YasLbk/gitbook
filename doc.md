docker build --tag gitbook-yas .
docker run -it --rm  -u jenkins -p 4001:4001 gitbook-yas
