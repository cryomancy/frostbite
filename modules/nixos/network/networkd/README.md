# FROSTBITE Networkd Implementation

Networkd is an amazing software networking solution for Linux but it
does come with the overhead of being familiar with not only it's 
syntax but how that syntax fits into Nix. You then have to be partially
aware of the underlying protocols, routing, implementation, ect...

The aim of Frostbite's implementation is to provide an easy-to-use
abstraction layer over Nix's Networkd options. In many cases it can
also be seen as a more up-to-date solution to learning than reading
the NixOS forums or the NetworkD Man pages.

## How do I use Networkd? Why would I use it?
Many NetworkManager enjoyers claim that Networkd is not a good solution for
ad-hoc networks and should only be used on permanent infrastructure such as
servers. After using it extensively I both agree and disagree. If you are a
casual Linux user and need to quickly connect to a wireless network then
it is not a bad solution at all and requires almost no configuration from the
end user. When it comes time to configuring NetworkManager you start seeing
what it's implementation lacks, especially when you need anything advanced
(e.g. virtual networking devices and tunnels).

Thankfully, implementing an ad-hoc network solution and a declarative solution
is entirely possible with Networkd and complemented with good ol' `iproute2`
commands when you really just want to test something and quickly tear it down
can provide everything you would need from Networkd with the added ability
of not being a bunch of shell scripts in a trench coat. 

These features, along with it's first-class implementation in Nix lead me to
believe it is the better of the two common networking solutions on Linux,
especially in the Nix ecosystem. That lead's us to how we use it? Well in a
summary you have two main steps.

	1. Define `netdevs` (network devices) and/or reconfigure existing devices
	   with Networkd links.
		a. These can be anything from virtual layer one devices to
		   stacked network devices.
	
	3. Assign those network devices a network.
		a. The match statement will select will netdev you would like to
		   assign this address to.


Let's get to how we assign the devices. Every device will have an assigned name
that represents the device for configuration only. This is also it's configuration
file as many have seen in other Linux device configuration programs. This usually
starts with a number follow by its name or a recognizable name. This could be
something like "30-vlan4". Networkd enumerates these files and builds the network
in order of priority based initially on number. It arbitrarily stops at 70 according
to their documentation. After that their pre-configured settings get priority. This
is not something I am a huge fan of and seems like a silly limit but sadly many
developers follow this enumeration practice.

#### NETWORKD NETDEV ENUMERATION SCHEME

        10-19: wlan, veth, vcan            # layer 1 devices
        20-29: vlan macvlans                 # layer 2 devices
	30-39: bridges gretap tap             # layer 2 tunnel
	40-49:                # layer 3 devices
	50-59: bonds, geneve, gre            # layer 3 tunnels
	60-69: fou, bareudp                # layer 4
	
#### NETWORKD NETWORK ENUMERATION SCHEME

         10-19: physical ethernet/wifi (e.g. lo0, wlo0, eth0)   # physical layer 1
         20-29: virtual ethernet/wifi                           # virtual layer 1
         40-49: bridges                                         # layer 2
         50-59: macvlans                                        # layer 2->3 (stacked)
         60-69: bonds                                           # aggregate

	
### How this integrates:

These enumeration schemes are not meant to be taken literally but more as a
range and order of devices that can be applied. The Frostbite abstraction
layer will enumerate through all devices provided by the user to it's API
then aggregate, sort, and create it's own version of this list.

