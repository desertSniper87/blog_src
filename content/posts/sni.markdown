title: Installing debian mips on qemu
slug: debian-mips-qemu
category: computing
date: 2019-05-09
modified: 2019-05-18
Status: draft 

## The Problem 

Sometimes we want to host multiple sites in the same server to minimize on server costs. We may run applications on different ports or map subdomains to different directories. But if we want to server websites on different domains, we have to take different approaches. 

### Solution: VirtualHosts
Virtual hosting is a method for hosting multiple domain names (with separate handling of each name) on a single server (or pool of servers).

Suppose, we have two websites having urls: www.example1.com and www.example2.com. For an apache web server, we can put the source of two servers in /var/www/example1 and /var/www/html2.

We can then host both of those servers. We can change /etc/httpd/conf/httpd.conf:

```conf
# Ensure that Apache listens on port 80
Listen 80
<VirtualHost *:80>
    DocumentRoot "/www/example1"
    ServerName www.example.com

    # Other directives here
</VirtualHost>

<VirtualHost *:80>
    DocumentRoot "/www/example2"
    ServerName www.example.org

    # Other directives here
</VirtualHost>
```

### Drawbacks of VirtualHosts

SSL/TLS is a good way to provide security directly to the end users. If we want to use SSL/TLS encryption on connections using VirtualHosts, another complication arise.

If we revisit the SSL/TLS basics and the OSI networking model, the TLS connection happens on layer 4 of the layer. The problem with using named virtual hosts over SSL is that named virtual hosts rely on knowing what hostname is being requested, and the request can't be read until the SSL connection is established. 

So, VirtualHosts cannot be used in addition to SSL certificates. 

### Common certificate

This problem can be solved if we used a common domain. For example we may have a common domain named example.com and have subdomain 1.example.com and 2.example.com. But it is not practical as it hurts SEO score of the two sites.

### SNI to the rescue

Server Name Indication (SNI) is an extension to the Transport Layer Security (TLS) computer networking protocol by which a client indicates which hostname it is attempting to connect to at the start of the handshaking process.

In SNI enabled client and servers, the client sends the name of the virtual domain(i.e Virtual Host) as part of the TLS negotiation's ClientHello message. This enables the server to select the correct virtual domain early and present the browser with the certificate containing the correct name. Therefore, with clients and servers that implement SNI, a server with a single IP address can serve a group of domain names for which it is impractical to get a common certificate.

# Implementation

First, we have to check if SNI is supported in web servers. 

We have to have at least:
- Apache 2.2.12 (With OpenSSL 0.9.8f)
- Nginx 1.15.9 (With OpenSSl 0.9.8l)

Also, client have to support SNI.

- Mozilla Firefox 2.0 or later
- Opera 8.0 or later (with TLS 1.1 enabled)
- Internet Explorer 7.0 or later (on Vista, not XP)
- Google Chrome
- Safari 3.2.1 on Mac OS X 10.5.6


### Server configuration:

#### Apache

Edit /etc/httpd/conf/httpd.conf:

```conf
# Ensure that Apache listens on port 443
Listen 443

# Listen for virtual host requests on all IP addresses
NameVirtualHost *:443

# Go ahead and accept connections for these vhosts
# from non-SNI clients
SSLStrictSNIVHostCheck off

<VirtualHost *:443>
  # Because this virtual host is defined first, it will
  # be used as the default if the hostname is not received
  # in the SSL handshake, e.g. if the browser doesn't support
  # SNI.
  DocumentRoot /www/example1
  ServerName www.example.com

  # Other directives here

  SSLCertificateFile /etc/ssl/ssl-example1.crt
  SSLCertificateKeyFile /etc/ssl/ssl-example1.key
  SSLCertificateChainFile /etc/ssl/ssl-example1.ca-bundle

</VirtualHost>

<VirtualHost *:443>
  DocumentRoot /www/example2
  ServerName www.example2.org

  SSLCertificateFile /etc/ssl/ssl-example2.crt
  SSLCertificateKeyFile /etc/ssl/ssl-example2.key
  SSLCertificateChainFile /etc/ssl/ssl-example2.ca-bundle
  # Other directives here
</VirtualHost>
```

#### Nginx

Change /etc/nginx/nginx.conf (Or you can put these code in sites_enabled/site_available):
```
server {
        root /var/www/example1;
        index index.html index.htm index.nginx-debian.html index.php;
        server_name example1.com;

        location / {
                try_files $uri$args $uri$args/ /index.html;
        }

        listen 443 ssl; 
        ssl_certificate /etc/ssl/ssl-example1.crt;
        ssl_certificate_key /etc/ssl/ssl-example1.key;
        include /etc/ssl/ssl-example1.ca-bundle;
        ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; 

        # Other directives
}

server {
        root /var/www/example1;
        index index.html index.htm index.nginx-debian.html index.php;
        server_name example2.com;

        location / {
                try_files $uri$args $uri$args/ /index.html;
        }

        listen 443 ssl; # managed by Certbot;
        ssl_certificate /etc/ssl/ssl-example1.crt;
        ssl_certificate_key  /etc/ssl/ssl-example1.key;
        include /etc/ssl/ssl-example1.ca-bundle;
        ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; 

        # Other directives
}

```

Certifiates can be obtained by letsencrypt or zero.ssl or any commercial certificate providers.



