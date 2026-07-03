package main

import (
	caddycmd "github.com/caddyserver/caddy/v2/cmd"
	_ "github.com/caddyserver/caddy/v2/modules/standard"
	_ "github.com/lucanhost/caddy-tailnet" // Import our caddy-tailnet module
)

func main() {
	caddycmd.Main()
}
