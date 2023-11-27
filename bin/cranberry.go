/*
Cranberry finds console logging in your .js and .ts projects.
It uses regular expressions to find console logging, so it's not 100% accurate.

Without an explicit directory, it will search in the current directory. For
safety reasons a [pkg/flag] check is performed, so you can't run cranberry
without flags. Experience has shown that everyone will mess up every once in
a while, so, just in case that happens.

Usage:
  cranberry [flags]

Flags:
  -d, --dir string    Directory to examine (shorthand) (default ".")
  -h, --help          help for cranberry
  -r, --remove        Remove offending files (shorthand)

When cranberry reads a file, it will look for console logging. If it finds
any, it will print the file name, the line number and the line where the
offending console logging is found. If the -r flag is passed, it will remove
the offending console logging from the file.

Your configuration might not be the same as the one used to do the tests, always
have your vcs "undo" button ready.

Cranberry has been tested with the following web frameworks:

  - [Angular]
  - [React]
  - [Vue]
  - [Svelte]
  - [SolidJS]
  - [ExpressJS]

  [Angular]: https://angular.io/
  [React]: https://reactjs.org/
  [Vue]: https://vuejs.org/
  [Svelte]: https://svelte.dev/
  [SolidJS]: https://www.solidjs.com/
  [ExpressJS]: https://expressjs.com/
 */
package main

import (
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/fatih/color"
)

func main() {
	var(
		root string
		removeOffend bool
	)

	flag.StringVar(&root, "dir", ".", "Directory to examine")
	flag.StringVar(&root, "d", ".", "Directory to examine (shorthand)")
	flag.BoolVar(&removeOffend, "remove", false, "Remove offending files")
	flag.BoolVar(&removeOffend, "r", false, "Remove offending files (shorthand)")
	flag.Usage = func() {
		fmt.Printf("Usage: %s [options]\n", os.Args[0])
		fmt.Println("Options:")
		flag.PrintDefaults()
	}
	flag.Parse()

	if flag.NFlag() == 0 {
		flag.Usage()
		os.Exit(0)
	}

	incidents := 0
	skippedDirs := []string{".git", "vendor", "node_modules", "bower_components",
		"tmp", "log", "logs", "cache", "coverage", "build", "dist", "out",
		"target", "docs", "doc", "documentation"}

	err := filepath.Walk(root, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		if info.IsDir() && contains(skippedDirs, info.Name()) {
			return filepath.SkipDir
		}

		if !info.IsDir() && !strings.HasPrefix(info.Name(), ".") &&
			!strings.HasSuffix(info.Name(), ".d.ts") &&
			strings.HasSuffix(info.Name(), ".ts") {
			content, err := os.ReadFile(path)
			if err != nil {
				return err
			}

			var newContent string
			for i, line := range strings.Split(string(content), "\n") {
				if strings.Contains(line, "console.") && !strings.Contains(line, "console.error") {
					var incidentType string = ""
					switch {
					case strings.Contains(line, "console.log("):
						incidentType = "console.log()"
					case strings.Contains(line, "console.table("):
						incidentType = "console.table()"
					case strings.Contains(line, "console.info("):
						incidentType = "console.info()"
					case strings.Contains(line, "console.warn("):
						incidentType = "console.warn()"
					case strings.Contains(line, "console.debug("):
						incidentType = "console.debug()"
					}

					red := color.New(color.FgRed).SprintFunc()
					yellow := color.New(color.FgYellow).SprintFunc()
					blue := color.New(color.FgBlue).SprintFunc()

					fmt.Printf("%s in %s, line %s: %s\n", red(incidentType), yellow(path), blue(i+1), line)
					incidents += 1

					if removeOffend {
						line = strings.ReplaceAll(line, incidentType, "")
					}
				}

				newContent += line + "\n"
			}

			if removeOffend {
				if err := os.WriteFile(path, []byte(newContent), 0); err != nil {
					return err
				}
			}
		}
		return nil
	})

	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	if incidents > 0 {
		fmt.Print(strings.Repeat("-", 80))
		red := color.New(color.FgRed).SprintFunc()
		fmt.Printf("\n%s %d %s\n", red("We found"), incidents, red("incidents!"))

		if removeOffend {
			fmt.Printf("%s\n", red("Incidents have been removed!"))
			fmt.Printf("%s\n", red("WARNING! This feature is experimental, check your code for breakages!"))
		}

		os.Exit(1)
	}

	fmt.Println("No console logging was found!")
}

func contains(s []string, val string) bool {
	for _, item := range s {
		if item == val {
			return true
		}
	}
	return false
}
