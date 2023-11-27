package main

import (
	"context"
	"fmt"
	"os"

	"github.com/docker/docker/api/types"
	"github.com/docker/docker/client"
)

func main() {
	// Create a new docker client
	cli, err := client.NewClientWithOpts(client.FromEnv)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error creating Docker client: %v\n", err)
		os.Exit(1)
	}

	// Get all the currently running containers
	containers, err := cli.ContainerList(context.Background(), types.ContainerListOptions{})
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error getting container list: %v\n", err)
		os.Exit(1)
	}

	for _, container := range containers {
		state := "⬤"
		if container.State == "running" {
			state = "\033[32m⬤\033[0m" // Green if it's running
		} else if container.State == "exited" {
			state = "\033[31m⬤\033[0m" // Red if it's not running
		} else {
			state = "\033[33m⬤\033[0m"
		}

		fmt.Printf("%s %s\n", container.ID[:12], state)


		logs, err := cli.ContainerLogs(context.Background(), container.ID, types.ContainerLogsOptions{
			ShowStdout: true,
			ShowStderr: true,
		})

		if err != nil {
			fmt.Fprintf(os.Stderr, "Error getting container %s logs: %v\n", container.ID, err)
			continue
		}

		_, err = fmt.Print("Logs del contenedor: ")
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error printing logs of container %s: %v\n", container.ID, err)
			continue
		}

		_, err = io.Copy(os.Stdout, logs)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error printing logs of container %s: %v\n", container.ID, err)
			os.Exit(1)
		}

		fmt.Println()
	}
}
