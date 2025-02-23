# simulation/project.py
import random

class Project:
    def __init__(self, id, scope, status="in progress", age=0, label=None, category=None):
        self.id = id
        self.scope = scope
        self.status = status
        self.age = age
        self.label = label
        self.category = category if category else random.choice([
            "Webentwicklung",
            "Mobile Entwicklung",
            "Datenbankentwicklung",
            "Sicherheitsentwicklung",
            "KI-Entwicklung"
        ])
        self.requirements = self.get_requirements()

    def get_requirements(self):
        """Gibt die benötigten Skills basierend auf der Kategorie zurück."""
        requirements = {
            "Webentwicklung": ["Webentwicklung", "Allgemeine Programmierung"],
            "Mobile Entwicklung": ["Mobile Entwicklung", "Allgemeine Programmierung"],
            "Datenbankentwicklung": ["Datenbankentwicklung", "Allgemeine Programmierung"],
            "Sicherheitsentwicklung": ["Sicherheit", "Allgemeine Programmierung"],
            "KI-Entwicklung": ["KI", "Allgemeine Programmierung"]
        }
        return requirements.get(self.category, ["Allgemeine Programmierung"])

    def to_dict(self):
        return {
            "id": self.id,
            "scope": self.scope,
            "status": self.status,
            "age": self.age,
            "label": self.label,
            "category": self.category
        }
