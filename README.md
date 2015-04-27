# Yeah, mean dev-machine


It builds an Ubuntu 14.04 box and installs stuff required by my [DotFiles](https://github.com/lukaszkorecki/DotFiles)


## How to?

- [Install Vagrant](https://vagrantup.com)
- `vagrant up`


# What?

When `vagrant up` is run Vagrant will boot two machines:

- **default** - with all development stuff like Vim, Ruby 2.2, Golang, Python
- **storage** - with Elasticsearch 1.4, PG 9.4 and RabbitMQ


See `boostrap*` files for more details

# Licence

MIT
