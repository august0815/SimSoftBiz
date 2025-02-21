mit KI-Hilfe

# Software Business Simulator

Ein Simulationsprojekt, das wirtschaftliche Prozesse in einem dynamischen Marktumfeld realitätsnah abbildet. Das Projekt modelliert Unternehmensaktivitäten, Mitarbeitergewinnung, Projektmanagement, Produktentwicklung und Verkauf, indem es Marktdynamiken sowie zufällige Ereignisse integriert.

## Inhaltsverzeichnis

- [Überblick](#überblick)
- [Projektstruktur](#projektstruktur)
- [Wichtige Module](#wichtige-module)
  - [MarketSimulation](#marketsimulation)
  - [Company](#company)
- [Installation](#installation)
- [Verwendung](#verwendung)
- [Beitrag leisten](#beitrag-leisten)
- [Lizenz](#lizenz)

## Überblick

Der Software Business Simulator bildet ein Unternehmen in einem variablen Marktumfeld ab. Die Simulation umfasst:

- **Marktdynamik:** Anpassung des Markttrends basierend auf der Zeit und zufälligen Schwankungen.
- **Geschäftsprozesse:** Dynamische Anpassung von Absatzzahlen, Generierung von Bewerbern und Projekten.
- **Unternehmensverwaltung:** Verwaltung von Mitarbeitern, Projekten und Produkten sowie Finanzmanagement.

Dabei wird durch den Einsatz von Zufallsfaktoren ein realistischer, unvorhersehbarer Simulationsablauf ermöglicht.

## Projektstruktur

```
simulation/
├── market_simulation.py
├── company.py
├── master_state.py
├── person.py
├── project.py
├── product.py
└── ... (weitere Dateien)
```

*Hinweis: Neben den oben genannten Dateien gibt es weitere Module, die für die Gesamtfunktionalität des Simulators notwendig sind.*

## Wichtige Module

### MarketSimulation

Die Datei `simulation/market_simulation.py` enthält die Klasse `MarketSimulation`, die folgende Aufgaben übernimmt:

- **Trendaktualisierung:**  
  Aktualisiert den Markttrend basierend auf der aktuellen Zeit und fügt einen zufälligen Schwankungsfaktor hinzu.
  
- **Absatzanpassung:**  
  Multipliziert einen Basisabsatzwert mit dem aktuellen Markttrend, um angepasste Verkaufszahlen zu berechnen.
  
- **Generierung von Bewerbern und Projekten:**  
  Erzeugt neue Bewerber und Projekte basierend auf dem Unternehmenskarma, der Dauer und übergebenen Namenslisten.

Beispielcode:

```python
def update_trend(self, time):
    self.trend = 1.0 - ((time % 10) * 0.05) + random.uniform(-0.05, 0.05)
```

### Company

Die Datei `simulation/company.py` definiert die Klasse `Company`, die für die Verwaltung des Unternehmens zuständig ist:

- **Mitarbeiterverwaltung:**  
  Hinzufügen und Entfernen von Mitarbeitern. Beim Hinzufügen wird auch die Beschäftigungsdauer initialisiert und der Gesamtsloc-Wert sowie das Karma des Unternehmens angepasst.
  
- **Projekt- und Produktverwaltung:**  
  Verwaltung der laufenden Projekte und der fertiggestellten Produkte.
  
- **Finanzmanagement:**  
  Durchführung von Zahlungen, wobei die Gehaltskosten der Mitarbeiter vom Unternehmensbudget abgezogen werden.

Beispielcode:

```python
def add_employee(self, person):
    self.employees.append(person)
    person.employment_duration = 0  # Initialisiere Beschäftigungsdauer
    self.totsloc += int((self.sloc_per_day * person.skill) / 100)
    self.karma += 5
```

## Installation

1. Repository klonen:

   ```bash
   git clone https://github.com/DEIN_USERNAME/DEIN_REPOSITORY.git
   ```

2. In das Projektverzeichnis wechseln:

   ```bash
   cd DEIN_REPOSITORY
   ```

3. Sicherstellen, dass Python 3.x installiert ist.

4. Abhängigkeiten installieren (falls erforderlich):

   ```bash
   pip install -r requirements.txt
   ```

## Verwendung

Das Projekt kann direkt über Python gestartet werden. Die Hauptsimulation wird in der Regel über das Modul `master_state.py` gesteuert, welches den Simulationszyklus initialisiert und fortführt.

```bash
python simulation/app.py
```

## Beitrag leisten

Beiträge zum Projekt sind willkommen! Folge bitte den üblichen GitHub-Workflows:

- Repository forken
- Einen neuen Branch für deine Änderungen erstellen
- Einen Pull Request einreichen

## Lizenz

Dieses Projekt ist unter der MIT-Lizenz lizenziert. Siehe die [LICENSE](LICENSE) Datei für weitere Details.

