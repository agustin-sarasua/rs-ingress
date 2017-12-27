# We need to provide a default backend for the ingress-controller. 
# The default backend is the default service that Nginx falls backs to if it cannot route a request successfully. 
# The default backend needs to satisfy the following two requirements :
# serves a 404 page at /
# serves 200 on a /healthz
# The nginx-ingress-controller project has an example default backend

kubectl create -f default-backend.yaml

# Creating secrets to specify the SSL certificate for Nginx
# The common name specified while generating the SSL certificate should be used as the host in your ingress config.
# We create secrets for the given key, certificate and dhparam files. 
# Use corresponding file names for the key, certificate and dhparam.

# Country Name (2 letter code) []:UY
# State or Province Name (full name) []:Montevideo
# Locality Name (eg, city) []:Montevideo
# Organization Name (eg, company) []:BienDeRaiz.com
# Organizational Unit Name (eg, section) []:
# Common Name (eg, fully qualified host name) []:BDR
# Email Address []:bdr@bienderaiz.com

# https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-on-centos-7

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout nginx-selfsigned.key -out nginx-selfsigned.crt

sudo openssl dhparam -out dhparam.pem 2048

kubectl create secret tls tls-certificate --key nginx-selfsigned.key --cert nginx-selfsigned.crt

kubectl create secret generic tls-dhparam --from-file=dhparam.pem

# Enable ingress

minikube addons enable ingress

kubectl create -f nginx-ingress-controller.yaml

minikube service nginx-ingress --url
# http://192.168.99.100:30035
# http://192.168.99.100:32759

# Configure Ingress

kubectl create -f ingress.yaml
echo "$(./minikube ip) api.bienderaiz.com" | sudo tee -a /etc/hosts
