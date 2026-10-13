# ============================================================================
#  Hausübung UE 1 — Daten visualisieren  (SA-01-datenvisualisierung-ggplot)
# ----------------------------------------------------------------------------
#  Name:   Patrice Kuta
#  Datum:  13. Oktober 2026
#  Fach:   PMM — HTL Spengergasse (4AHWIT)
# ----------------------------------------------------------------------------
#  Ausführen in RStudio:  Ctrl + Shift + S  (ganzes Skript)
#  Einzelne Zeilen:       Cursor in die Zeile, dann  Ctrl + Enter
#  Dieses Skript ist mein "Labortagebuch": lesbar, wiederholbar, startbar.
# ============================================================================


# ============================================================================
#  1. Setup + erstes Ritual
# ============================================================================

# Einmal pro Rechner nötig (nur falls die Pakete noch fehlen — Anführungszeichen!):
# install.packages(c("tidyverse", "palmerpenguins"))

# Einmal pro Sitzung: Pakete laden (ohne Anführungszeichen!)
library(tidyverse)
library(palmerpenguins)

# Regel Nr. 1: Neue Daten? ZUERST anschauen, dann nutzen.
glimpse(penguins)
head(penguins)

# --- Antworten zu Aufgabe 1 -------------------------------------------------
#   Zeilen (Pinguine)? .......... 344
#   Spalten? .................... 8
#   Typ von species ............. factor  (fct)
#   Typ von body_mass_g ......... integer (int)
#   Hinweis: Es gibt wenige fehlende Werte (NA), z. B. in body_mass_g.


# ============================================================================
#  2. Die Einstiegsfrage nachbauen (Ziel-Bild aus der Stunde)
# ============================================================================

ggplot(penguins,
       aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point() +
  labs(x = "Flossengröße (mm)", y = "Körpermasse (g)",
       title = "Lange Flosse, schwerer Körper")

# --- Antworten zu Aufgabe 2 -------------------------------------------------
#   Steigt die Körpermasse mit der Flossengröße für alle drei Arten? ---> JA.
#     (Korrelation Flossengröße/Masse ≈ 0.87 — deutlich positiv, und die
#      drei Punktewolken steigen alle nach rechts oben.)
#   Am schwersten: ---> GENTOO
#     (Ø-Masse: Gentoo ≈ 5076 g, Chinstrap ≈ 3733 g, Adélie ≈ 3701 g.)


# ============================================================================
#  3. Vorhersagen  (erst hinschreiben, dann ausführen und vergleichen)
# ============================================================================

# --- 3a) Farbe FESTGENAGELT ("red")  vs.  Farbe GEMAPPT (color = species) ---

# Variante A: color = "red"  -> Einstellung (Deko), keine Information
ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_point(color = "red")

# Variante B: color = species -> Mapping, Spalte wird zur Farbe + Legende
ggplot(penguins, aes(x = species, y = body_mass_g, color = species)) +
  geom_point()

#   Vorhersage:
#     Beide Plots zeigen die Körpermasse je Art. Bei A sind ALLE Punkte rot
#     und es gibt KEINE Legende; die Art erkennt man nur an der x-Achse.
#     Bei B hat jede Art ihre eigene Farbe und es entsteht automatisch eine
#     Legende. Die Position der Punkte ist in beiden Plots gleich.
#
#   R-Ergebnis (ausgeführt, verglichen):
#     Genau so. A = nur rote Punkte, keine Legende. B = drei Farben + Legende
#     (Adélie/Chinstrap/Gentoo). -> "red" ist Deko, "species" ist Information.


# --- 3b) Was passiert, wenn das "+" am ZEILENANFANG steht? -------------------

#   So gehört es NICHT (das "+" muss ans Zeilenende):
#
#     ggplot(penguins, aes(x = body_mass_g))
#       + geom_histogram(binwidth = 250)
#
#   Vorhersage:
#     R liest zeilenweise. Die erste Zeile ist für sich schon VOLLSTÄNDIG und
#     wird sofort ausgeführt (leeres Koordinatensystem). Das "+" am Anfang der
#     nächsten Zeile ist dann ein eigenständiges (unäres) Plus -> Fehler.
#
#   R-Ergebnis: Fehlermeldung
#     Error: Cannot use `+` with a single argument.
#     ℹ Did you accidentally put `+` on a new line?
#
#   Hier bewusst provoziert, damit das Skript trotzdem weiterläuft:

tryCatch(
  {
    ggplot(penguins, aes(x = body_mass_g))
    + geom_histogram(binwidth = 250)
  },
  error = function(e) cat("\n>> R-Fehlermeldung:", conditionMessage(e), "\n")
)


# ============================================================================
#  4. Eine eigene Frage finden  (Streudiagramm + geom_smooth + labs)
# ============================================================================

#   Meine Frage:
#     Hängt die Schnabellänge mit der Körpermasse zusammen — und trennt
#     diese Beziehung die drei Pinguinarten voneinander?

ggplot(penguins,
       aes(x = bill_length_mm, y = body_mass_g, color = species)) +
  geom_point() +
  geom_smooth(se = FALSE) +
  labs(x = "Schnabellänge (mm)", y = "Körpermasse (g)",
       title = "Längere Schnäbel, schwerere Pinguine?",
       color = "Art")

#   Was zeigt der Plot? (2 Sätze)
#     Insgesamt gilt: je länger der Schnabel, desto schwerer der Pinguin
#     (Korrelation ≈ 0.60). Mit Farbe je Art sieht man, dass die Punkte in
#     drei getrennten Gruppen liegen — Gentoo (violette Linie) ist klar am
#     schwersten und hat den längsten Schnabel; Adélie und Chinstrap liegen
#     tiefer und sind leichter.

#   Zweite sinnvolle Zahlen-Kombination (zur Auswahl):
#     Flossengröße vs. Schnabel-Tiefe — zeigt ebenfalls drei getrennte Arten.


# ============================================================================
#  5. Kapitel-Check  (Kap. 2 — Workflow: basics)
# ============================================================================

#   Frage 1: Warum steht das "+" in ggplot2 immer am Zeilenende — und was
#   passiert technisch, wenn es am Zeilenanfang steht? Wie meldet sich R?
#     R wertet Code Zeile für Zeile aus und führt eine Zeile nur aus, wenn sie
#     VOLLSTÄNDIG ist. Ein "+" am Zeilenende macht den Ausdruck "unvollständig"
#     -> R weiß: "es kommt noch etwas" und wartet auf die nächste Zeile; die
#     Schichten werden so zu einer Kette verbunden. Steht das "+" dagegen am
#     Zeilenanfang, ist die vorige Zeile bereits fertig und wird ausgeführt;
#     das "+" beginnt einen neuen Ausdruck und wird als unäres Plus gelesen.
#     R meldet dann: "Cannot use `+` with a single argument." — mit dem Tipp
#     "Did you accidentally put `+` on a new line?".

#   Frage 2: Warum speichert man Werte mit "<-" im Skript, statt sie in der
#   Konsole direkt auszurechnen?
#     Mit "<-" bekommt ein Wert einen Namen und bleibt gespeichert. Dadurch ist
#     das Skript jederzeit von oben bis unten wiederholbar (reproduzierbar), man
#     kann später mit dem Wert weiterrechnen und man kann nachvollziehen, wie
#     ein Ergebnis entstanden ist (Labortagebuch). Was man nur in der Konsole
#     eintippt, ist nach dem nächsten Befehl oft wieder weg und nicht belegt.

# ============================================================================
#  Ende der Hausübung — Patrice Kuta, 13. Oktober 2026
# ============================================================================
