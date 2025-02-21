# simulation/market_simulation.py
import random

class MarketSimulation:
    def __init__(self):
        self.trend = 1.0

    def update_trend(self, time):
        self.trend = 1.0 - ((time % 10) * 0.05) + random.uniform(-0.05, 0.05)

    def get_trend(self):
        return self.trend

    def adjust_sales(self, base_sales):
        return int(base_sales * self.trend)

    def generate_applicants(self, karma, duration, first_names, last_names):
        count = int(random.uniform(0.5, 1.5) * duration * (karma / 10))
        from simulation.master_state import Person
        applicants = []
        for _ in range(count):
            pid = int(random.random() * 10000)
            name = random.choice(last_names)
            firstname = random.choice(first_names)
            money = random.randint(35000, 85000)
            skill = random.randint(45, 95)
            applicants.append(Person(pid, name, firstname, money, skill))
        return applicants

    def generate_projects(self, karma, duration):
        count = int(random.uniform(0.5, 1.5) * duration * (karma / 10))
        from simulation.master_state import Project
        projects = []
        for _ in range(count):
            pid = int(random.random() * 10000)
            scope = random.randint(50, 200)
            scope = int(scope * self.trend)
            projects.append(Project(pid, scope))
        return projects
