# simulation/person.py
import random

class Person:
    def __init__(self, pid, name, firstname, money, skill, age=0, motivation=None, employment_duration=0, skills=None):
        self.id = pid
        self.name = name
        self.firstname = firstname
        self.money = money
        self.skill = skill
        self.age = age
        self.motivation = random.randint(80, 95) if motivation is None else motivation
        self.employment_duration = employment_duration
        self.skills = skills if skills is not None else self.get_random_skills()
        if self.id == -1:
            self.skills = {
                "webentwicklung": 10,
                "mobile entwicklung": 10,
                "datenbankentwicklung": 10,
                "sicherheitsentwicklung": 10,
                "ki-entwicklung": 10,
                "allgemeine programmierung": self.skill
            }

    def get_random_skills(self):
        skills = {
            "webentwicklung": random.randint(0, 100),
            "mobile entwicklung": random.randint(0, 100),
            "datenbankentwicklung": random.randint(0, 100),
            "sicherheitsentwicklung": random.randint(0, 100),
            "ki-entwicklung": random.randint(0, 100),
            "allgemeine programmierung": self.skill
        }
        return skills

    def update_motivation(self, salary, employment_duration):
        salary_effect = salary / 1000
        duration_effect = employment_duration / 50
        random_effect = random.uniform(-5, 2)
        self.motivation += (salary_effect - duration_effect + random_effect)
        self.motivation = min(100, max(0, self.motivation))
        return self.motivation

#    def to_dict(self):
#        return {
#            "id": self.id,
#            "name": self.name,
#            "firstname": self.firstname,
#            "money": self.money,
#            "skill": self.skill,
#            "age": self.age,
#            "motivation": self.motivation,
#            "employment_duration": self.employment_duration,
#            "skills": self.skills
#        }
    def to_dict(self):
        return {
            "pid": self.id,  # Änderung hier: id -> pid
            "name": self.name,
            "firstname": self.firstname,
            "money": self.money,
            "skill": self.skill,
            "age": self.age,
            "motivation": self.motivation,
            "employment_duration": self.employment_duration,
            "skills": self.skills
        }
