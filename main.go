package main

import (
	"fmt"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
)

func main() {
	s := gin.Default()

	// Servir les fichiers statiques (CSS, JS, images, etc.)
	s.Static("/static", "./static")

	// Charger les templates HTML
	s.LoadHTMLGlob("template/*")

	// Route pour la page d'accueil
	s.GET("/", func(c *gin.Context) {
		c.HTML(http.StatusOK, "index.html", gin.H{})
	})

	fmt.Println("Serveur démarré sur http://localhost:8080")
	port := "3000"
	host := "0.0.0.0"

	if err := s.Run(host + ":" + port); err != nil {
		fmt.Printf("Erreur lors du démarrage du serveur : %v", err)
	}

	fmt.Println("Hello, World!")
	fmt.Println("john")
}

// utiliser pour recuperer une string entre des backtick
func extractStringInBacktick(s string) string {
	start := strings.Index(s, "`")
	end := strings.LastIndex(s, "`")

	if start == -1 || end == -1 || start == end {
		return ""
	}

	return s[start+1 : end]
}
