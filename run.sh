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

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout nginx-selfsigned.key -out nginx-selfsigned.crt



kubectl create -f ingress.yaml
echo "$(./minikube ip) api.bienderaiz.com" | sudo tee -a /etc/hosts
