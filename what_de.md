# Code-Analyse der Simulationsdateien

In dieser Analyse werden zwei zentrale Dateien des Simulationssystems untersucht: **market_simulation.py** und **master_state.py**. Beide Dateien sind Teil einer größeren Anwendung, in der noch weitere Module verwendet werden (z. B. Person, Project, Product, Company). Hier liegt der Fokus auf der Markt- und Zustandslogik.

---

## 1. market_simulation.py citeturn0file0

### Überblick
Die Klasse `MarketSimulation` simuliert Marktdynamiken. Sie verwaltet den aktuellen Markttrend, passt Absatzwerte basierend auf diesem Trend an und generiert neue Bewerber sowie Projekte, um das Geschäftsumfeld realitätsnah abzubilden.

### Zentrale Bestandteile

- **Initialisierung (`__init__`)**  
  - Setzt den anfänglichen Markttrend auf `1.0`.

- **Trendaktualisierung (`update_trend`)**  
  - Aktualisiert den Markttrend anhand der aktuellen Zeit.
  - Der Trend wird berechnet als `1.0 - ((time % 10) * 0.05)` mit einer zufälligen Abweichung von `-0.05` bis `0.05`, was kurzfristige Schwankungen simuliert.

- **Trendabfrage (`get_trend`)**  
  - Gibt den aktuellen Markttrend zurück.

- **Absatzanpassung (`adjust_sales`)**  
  - Passt einen Basisabsatzwert an, indem er mit dem aktuellen Markttrend multipliziert wird.
  - Das Ergebnis wird als ganze Zahl zurückgegeben.

- **Generierung von Bewerbern (`generate_applicants`)**  
  - Erzeugt eine Liste neuer Bewerber basierend auf dem Karma des Unternehmens, der Dauer und übergebenen Namenslisten.
  - Die Anzahl der generierten Bewerber wird durch einen Zufallsfaktor und die Dauer beeinflusst.
  - Jeder Bewerber erhält zufällig bestimmte Attribute wie Geldbetrag und Fähigkeiten.

- **Generierung von Projekten (`generate_projects`)**  
  - Ähnlich wie bei der Bewerbererzeugung werden hier neue Projekte generiert.
  - Die Anzahl der Projekte hängt von einem Zufallsfaktor, der Dauer und dem Karma des Unternehmens ab.
  - Der Umfang eines jeden Projekts wird zufällig bestimmt und anschließend mit dem aktuellen Markttrend skaliert.

---

## 2. master_state.py citeturn0file1

### Überblick
Die Klasse `MasterState` fungiert als zentrale Steuerung des Simulationsablaufs. Sie verwaltet den Gesamtzustand der Simulation, inklusive Zeitverlauf, Unternehmensdaten, Mitarbeiter- und Projektmanagement sowie marktrelevanten Aktivitäten.

### Zentrale Bestandteile

- **Initialisierung und Zustandsaufbau**  
  - **Attribute:**  
    - `time`: Verfolgt die Simulationszeit (vermutlich in Tagen).
    - `company`: Repräsentiert den Zustand des Unternehmens (wird mit einem Namen, Geldbetrag und Karma initialisiert).
    - `applicants` und `projects_pool`: Listen, in denen potenzielle neue Mitarbeiter und Projekte gespeichert werden.
    - `first_names` und `last_names`: Vorgegebene Namenslisten zur Generierung von Bewerbern.
    - `market`: Eine Instanz von `MarketSimulation`, die die Marktdynamik simuliert.
    - Temporäre Maßnahmen (`motivation_measure`, `sales_measure` und `sales_measure_duration`) für dynamische Anpassungen im Simulationsverlauf.
  
  - **start_init Methode:**  
    - Setzt die Simulationszeit und den Unternehmenszustand zurück.
    - Leert vorhandene Listen für Bewerber, Projekte und weitere unternehmensbezogene Daten.
    - Aktualisiert den Markttrend und passt die Pools für Bewerber und Projekte an.
    - Fügt einen CEO (mit einer speziellen Kennung) als Mitarbeiter hinzu.
    - Lässt die Simulation um eine bestimmte Anzahl an Tagen fortschreiten, um den Simulationszyklus zu starten.

- **Anpassung der Pools (`adjust_pools`)**  
  - Stellt sicher, dass die Projekt- und Bewerber-Pools mindestens eine gewisse Anzahl an Einträgen basierend auf dem Unternehmenskarma enthalten.
  - Ruft dazu die Methoden `generate_projects` und `generate_applicants` aus der `MarketSimulation` auf.

