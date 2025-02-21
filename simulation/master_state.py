# simulation/master_state.py
import random
from datetime import datetime
from simulation.person import Person
from simulation.project import Project
from simulation.product import Product
from simulation.company import Company
from simulation.market_simulation import MarketSimulation


class MasterState:
    def __init__(self):
        self.time = 0
        self.company = Company()
        self.applicants = []
        self.projects_pool = []
        self.first_names = [
            "Jon", "Barbara", "Brianna", "Charles", "Christopher", "Daniel",
            "David", "Donald", "Elizabeth", "James", "Jennifer", "Jeremy",
            "John", "Joseph", "Linda", "Maria", "Mark", "Mary", "Michael",
            "Patricia", "Paul", "Richard", "Robert", "Susan", "Thomas", "William"
        ]
        self.last_names = [
            "Smith", "Johnson", "Williams", "Brown", "Jones", "Miller",
            "Davis", "Garcia", "Rodriguez", "Wilson", "Martinez", "Anderson",
            "Taylor", "Thomas", "Hernandez", "Moore", "Martin", "Jackson",
            "Thompson", "White", "Lopez", "Lee", "Gonzalez", "Harris", "Clark"
        ]
        self.market = MarketSimulation()
        self.motivation_measure = None  # Temporäre Motivationsmaßnahme
        self.sales_measure = None  # Temporäre Absatzmaßnahme
        self.sales_measure_duration = 0  # Dauer der Absatzmaßnahme
        self.start_init()

    def start_init(self):
        self.time = 0
        self.company = Company(name="Software Biz Sim", money=100000, karma=10)
        self.applicants.clear()
        self.projects_pool.clear()
        self.company.employees.clear()
        self.company.projects.clear()
        self.company.finished_products.clear()
        self.market.update_trend(self.time)
        self.adjust_pools()
        ceo = Person(pid=-1, name="CEO", firstname="Himself", money=100000, skill=10)
        self.company.add_employee(ceo)
        self.advance_time(10)

    def adjust_pools(self):
        max_projects = max(1, self.company.karma // 10)
        current_projects = len(self.projects_pool)

        if current_projects < max_projects:
            new_projects = self.market.generate_projects(self.company.karma, duration=1)
            for proj in new_projects[:max_projects - current_projects]:
                self.projects_pool.append(Project(proj.id, proj.scope, age=0))

        max_applicants = max(1, self.company.karma // 10)
        current_applicants = len(self.applicants)

        if current_applicants < max_applicants:
            new_applicants = self.market.generate_applicants(self.company.karma, duration=1,
                                                             first_names=self.first_names,
                                                             last_names=self.last_names)
            for appl in new_applicants[:max_applicants - current_applicants]:
                self.applicants.append(Person(appl.id, appl.name, appl.firstname, appl.money, appl.skill, age=0))

    def advance_time(self, days=1):
        self.time += days
        self.market.update_trend(self.time)
        completed = []
        for proj in self.company.projects[:]:
            required_skills = proj.get_requirements()
            capable_employees = [
                emp for emp in self.company.employees
                if any(skill.lower() in emp.skills and emp.skills[skill.lower()] >= 5 for skill in required_skills)
            ]
            if capable_employees:
                avg_motivation = sum(emp.motivation for emp in capable_employees) / len(capable_employees)
                motivation_factor = avg_motivation / 100
                proj.scope -= int(10 * days * motivation_factor)
            if proj.scope <= 0:
                proj.status = "completed"
                if proj.label in ["bugfix", "newversion"]:
                    for prod in self.company.finished_products:
                        if prod.product_id == proj.id and prod.in_maintenance:
                            prod.in_maintenance = False
                            prod.sold = 0
                            if proj.label == "bugfix":
                                prod.since_bugfix = 0
                            elif proj.label == "newversion":
                                prod.since_revision = 0
                                prod.price = int(prod.price * 1.25)
                else:
                    base_price = {
                        "webentwicklung": 120,
                        "mobile entwicklung": 150,
                        "datenbankentwicklung": 100,
                        "sicherheitsentwicklung": 200,
                        "ki-entwicklung": 250
                    }.get(proj.category.lower(), 100)
                    product = Product(product_id=proj.id, price=base_price, genre=proj.category)
                    self.company.add_product(product)
                completed.append(proj)
        for proj in completed:
            self.company.remove_project(proj.id)

        if random.random() < 0.1:
            cost = self.company.money * random.uniform(0.01, 0.1)
            self.company.money -= int(cost)
        base_cost = len(self.company.employees) * 100
        random_cost = random.randint(0, len(self.company.employees) * 50)
        self.company.money -= (base_cost + random_cost)
        self.company.do_payments()

        for proj in self.projects_pool:
            proj.age += days
        for appl in self.applicants:
            appl.age += days

        self.company.finished_products = [prod for prod in self.company.finished_products if prod.age < 500]

        for emp in self.company.employees[:]:
            emp.employment_duration += days
            if emp.employment_duration % 10 == 0 and emp.id != -1:
                emp.update_motivation(salary=100, employment_duration=emp.employment_duration)
                if emp.motivation < 50:
                    self.company.remove_employee(emp.id)
                elif emp.motivation < 65:
                    pass

        for prod in self.company.finished_products[:]:
            if not prod.in_maintenance:
                prod.age += days
                prod.since_bugfix += days
                prod.since_revision += days
                if prod.since_bugfix > 0 and prod.since_bugfix % 30 == 0:
                    prod.price = int(prod.price * 0.9)
                    prod.sold = int(prod.sold * 0.95)
                    if prod.since_revision % 120 == 0:
                        prod.in_maintenance = True
                        self.company.add_project(Project(prod.product_id, scope=300, label="newversion"))
                    else:
                        prod.in_maintenance = True
                        self.company.add_project(Project(prod.product_id, scope=50, label="bugfix"))

        if self.sales_measure and self.sales_measure_duration > 0:
            self.sales_measure_duration -= days
            if self.sales_measure_duration <= 0:
                self.sales_measure = None

        self.projects_pool = [p for p in self.projects_pool if p.age <= 3]
        self.applicants = [a for a in self.applicants if a.age <= 3]
        self.adjust_pools()

    def sell_software(self):
        for product in self.company.finished_products:
            if not product.in_maintenance:
                base_sales = random.randint(0, 5)
                if self.sales_measure and self.sales_measure_duration > 0:
                    base_sales += self.sales_measure["sales_increase"]  # Temporärer Absatz-Boost
                adjusted_sales = self.market.adjust_sales(base_sales)
                product.sold += adjusted_sales
                self.company.money += product.price * adjusted_sales

    def show_status(self):
        status = "" #f"Zeit: {self.time}\n"
        #status += f"Firma: {self.company.name}\nGeld: {self.company.money}\nKarma: {self.company.karma}\n"
        #status += f"Mitarbeiter: {len(self.company.employees)}\n"
        for i, emp in enumerate(self.company.employees):
            status += f"  Mitarbeiter {i + 1}: ID {emp.id}, Motivation {emp.motivation}, Skills: {emp.skills}\n"
        status += f"Projekte in Arbeit: {len(self.company.projects)}\n"
        for i, proj in enumerate(self.company.projects):
            label = f" ({proj.label})" if proj.label else ""
            status += f"  Projekt {i + 1}: ID {proj.id}, Umfang {proj.scope}, Kategorie {proj.category}{label}\n"
        status += f"Fertige Software: {len(self.company.finished_products)}\n"
        for i, prod in enumerate(self.company.finished_products):
            maintenance = " (in Wartung)" if prod.in_maintenance else ""
            status += f"  Produkt {i + 1}: ID {prod.product_id}, Preis {prod.price}, Alter {prod.age} Tage, Verkauft {prod.sold}, Genre {prod.genre}{maintenance}\n"
        status += f"Markttrend: {self.market.get_trend():.2f}\n"
        if self.motivation_measure:
            status += f"Aktive Motivationsmaßnahme: {self.motivation_measure['name']}\n"
        if self.sales_measure:
            status += f"Aktive Absatzmaßnahme: {self.sales_measure['name']}, Dauer: {self.sales_measure_duration} Tage\n"
        return status

    def get_tree_view_software(self):
        tree_data = []
        for prod in self.company.finished_products:
            status = ""
            color = "black"
            if prod.in_maintenance:
                for proj in self.company.projects:
                    if proj.id == prod.product_id:
                        if proj.label == "bugfix":
                            status = " (bugfix)"
                            color = "red"
                        elif proj.label == "newversion":
                            status = " (revision)"
                            color = "red"
            entry = {
                "id": prod.product_id,
                "text": f"Produkt ID {prod.product_id}: Preis {prod.price}, Verkauft {prod.sold}, Genre {prod.genre}{status}",
                "color": color
            }
            tree_data.append(entry)
        return tree_data

    def get_tree_view_software_to_write(self):
        tree_data = []
        for proj in self.company.projects:
            label = proj.label if proj.label else "new"
            color = "green" if proj.label in ["bugfix", "newversion"] else "black"
            entry = {
                "id": proj.id,
                "text": f"Projekt ID {proj.id}: Umfang {proj.scope}, Kategorie {proj.category} ({label})",
                "color": color
            }
            tree_data.append(entry)
        return tree_data

    def to_dict(self):
        return {
            "time": self.time,
            "company": self.company.to_dict(),
            "applicants": [p.to_dict() for p in self.applicants],
            "projects_pool": [p.to_dict() for p in self.projects_pool],
            "motivation_measure": self.motivation_measure,
            "sales_measure": self.sales_measure,
            "sales_measure_duration": self.sales_measure_duration
        }

    def load_from_dict(self, data):
        self.time = data.get("time", 0)
        comp_data = data.get("company", {})
        self.company = Company(
            name=comp_data.get("name", "Software Biz Sim"),
            money=comp_data.get("money", 100000),
            karma=comp_data.get("karma", 10)
        )
        self.company.employees = [Person(**p) for p in comp_data.get("employees", [])]
        self.company.projects = [Project(**p) for p in comp_data.get("projects", [])]
        self.company.finished_products = [Product(**p) for p in comp_data.get("finished_products", [])]
        self.applicants = [Person(**p) for p in data.get("applicants", [])]
        self.projects_pool = [Project(**p) for p in data.get("projects_pool", [])]
        self.motivation_measure = data.get("motivation_measure", None)
        self.sales_measure = data.get("sales_measure", None)
        self.sales_measure_duration = data.get("sales_measure_duration", 0)