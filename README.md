# GTA1-MAX Multiplayer in Docker Containers

## Introduction

The multiplayer mode of games like the 2D GTA series (GTA1, GTA London, GTA2) don't work well over the Internet (with VPN to mimic LAN play).
The main problem is, that the players and NPCs (cars and pedestrians) need to be synchronized between all the clients
and even little latency slows the whole game down. 
A friend came up with the idea to put the game instances in containers to eliminate the latency issue 
and stream it to the players via remote play to the browser.

Thanks to the fabulous docker image from [LinuxServer.io](https://www.linuxserver.io/)
([docker-dosbox-staging](https://github.com/linuxserver/docker-dosbox-staging))
and cool projects like [Selkies](https://selkies-project.github.io/selkies/) 
and [DOSBox Staging](https://www.dosbox-staging.org/)
this was pretty easy to achieve.

Props to the [GTA 1/GTA 2 Direct IP multiplayer guide](https://gtaforums.com/topic/982736-gta-1gta-2-direct-ip-multiplayer-guide/).
It gave me the solution to another problem (GTA London crashing, when IPX networking is enabled).

## Setup

Clone this repository with `git clone https://github.com/unverbuggt/gtamax-docker.git`

Check the `README.md` in `game/` on how to optain and extract GTA1-MAX.

Edit `docker-compose.yaml` to your needs.
The `environment` section is currently configured for GPU accellerated h264 encoding (I use amdgpu)
and limits the resolution and bitrate to fit my Internet bandwidth.
Visit the documentation of [linuxserver/dosbox-staging](https://docs.linuxserver.io/images/docker-dosbox-staging/) for full reference.

Start the containers with `source start_gtamax`, it sets the UID and GID for file system access.

The four containers expose port 3001/3002/3003/3004 (https with self signed certificate) and port 3011/3012/3013/3014 (http).
The browser clients should always connect via https, as some features like hardware accellerated video decoding won't work otherwise.

I use the http ports and `SUBFOLDER` env variables for these containers as I want to proxy them to the Internet (https)
via nginx reverse proxy like this:

```
...
        location /gtamax1/ {
                # WebSocket support (nginx 1.4)
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "Upgrade";
                proxy_read_timeout 86400;

                proxy_pass http://[IP with the running containers]:3011;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forward-Proto $scheme;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                auth_basic "GTA-MAX";
                auth_basic_user_file /var/www/gtamax-htpasswd;
        }
        location /gtamax2/ {
                # WebSocket support (nginx 1.4)
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "Upgrade";
                proxy_read_timeout 86400;

                proxy_pass http://[IP with the running containers]:3012;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forward-Proto $scheme;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                auth_basic "GTA-MAX";
                auth_basic_user_file /var/www/gtamax-htpasswd;
        }
and so forth...
```


## Game

Connect to the docker containers via a modern web browser:

- `https://[IP with the running containers]:3001/gtamax1/`
- `https://[IP with the running containers]:3002/gtamax2/`
- `https://[IP with the running containers]:3003/gtamax3/`
- `https://[IP with the running containers]:3004/gtamax4/`

I modified the original batch script of GTA1-MAX in a way that only the three games can be started
in normal mode (not glide) and the readme can be viewed. 
Sadly now the numbers shown in the "Make a choice" aren't right anymore.
If you want to play around with it, be sure to never execute the `GTA8*.EXE` files, 
as they will break GTA London '61.

GTA London 1961 offers the most advanced multiplayer experience (extra multiplayer map and drive-by shooing) imho.
But all three (GTA1 with its three cities, GTA London 1969, 1961) can be played.

- Make a choice to start a game: Press 3, 1 to start London 61.
- If you want drive-by shooting, select "Play" and press enter.
    - Press the R key and change the name to "driveby".
    - Press R again to rename to your liking or press Del key to revert to the initial name.
    - Press ESC to go back to the main menu
    - Every player needs to do this every time the game was restarted...
- One play needs to select "Gather Network" and press enter.
    - Select Player and press enter (optionally change name with Del).
    - Select "Deathmatch" and press enter.
    - Check multiplayer options and press enter.
    - "IPX Gather" is displayed. If at least one player joined, then the game can be started.
- The other players need to select "Join Network"
    - Select Player and press enter (optionally change name with Del).
    - "Status: Found Gatherer" is displayed.
    - Wait for the gatherer to start the game (Game will automatically start if four players joined).



