# Generador de las fichas de las asignaturas del grado
# Autor: Alfredo Sánchez Alberca (asalber@ceu.es)

# Librerías
library(tidyverse)

# Carga de datos
asignaturas <- read_csv("datos/asignaturas.csv", col_types = "c")
contenidos <- read_csv("datos/contenidos.csv")
resultados <- read_csv("datos/resultados-aprendizaje.csv")
competencias <-  read_csv("datos/competencias.csv")
competencias <- read_csv("datos/matriz-competencias.csv") %>%
  pivot_longer(-c(Código, Asignatura), names_to = "Id", values_to = "valor") %>%
  left_join(competencias)
evaluacion.descripcion <- read_csv("datos/sistemas-evaluacion-descripcion.csv")
sistemas.evaluacion <- read_csv("datos/sistemas-evaluacion.csv", col_types = "ccccccccc") %>%
  pivot_longer(-c(Código, Asignatura), names_to = "Id", values_to = "Peso") %>%
  left_join(evaluacion.descripcion)
actividades.descripcion <- read_csv("datos/actividades-formativas-descripcion.csv")
actividades <- read_csv("datos/actividades-formativas.csv") %>%
  pivot_longer(-c(Código, Asignatura, ECTS), names_to = "Id", values_to = "Horas") %>%
  left_join(actividades.descripcion)

for (i in asignaturas$Código) {
  asignatura <- asignaturas %>% filter(Código == i)
  rmarkdown::render("plantilla-asignatura.Rmd",
                    output_file =  paste0(asignatura$Asignatura, ".html"),
                    output_dir = 'asignaturas')
}
  

