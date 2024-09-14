package main

import (
	"bytes"
	"flag"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"time"

	"github.com/fatih/color"
	"github.com/json-iterator/go"
)

// This function should return a JWT token based in the username and password.
func getJWToken(username, password, authURL string) (string, error) {
	data := map[string]string{"username": username, "password": password}
	jsonData, err := jsoniter.Marshal(data)

	if err != nil {
		return "", fmt.Errorf("Error al convertir los datos a JSON: %v", err)
	}

	resp, err := http.Post(authURL, "application/json", bytes.NewBuffer(jsonData))

	if err != nil {
		return "", fmt.Errorf("Error al hacer la petición HTTP: %v", err)
	}

	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)

	if err != nil {
		return "", fmt.Errorf("Error al leer el cuerpo de la respuesta HTTP: %v", err)
	}

	return string(body), nil
}

func main() {
	var (
		URL string // URL to be tested (Flag)
		OutputFile string // Output file (Flag)
		Username string // Username (Optional Flag)
		Password string // Password (Optional Flag)
		AuthURL string // URL to get the JWT token (Optional Flag)
		JSONData jsoniter.Any // JSON data
		httpClient http.Client // HTTP client
	)

	flag.StringVar(&URL, "url", "https://localhost:8080/", "URL to be tested")
	flag.StringVar(&OutputFile, "output", "output.json", "Output file")
	flag.StringVar(&Username, "username", "", "Username (if needed for authentication)")
	flag.StringVar(&Password, "password", "", "Password (if needed for authentication)")
	flag.StringVar(&AuthURL, "authurl", "", "Authentication URL (if JWT is needed)")


	flag.Usage = func() {
		fmt.Printf("Usage: %s [options]\n", os.Args[0])
		fmt.Printf("Example: %s -url http://api.example.com/getData/1 output.json\n", os.Args[0])
		flag.PrintDefaults()
		fmt.Println("Please report bugs at: omar@laesquinagris.com")
	}

	flag.Parse()

	var jwtToken string
	if Username != "" && Password != "" && AuthURL != "" {
		var err error
		jwtToken, err = getJWToken(Username, Password, AuthURL)
		if err != nil {
			color.Red("Error al obtener el JWT token: %v", err)
			os.Exit(1)
		}
	}

	startTime := time.Now()

	req, err := http.NewRequest("GET", URL, nil)
	if err != nil {
		color.Red("Error al crear la petición HTTP: %v", err)
		os.Exit(1)
	}

	if jwtToken != "" {
		req.Header.Add("Authorization", "Bearer " + jwtToken)
	}

	// Realizar petición HTTP y obtener respuesta.
	resp, err := httpClient.Do(req)
	if err != nil {
		color.Red("Error al hacer la petición HTTP: %v", err)
		os.Exit(1)
	}
	defer resp.Body.Close()

	duration := time.Since(startTime)

	// Leer cuerpo de la respuesta HTTP y convertirlo a JSON.
	body, err := ioutil.ReadAll(resp.Body)

	if err != nil {
		fmt.Println("Error al leer el cuerpo de la respuesta HTTP:", err)
		os.Exit(1)
	}

	if err := jsoniter.Unmarshal(body, &JSONData); err != nil {
		color.Red("Error al convertir el cuerpo de la respuesta HTTP a JSON: %v", err)
		os.Exit(1)
	}

	// Guardar el JSON en un archivo si es necesario.
	if err := ioutil.WriteFile(OutputFile, body, 0644); err != nil {
		color.Red("Error al guardar el JSON en el archivo: %v", err)
		os.Exit(1)
	}

	jsonString, err := jsoniter.MarshalIndent(JSONData, "", "  ")
	if err != nil {
		color.Red("Error al imprimir el JSON: %v", err)
		os.Exit(1)
	}

	color.Green("Estadísticas de respuesta:")
	fmt.Printf("Duración: %v\n", duration)
	fmt.Printf("Código de salida: %v\n", resp.StatusCode)
	fmt.Printf("Tamaño de la respuesta: %v bytes\n", len(body))
	fmt.Printf("JSON guardado en: %v\n", OutputFile)
	fmt.Println("Cuerpo de la respuesta:")
	fmt.Println(string(jsonString))
}
