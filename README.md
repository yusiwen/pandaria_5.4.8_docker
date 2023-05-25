# Pandaria 5.4.8 docker

## Run  

Tested on Ubuntu 22.10, docker 24.0.1

Edit `env/mariadb.env`, change the value of `REALM_ADDRESS` to your client's real address.

```bash
git clone https://github.com/yusiwen/pandaria_5.4.8_docker
cd pandaria_5.4.8_docker
docker compose up -d && docker compose logs -f
```

Use 'telnet localhost 3443' with `admin`:`admin` to login worldserver. Or you can use `docker attach pandaria-worldserver` to attach to worldserver.

After login, use `account create <USER> <PASSWORD>` to create a new user.

If you want that user to be a GM, use `account set gmlevel testuser1 3 -1`.

## Compile and build images

```bash
git clone https://github.com/yusiwen/pandaria_5.4.8_docker
cd pandaria_5.4.8_docker
```

Place `Data.zip`(Download [here](https://mega.nz/file/EAZUmZiD#PxdHN7jcEKCA8qaIBTIWLWLGZcT5PdsKfIgkygTZgTs)) in `dist/` directory

```bash
# compile binaries and generate default configurations
docker compose up --build compile && docker compose down

# build other images
docker compose build
```
