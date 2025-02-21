# simulation/company.py
from simulation.person import Person
from simulation.project import Project
from simulation.product import Product


class Company:
    def __init__(self, name="Default Company", money=100000, karma=0):
        self.name = name
        self.money = money
        self.karma = karma
        self.employees = []
        self.projects = []
        self.finished_products = []
        self.sloc_per_day = 19
        self.totsloc = -16

    def add_employee(self, person):
        self.employees.append(person)
        person.employment_duration = 0  # Initialisiere Beschäftigungsdauer
        self.totsloc += int((self.sloc_per_day * person.skill) / 100)
        self.karma += 5

    def remove_employee(self, pid):
        self.employees = [p for p in self.employees if p.id != pid]
        self.karma -= 15

    def add_project(self, project):
        self.projects.append(project)

    def remove_project(self, pid):
        self.projects = [p for p in self.projects if p.id != pid]

    def add_product(self, product):
        self.finished_products.append(product)

    def do_payments(self):
        cost = len(self.employees) * 100  # Standardgehalt 100 pro Mitarbeiter
        self.money -= cost
        return cost

    def to_dict(self):
        return {
            "name": self.name,
            "money": self.money,
            "karma": self.karma,
            "employees": [e.to_dict() for e in self.employees],
            "projects": [p.to_dict() for p in self.projects],
            "finished_products": [pr.to_dict() for pr in self.finished_products]
        }