- **Zeitfortschritt (`advance_time`)**  
  - Erhöht die Simulationszeit um eine bestimmte Anzahl von Tagen.
  - Aktualisiert den Markttrend.
  - Bearbeitet laufende Projekte:
    - Überprüft, ob genügend qualifizierte Mitarbeiter vorhanden sind, um die Anforderungen eines Projekts zu erfüllen.
    - Reduziert den Projektumfang basierend auf der Mitarbeitermotivation.
    - Schließt Projekte ab, sobald deren Umfang auf Null sinkt, und verarbeitet verschiedene Projekttypen (z. B. Bugfixes oder neue Versionen) sowie die Fertigstellung von Produkten.
  - Veranlasst zufällige und feste Kosten, die den Geldbetrag des Unternehmens beeinflussen.
  - Aktualisiert das Alter von Projekten und Bewerbern und entfernt veraltete Einträge.
  - Verwaltet die Dynamik der Mitarbeiter:
    - Erhöht die Beschäftigungsdauer.
    - Aktualisiert periodisch die Motivation; Mitarbeiter werden entfernt, wenn diese zu niedrig ist.
  - Passt die Details der Produkte an:
    - Aktualisiert Alter und Wartungszähler.
    - Löst Wartungsmaßnahmen (Bugfix oder neue Version) aus, wenn bestimmte Schwellenwerte erreicht werden.
  - Verwaltet temporäre Absatzmaßnahmen und passt am Ende des Zeitabschnitts die Pools erneut an.

- **Softwareverkauf (`sell_software`)**  
  - Simuliert den Verkauf fertiger Produkte.
  - Ermittelt den Basisabsatz zufällig und berücksichtigt temporäre Absatzmaßnahmen.
  - Passt die Verkaufszahlen der Produkte an den aktuellen Markttrend an und erhöht den Geldbetrag des Unternehmens entsprechend.

- **Statusanzeige und Baumansichten**  
  - **show_status:**  
    - Erstellt eine mehrzeilige Zeichenkette, die den aktuellen Simulationszustand zusammenfasst (Mitarbeiter, Projekte, fertige Produkte, Markttrend usw.).
  - **Baumansichtsmethoden:**  
    - `get_tree_view_software` und `get_tree_view_software_to_write` bereiten Daten in einer strukturierten Listenform (bestehend aus Dictionaries) auf, um Produkt- und Projektdetails in einer Baumstruktur anzuzeigen.

- **Serialisierung des Zustands**  
  - **to_dict:** Wandelt den aktuellen Simulationszustand in ein Dictionary um, was beispielsweise zum Speichern des Zustands dient.
  - **load_from_dict:** Stellt den Simulationszustand aus einem gegebenen Dictionary wieder her und initialisiert dabei Unternehmen, Mitarbeiter, Projekte und weitere Elemente neu.

---

## 3. Integration und Gesamtfunktionalität

- **Simulationsablauf:**  
  Das System simuliert realistische Geschäftsdynamiken, indem `MasterState` als Orchestrator fungiert. Die Integration der `MarketSimulation` ermöglicht es, Marktschwankungen und Zufallseinflüsse in Bereiche wie Einstellung, Projektmanagement, Produktentwicklung und Verkauf einzubinden.

- **Modulare Struktur:**  
  Obwohl die hier analysierten Dateien zentrale Logiken enthalten, werden sie durch zusätzliche Module (z. B. Person, Project, Product, Company) ergänzt. Diese modulare Herangehensweise sorgt für eine klare Trennung der Verantwortlichkeiten, während `MasterState` die einzelnen Komponenten in einem kohärenten Simulationssystem vereint.

- **Zufall und Dynamik:**  
  Beide Dateien nutzen Zufallsfaktoren intensiv, um unvorhersehbare Marktsituationen und menschliches Verhalten (z. B. bei der Generierung von Bewerbern oder der Anpassung von Projektumfängen) realistisch abzubilden. Dies führt zu einem dynamischen und sich ständig verändernden Simulationsumfeld.

---

Diese Analyse zeigt, wie das Simulationssystem durch die Wechselwirkung von Marktdynamiken und Unternehmenszustandsverwaltung ein realistisches, interaktives Modell wirtschaftlicher Prozesse erzeugt.
