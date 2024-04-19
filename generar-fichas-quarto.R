# Generador de las fichas de las asignaturas del grado
# Autor: Alfredo Sánchez Alberca (asalber@ceu.es)

# Librerías
library(tidyverse)
library(quarto)

# Carga de datos
asignaturas <- read_csv("datos/asignaturas.csv", col_types = "c")
contenidos <- read_csv("datos/contenidos.csv")
resultados <- read_csv("datos/resultados-aprendizaje.csv")
competencias <-  read_csv("datos/competencias.csv")
competencias <- read_csv("datos/matriz-competencias.csv") %>%
  pivot_longer(-c(Código, Asignatura), names_to = "Id", values_to = "valor") %>%
  left_join(competencias)
evaluacion.descripcion <- read_csv("datos/sistemas-evaluacion-descripcion.csv")
evaluacion <- read_csv("datos/sistemas-evaluacion.csv", col_types = "ccccccccc") %>%
  pivot_longer(-c(Código, Asignatura), names_to = "Id", values_to = "Peso") %>%
  left_join(evaluacion.descripcion)
actividades.descripcion <- read_csv("datos/actividades-formativas-descripcion.csv")
actividades <- read_csv("datos/actividades-formativas.csv") %>%
  pivot_longer(-c(Código, Asignatura, ECTS), names_to = "Id", values_to = "Horas") %>%
  left_join(actividades.descripcion)

for (codigo in asignaturas$Código) {
  asignatura <- asignaturas %>% filter(Código == codigo)
  file_name <- paste0(gsub(" ", "-", tolower(asignatura$Asignatura)), ".html")
  quarto_render("asignaturas/plantilla-asignatura.qmd",
                output_file = file_name,
                    execute_params = list(
                      codigo = codigo, 
                      asignatura = asignatura, 
                      competencias = competencias,
                      resultados = resultados,
                      contenidos = contenidos,
                      actividades = actividades,
                      evaluacion = evaluacion
                      ))
  file.copy(from = file_name, to = paste0("asignaturas/", file_name))
  file.remove(file_name)
}
