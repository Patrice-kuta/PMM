# ============================================================================
#  Hausübung UE 1 — Daten visualisieren  (SA-01-datenvisualisierung-ggplot)
# ----------------------------------------------------------------------------
#  Name:   Patrice Kuta
#  Datum:  13. Oktober 2026
#  Fach:   PMM — HTL Spengergasse (4AHWIT)
# ----------------------------------------------------------------------------
#  Ausführen in RStudio:  Ctrl + Shift + S  (ganzes Skript)
#  Einzelne Zeilen:       Cursor in die Zeile, dann  Ctrl + Enter
#  Jeder Code-Block hat ein Label (#1, #2, …) und darunter die R-Ausgabe.
# ============================================================================


#1 Label: setup
# --- nur einmal pro Rechner nötig (Anführungszeichen beachten) --------------
# install.packages("tidyverse")
# install.packages("palmerpenguins")

# --- einmal pro Sitzung (ohne Anführungszeichen) ---------------------------
library(tidyverse)
library(palmerpenguins)

# Ausgabe: (keine Ausgabe, wenn die Pakete ohne Fehler geladen werden)


#2 Label: glimpse
glimpse(penguins)

# Ausgabe:
# Rows: 344
# Columns: 8
# $ species           <fct> Adelie, Adelie, Adelie, Adelie, Adelie, Adelie, …
# $ island            <fct> Torgersen, Torgersen, Torgersen, Torgersen, …
# $ bill_length_mm    <dbl> 39.1, 39.5, 40.3, NA, 36.7, 39.3, 38.9, 39.2, …
# $ bill_depth_mm     <dbl> 18.7, 17.4, 18.0, NA, 19.3, 20.6, 17.8, 19.6, …
# $ flipper_length_mm <int> 181, 186, 195, NA, 193, 190, 181, 195, 193, …
# $ body_mass_g       <int> 3750, 3800, 3250, NA, 3450, 3650, 3625, 4675, …
# $ sex               <fct> male, female, female, NA, female, male, female, …
# $ year              <int> 2007, 2007, 2007, 2007, 2007, 2007, 2007, 2007, …


#3 Label: head
head(penguins)

# Ausgabe:
# # A tibble: 6 × 8
#   species island    bill_length_mm bill_depth_mm flipper_length_mm body_mass_g
#   <fct>   <fct>              <dbl>         <dbl>             <int>       <int>
# 1 Adelie  Torgersen           39.1          18.7               181        3750
# 2 Adelie  Torgersen           39.5          17.4               186        3800
# 3 Adelie  Torgersen           40.3          18                 195        3250
# 4 Adelie  Torgersen           NA            NA                  NA          NA
# 5 Adelie  Torgersen           36.7          19.3               193        3450
# 6 Adelie  Torgersen           39.3          20.6               190        3650
# # ℹ 2 more variables: sex <fct>, year <int>


# ----------------------------------------------------------------------------
#  Antworten zu Aufgabe 1
#   Zeilen (Pinguine)? .......... 344
#   Spalten? .................... 8
#   Typ von species ............. factor (fct)
#   Typ von body_mass_g ......... integer (int)
#   Hinweis: Es gibt wenige fehlende Werte (NA), z. B. in body_mass_g.
# ----------------------------------------------------------------------------


