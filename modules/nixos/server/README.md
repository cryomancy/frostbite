All of the services in this directory are meant to be hosted on a 'server'.

Ideally this is a computer or that has minimal downtime and stays on the same network.

They are all isolated in systemd nspawn containers for best security practices.

This also helps with more clear and deterministic environments that do not rely on
propietary containers but instead utilities built into the linux kernel.

The kosei configuration system allows you to seperate all of these with MACVLANs
so they can all appear as different IP addresses on your local network.

They then can be set behind a reverse proxy to be accessed through traditional ports.

These services also require you to have a registered domain name.

I register mine with AWS's Route 53.

Per the NixOS Manual:

```text

You will need an HTTP server or DNS server for verification.
For HTTP, the server must have a webroot defined that can serve .well-known/acme-challenge.
This directory must be writeable by the user that will run the ACME client.
For DNS, you must set up credentials with your provider/server for use with lego.

```

To set this up you need to do a few things

1. Create a DNS Record Set for DNS-01 Validation