#4 Label: ziel-plot   (Aufgabe 2 — Ziel-Bild aus der Stunde)
ggplot(penguins,
       aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point() +
  labs(x = "Flossengröße (mm)", y = "Körpermasse (g)",
       title = "Lange Flosse, schwerer Körper")

# Ausgabe: Grafik im Plots-Pane — Streudiagramm, drei Farben + Legende.
#
# Antworten zu Aufgabe 2:
#   Steigt die Körpermasse mit der Flossengröße für alle drei Arten? ---> JA.
#     (Korrelation Flossengröße/Masse ≈ 0.87; alle drei Punktewolken steigen.)
#   Am schwersten: ---> GENTOO
#     (Ø-Masse: Gentoo ≈ 5076 g, Chinstrap ≈ 3733 g, Adélie ≈ 3701 g.)


#5 Label: farbe-fest-vs-gemappt   (Aufgabe 3a)

# Variante A — color = "red"  -> Einstellung (Deko), keine Information:
ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_point(color = "red")

# Variante B — color = species -> Mapping, Spalte wird zur Farbe + Legende:
ggplot(penguins, aes(x = species, y = body_mass_g, color = species)) +
  geom_point()

# Ausgabe: zwei Grafiken im Plots-Pane.
#
# Vorhersage:
#   Bei A sind ALLE Punkte rot und es gibt KEINE Legende (Art nur an der
#   x-Achse erkennbar). Bei B hat jede Art ihre eigene Farbe und es entsteht
#   automatisch eine Legende. Die Position der Punkte ist gleich.
#
# R-Ergebnis (ausgeführt, verglichen):
#   Genau so. -> "red" ist Deko/Einstellung, "species" ist Information/Mapping.


#6 Label: plus-am-zeilenanfang   (Aufgabe 3b)

# So gehört es NICHT (das "+" muss ans Zeilenende):
#
#   ggplot(penguins, aes(x = body_mass_g))
#     + geom_histogram(binwidth = 250)
#
# Vorhersage:
#   R liest zeilenweise. Die erste Zeile ist für sich schon VOLLSTÄNDIG und
#   wird sofort ausgeführt (leeres Koordinatensystem). Das "+" am Anfang der
#   nächsten Zeile ist dann ein eigenständiges (unäres) Plus -> Fehler.
#
# R-Ergebnis: Fehlermeldung
#   Error: Cannot use `+` with a single argument.
#   ℹ Did you accidentally put `+` on a new line?
#
# Hier bewusst provoziert, damit das Skript weiterläuft:
tryCatch(
  {
    ggplot(penguins, aes(x = body_mass_g))
    + geom_histogram(binwidth = 250)
  },
  error = function(e) cat("\n>> R-Fehlermeldung:", conditionMessage(e), "\n")
)


#7 Label: eigene-frage   (Aufgabe 4 — Streudiagramm + geom_smooth + labs)
ggplot(penguins,
       aes(x = bill_length_mm, y = body_mass_g, color = species)) +
  geom_point() +
  geom_smooth(se = FALSE) +
  labs(x = "Schnabellänge (mm)", y = "Körpermasse (g)",
       title = "Längere Schnäbel, schwerere Pinguine?",
       color = "Art")

# Ausgabe: Grafik im Plots-Pane + Konsolen-Hinweis
#   `geom_smooth()` using method = 'loess' and formula = 'y ~ x'
#
#   Meine Frage (1 Satz):
#     Hängt die Schnabellänge mit der Körpermasse zusammen — und trennt diese
#     Beziehung die drei Pinguinarten voneinander?
#
#   Was zeigt der Plot? (2 Sätze):
#     Insgesamt gilt: je länger der Schnabel, desto schwerer der Pinguin
#     (Korrelation ≈ 0.60). Mit Farbe je Art liegen die Punkte in drei
#     getrennten Gruppen — Gentoo ist klar am schwersten und hat den längsten
#     Schnabel; Adélie und Chinstrap liegen tiefer und sind leichter.


#8 Label: kapitel-check   (Aufgabe 5 — R4DS Kap. 2: Workflow: basics)

# Frage 1: Warum steht das "+" in ggplot2 immer am Zeilenende — und was passiert
# technisch, wenn es am Zeilenanfang steht? Wie meldet sich R?
#   R wertet Code Zeile für Zeile aus und führt eine Zeile nur aus, wenn sie
#   VOLLSTÄNDIG ist. Ein "+" am Zeilenende macht den Ausdruck "unvollständig"
#   -> R wartet auf die nächste Zeile und verkettet die Schichten. Steht das "+"
#   am Zeilenanfang, ist die vorige Zeile bereits fertig und wird ausgeführt;
#   das "+" beginnt einen neuen Ausdruck und wird als unäres Plus gelesen.
#   R meldet: "Cannot use `+` with a single argument." — mit dem Hinweis
#   "Did you accidentally put `+` on a new line?".

# Frage 2: Warum speichert man Werte mit "<-" im Skript, statt sie in der Konsole
# direkt auszurechnen?
#   Mit "<-" bekommt ein Wert einen Namen und bleibt gespeichert. Dadurch ist das
#   Skript jederzeit wiederholbar (reproduzierbar), man kann später mit dem Wert
#   weiterrechnen und man kann nachvollziehen, wie ein Ergebnis entstanden ist
#   (Labortagebuch). Was man nur in der Konsole eintippt, ist nach dem nächsten
#   Befehl oft wieder weg und nicht belegt.

# ============================================================================
#  Ende der Hausübung — Patrice Kuta, 13. Oktober 2026
# ============================================================================
