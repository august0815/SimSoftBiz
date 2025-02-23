# gui/main_window.py
from PyQt5 import QtWidgets , uic
from PyQt5.QtWidgets import QMainWindow, QMessageBox, QFileDialog, QDialog, QVBoxLayout, QPushButton, QLabel, QTextEdit, QMenu
from PyQt5.QtGui import QStandardItemModel, QStandardItem, QColor
from PyQt5.QtCore import Qt
from simulation.master_state import MasterState
import json
import random

class MeasuresDialog(QDialog):
    def __init__(self, parent):
        super().__init__(parent)
        self.setWindowTitle("Maßnahmen auswählen")
        self.parent = parent
        self.init_ui()

    def init_ui(self):
        layout = QVBoxLayout()

        motivation_label = QLabel("Motivationsmaßnahmen:")
        layout.addWidget(motivation_label)

        self.team_building_btn = QPushButton(f"Team-Building-Event (Kosten: {random.randint(10000, 30000)})")
        self.team_building_btn.clicked.connect(lambda: self.register_measure("motivation", "Team-Building-Event"))
        layout.addWidget(self.team_building_btn)

        self.bonus_btn = QPushButton(f"Bonus-Zahlung (Kosten: {random.randint(10000, 30000)})")
        self.bonus_btn.clicked.connect(lambda: self.register_measure("motivation", "Bonus-Zahlung"))
        layout.addWidget(self.bonus_btn)

        self.flex_hours_btn = QPushButton(f"Flexible Arbeitszeiten (Kosten: {random.randint(10000, 30000)})")
        self.flex_hours_btn.clicked.connect(lambda: self.register_measure("motivation", "Flexible Arbeitszeiten"))
        layout.addWidget(self.flex_hours_btn)

        sales_label = QLabel("Absatzförderungsmaßnahmen:")
        layout.addWidget(sales_label)

        self.marketing_btn = QPushButton(f"Marketing-Kampagne (Kosten: {random.randint(10000, 30000)})")
        self.marketing_btn.clicked.connect(lambda: self.register_measure("sales", "Marketing-Kampagne"))
        layout.addWidget(self.marketing_btn)

        self.discount_btn = QPushButton(f"Rabattaktion (Kosten: {random.randint(10000, 30000)})")
        self.discount_btn.clicked.connect(lambda: self.register_measure("sales", "Rabattaktion"))
        layout.addWidget(self.discount_btn)

        self.feedback_btn = QPushButton(f"Kunden-Feedback-Programm (Kosten: {random.randint(10000, 30000)})")
        self.feedback_btn.clicked.connect(lambda: self.register_measure("sales", "Kunden-Feedback-Programm"))
        layout.addWidget(self.feedback_btn)

        close_btn = QPushButton("Close")
        close_btn.clicked.connect(self.close)
        layout.addWidget(close_btn)

        self.setLayout(layout)

    def register_measure(self, category, measure_name):
        costs = int(self.sender().text().split("Kosten: ")[1].split(")")[0])
        if self.parent.master_state.company.money >= costs:
            self.parent.master_state.company.money -= costs
            if category == "motivation":
                self.parent.master_state.motivation_measure = {
                    "name": measure_name,
                    "motivation_increase": random.randint(10, 50),
                    "karma_increase": random.randint(0, 5)
                }
            else:
                self.parent.master_state.sales_measure = {
                    "name": measure_name,
                    "sales_increase": random.randint(10, 50),
                    "duration": random.randint(5, 15)
                }
            QMessageBox.information(self, "Maßnahme Registriert",
                                    f"{measure_name} wird in der nächsten Runde wirksam!")
            self.parent.update_ui()
            self.close()
        else:
            QMessageBox.warning(self, "Fehler", "Nicht genügend Geld verfügbar!")

class StatsDialog(QDialog):
    def __init__(self, parent, pos, active_tree):
        super().__init__(parent)
        self.setWindowTitle("Statistiken")
        self.parent = parent
        self.active_tree = active_tree
        self.move(pos)
        self.init_ui()

    def init_ui(self):
        layout = QVBoxLayout()
        stats_text = QTextEdit()
        stats_text.setReadOnly(True)

        if self.active_tree == self.parent.treeViewBewerber and self.parent.selected_applicant_id is not None:
            applicant = next((p for p in self.parent.master_state.applicants if p.id == self.parent.selected_applicant_id), None)
            if applicant:
                stats = f"Bewerber ID: {applicant.id}\n"
                stats += f"Name: {applicant.firstname} {applicant.name}\n"
                stats += f"Geld: {applicant.money}\n"
                stats += f"Skill (Durchschnitt): {sum(applicant.skills.values()) / len(applicant.skills):.2f}\n"
                stats += f"Alter: {applicant.age}\n"
                stats += "Skills:\n" + "\n".join([f"  {k}: {v}" for k, v in applicant.skills.items()])
                stats_text.setText(stats)

        elif self.active_tree == self.parent.treeViewAngestellte and self.parent.selected_employee_id is not None:
            employee = next((e for e in self.parent.master_state.company.employees if e.id == self.parent.selected_employee_id), None)
            if employee:
                stats = f"Mitarbeiter ID: {employee.id}\n"
                stats += f"Name: {employee.firstname} {employee.name}\n"
                stats += f"Geld: {employee.money}\n"
                stats += f"Skill (Durchschnitt): {sum(employee.skills.values()) / len(employee.skills):.2f}\n"
                stats += f"Alter: {employee.age}\n"
                stats += f"Motivation: {employee.motivation}\n"
                stats += f"Beschäftigungsdauer: {employee.employment_duration}\n"
                stats += "Skills:\n" + "\n".join([f"  {k}: {v}" for k, v in employee.skills.items()])
                stats_text.setText(stats)

        elif self.active_tree == self.parent.treeViewProjekte and self.parent.selected_project_pool_id is not None:
            project = next((p for p in self.parent.master_state.projects_pool if p.id == self.parent.selected_project_pool_id), None)
            if project:
                stats = f"Projekt ID: {project.id}\n"
                stats += f"Umfang: {project.scope}\n"
                stats += f"Status: {project.status}\n"
                stats += f"Alter: {project.age}\n"
                stats += f"Kategorie: {project.category}\n"
                stats += f"Label: {project.label if project.label else 'new'}\n"
                stats += "Anforderungen:\n" + "\n".join([f"  {skill}" for skill in project.get_requirements()])
                stats_text.setText(stats)
            else:
                stats_text.setText("Kein Projekt gefunden. Bitte sicherstellen, dass ein Projekt im Pool ausgewählt ist.")

        elif self.active_tree == self.parent.treeViewSoftwareToWrite and self.parent.selected_company_project_id is not None:
            project = next((p for p in self.parent.master_state.company.projects if p.id == self.parent.selected_company_project_id), None)
            if project:
                stats = f"Projekt ID: {project.id}\n"
                stats += f"Umfang: {project.scope}\n"
                stats += f"Status: {project.status}\n"
                stats += f"Alter: {project.age}\n"
                stats += f"Kategorie: {project.category}\n"
                stats += f"Label: {project.label if project.label else 'new'}\n"
                stats += "Anforderungen:\n" + "\n".join([f"  {skill}" for skill in project.get_requirements()])
                stats_text.setText(stats)
            else:
                stats_text.setText("Kein laufendes Projekt gefunden. Bitte sicherstellen, dass ein Projekt ausgewählt ist.")

        elif self.active_tree == self.parent.treeViewSoftware:
            stats = "Software-Statistiken:\n"
            for prod in self.parent.master_state.company.finished_products:
                stats += f"\nProdukt ID: {prod.product_id}\n"
                stats += f"Preis: {prod.price}\n"
                stats += f"Alter: {prod.age}\n"
                stats += f"Verkauft: {prod.sold}\n"
                stats += f"Genre: {prod.genre}\n"
                stats += f"In Wartung: {'Ja' if prod.in_maintenance else 'Nein'}\n"
                stats += f"Seit Bugfix: {prod.since_bugfix}\n"
                stats += f"Seit Revision: {prod.since_revision}\n"
            stats_text.setText(stats)

        else:
            stats_text.setText("Bitte ein Element auswählen, um Statistiken anzuzeigen.")

        layout.addWidget(stats_text)

        close_btn = QPushButton("Close")
        close_btn.clicked.connect(self.close)
        layout.addWidget(close_btn)

        self.setLayout(layout)

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        uic.loadUi("main.ui", self)
        self.center()
        self.master_state = MasterState()
        self.master_state.start_init()
        self.selected_applicant_id = None
        self.selected_project_pool_id = None
        self.selected_employee_id = None
        self.selected_company_project_id = None
        self.active_tree = None

        self.model_applicants = QStandardItemModel()
        self.model_applicants.setHorizontalHeaderLabels(["ID", "Name", "Vorname", "Money", "Skill", "Skills"])
        self.treeViewBewerber.setModel(self.model_applicants)
        self.treeViewBewerber.clicked.connect(self.on_applicant_selected)
        self.treeViewBewerber.setContextMenuPolicy(Qt.CustomContextMenu)
        self.treeViewBewerber.customContextMenuRequested.connect(self.show_context_menu)

        self.model_projects_pool = QStandardItemModel()
        self.model_projects_pool.setHorizontalHeaderLabels(["ID", "Scope", "Status", "Kategorie"])
        self.treeViewProjekte.setModel(self.model_projects_pool)
        self.treeViewProjekte.clicked.connect(self.on_project_pool_selected)
        self.treeViewProjekte.setContextMenuPolicy(Qt.CustomContextMenu)
        self.treeViewProjekte.customContextMenuRequested.connect(self.show_context_menu)

        self.model_employees = QStandardItemModel()
        self.model_employees.setHorizontalHeaderLabels(["ID", "Name", "Vorname", "Money", "Skill", "Motivation", "Skills"])
        self.treeViewAngestellte.setModel(self.model_employees)
        self.treeViewAngestellte.clicked.connect(self.on_employee_selected)
        self.treeViewAngestellte.setContextMenuPolicy(Qt.CustomContextMenu)
        self.treeViewAngestellte.customContextMenuRequested.connect(self.show_context_menu)

        self.model_company_projects = QStandardItemModel()
        self.model_company_projects.setHorizontalHeaderLabels(["ID", "Scope", "Status", "Kategorie"])
        self.treeViewSoftwareToWrite.setModel(self.model_company_projects)
        self.treeViewSoftwareToWrite.clicked.connect(self.on_company_project_selected)
        self.treeViewSoftwareToWrite.setContextMenuPolicy(Qt.CustomContextMenu)
        self.treeViewSoftwareToWrite.customContextMenuRequested.connect(self.show_context_menu)

        self.model_finished_products = QStandardItemModel()
        self.model_finished_products.setHorizontalHeaderLabels(["ID", "Price", "Age", "Sold", "Genre", "Status"])
        self.treeViewSoftware.setModel(self.model_finished_products)
        self.treeViewSoftware.setContextMenuPolicy(Qt.CustomContextMenu)
        self.treeViewSoftware.customContextMenuRequested.connect(self.show_context_menu)

        self.actionNew.triggered.connect(self.new_game)
        self.actionOpen.triggered.connect(self.open_file)
        self.actionSave.triggered.connect(self.save_file)
        self.actionNext.triggered.connect(self.next_day)
        self.actionNext10.triggered.connect(lambda: self.advance_days(10))
        self.actionHire.triggered.connect(self.hire_applicant)
        self.actionFire.triggered.connect(self.fire_employee)
        self.actionAddSoftware.triggered.connect(self.add_project_to_company)
        self.actionRemoveProjekt.triggered.connect(self.remove_company_project)
        self.buttonTool.clicked.connect(self.open_measures_dialog)

        self.update_ui()

    def center(self):
        qr = self.frameGeometry()
        cp = QtWidgets.QDesktopWidget().availableGeometry().center()
        qr.moveCenter(cp)
        self.move(qr.topLeft())

    def update_ui(self):
        self.timeEdit.setText(f"Tag: {self.master_state.time}")
        self.moneyEdit.setText(f"Geld: {self.master_state.company.money}")
        self.karmaEdit.setText(f"Firma: {self.master_state.company.name}\nKarma: {self.master_state.company.karma}")
        self.messageEdit.setText(self.master_state.show_status())
        self.update_applicants_view()
        self.update_projects_pool_view()
        self.update_employees_view()
        self.update_company_projects_view()
        self.update_finished_products_view()
        self.check_employee_motivation()

    def update_applicants_view(self):
        self.model_applicants.removeRows(0, self.model_applicants.rowCount())
        for applicant in self.master_state.applicants:
            skills_str = ", ".join([f"{k}: {v}" for k, v in applicant.skills.items()])
            avg_skill = sum(applicant.skills.values()) / len(applicant.skills) if applicant.skills else 0
            row = [
                QStandardItem(str(applicant.id)),
                QStandardItem(applicant.name),
                QStandardItem(applicant.firstname),
                QStandardItem(str(applicant.money)),
                QStandardItem(f"{avg_skill:.2f}"),
                QStandardItem(skills_str)
            ]
            self.model_applicants.appendRow(row)

    def update_projects_pool_view(self):
        self.model_projects_pool.removeRows(0, self.model_projects_pool.rowCount())
        for proj in self.master_state.projects_pool:
            row = [
                QStandardItem(str(proj.id)),
                QStandardItem(str(proj.scope)),
                QStandardItem(proj.status),
                QStandardItem(proj.category)
            ]
            self.model_projects_pool.appendRow(row)

    def update_employees_view(self):
        self.model_employees.removeRows(0, self.model_employees.rowCount())
        for emp in self.master_state.company.employees:
            skills_str = ", ".join([f"{k}: {v}" for k, v in emp.skills.items()])
            avg_skill = sum(emp.skills.values()) / len(emp.skills) if emp.skills else 0
            row = [
                QStandardItem(str(emp.id)),
                QStandardItem(emp.name),
                QStandardItem(emp.firstname),
                QStandardItem(str(emp.money)),
                QStandardItem(f"{avg_skill:.2f}"),
                QStandardItem(str(int(emp.motivation))),
                QStandardItem(skills_str)
            ]
            self.model_employees.appendRow(row)

    def update_company_projects_view(self):
        self.model_company_projects.removeRows(0, self.model_company_projects.rowCount())
        tree_data = self.master_state.get_tree_view_software_to_write()
        for entry in tree_data:
            parts = entry["text"].split(": ")[1].split(", ")
            scope = parts[0].split("Umfang ")[1]
            category = parts[1].split("Kategorie ")[1].split(" (")[0]
            status = parts[1].split("(")[1][:-1] if "(" in parts[1] else "new"
            row = [
                QStandardItem(str(entry["id"])),
                QStandardItem(scope),
                QStandardItem(status),
                QStandardItem(category)
            ]
            if entry["color"] == "green":
                for item in row:
                    item.setBackground(QColor("lightgreen"))
            self.model_company_projects.appendRow(row)

    def update_finished_products_view(self):
        self.model_finished_products.removeRows(0, self.model_finished_products.rowCount())
        tree_data = self.master_state.get_tree_view_software()
        for entry in tree_data:
            parts = entry["text"].split(": ")[1].split(", ")
            id = entry["id"]
            price = parts[0].split("Preis ")[1]
            sold_part = parts[1].split("Verkauft ")[1]
            sold = sold_part.split(" (")[0] if " (" in sold_part else sold_part
            status = sold_part.split(" (")[1][:-1] if " (" in sold_part else ""
            genre = parts[2].split("Genre ")[1].split(" (")[0] if len(parts) > 2 else ""
            row = [
                QStandardItem(str(id)),
                QStandardItem(price),
                QStandardItem(str(self.get_product_age(id))),
                QStandardItem(sold),
                QStandardItem(genre),
                QStandardItem(status)
            ]
            if entry["color"] == "red":
                for item in row:
                    item.setBackground(QColor("red"))
            self.model_finished_products.appendRow(row)

    def get_product_age(self, product_id):
        for prod in self.master_state.company.finished_products:
            if prod.product_id == product_id:
                return prod.age
        return 0

    def check_employee_motivation(self):
        for emp in self.master_state.company.employees[:]:
            if emp.motivation < 65 and emp.motivation >= 50 and emp.employment_duration % 10 == 0:
                reply = QMessageBox.question(
                    self, "Lohnerhöhung gefordert",
                    f"{emp.firstname} {emp.name} (ID: {emp.id}) fordert eine 5%ige Lohnerhöhung. Akzeptieren?",
                    QMessageBox.Yes | QMessageBox.No, QMessageBox.No
                )
                if reply == QMessageBox.Yes:
                    emp.money = int(emp.money * 1.05)
                    self.master_state.company.karma += 1
                    emp.motivation += random.randint(5, 15)
                    if emp.motivation > 100:
                        emp.motivation = 100
                else:
                    self.master_state.company.karma -= 1

    def open_measures_dialog(self):
        dialog = MeasuresDialog(self)
        dialog.exec_()

    def show_context_menu(self, pos):
        sender = self.sender()
        self.active_tree = sender
        menu = QMenu(self)
        stats_action = menu.addAction("Statistiken anzeigen")
        action = menu.exec_(sender.mapToGlobal(pos))
        if action == stats_action:
            dialog = StatsDialog(self, sender.mapToGlobal(pos), self.active_tree)
            dialog.exec_()

    def apply_measures(self):
        if hasattr(self.master_state, 'motivation_measure') and self.master_state.motivation_measure:
            measure = self.master_state.motivation_measure
            for emp in self.master_state.company.employees:
                emp.motivation = min(100, emp.motivation + measure["motivation_increase"])
            self.master_state.company.karma += measure["karma_increase"]
            QMessageBox.information(self, "Maßnahme Wirkung",
                                    f"{measure['name']} wirksam: Motivation +{measure['motivation_increase']}, Karma +{measure['karma_increase']}")
            self.master_state.motivation_measure = None

    def on_applicant_selected(self, index):
        try:
            self.selected_applicant_id = int(self.model_applicants.item(index.row(), 0).text())
            self.selected_employee_id = None
            self.selected_company_project_id = None
            self.selected_project_pool_id = None
            self.active_tree = self.treeViewBewerber
        except Exception:
            self.selected_applicant_id = None

    def on_project_pool_selected(self, index):
        try:
            self.selected_project_pool_id = int(self.model_projects_pool.item(index.row(), 0).text())
            self.selected_applicant_id = None
            self.selected_employee_id = None
            self.selected_company_project_id = None
            self.active_tree = self.treeViewProjekte
        except Exception:
            self.selected_project_pool_id = None

    def on_employee_selected(self, index):
        try:
            self.selected_employee_id = int(self.model_employees.item(index.row(), 0).text())
            self.selected_applicant_id = None
            self.selected_company_project_id = None
            self.selected_project_pool_id = None
            self.active_tree = self.treeViewAngestellte
        except Exception:
            self.selected_employee_id = None

    def on_company_project_selected(self, index):
        try:
            self.selected_company_project_id = int(self.model_company_projects.item(index.row(), 0).text())
            self.selected_applicant_id = None
            self.selected_employee_id = None
            self.selected_project_pool_id = None
            self.active_tree = self.treeViewSoftwareToWrite
        except Exception:
            self.selected_company_project_id = None

    def new_game(self):
        self.master_state.start_init()
        self.update_ui()

    def open_file(self):
        filename, _ = QFileDialog.getOpenFileName(self, "Open Simulation File", "",
                                                  "JSON Files (*.json);;All Files (*)")
        if filename:
            try:
                with open(filename, "r") as f:
                    data = json.load(f)
                    self.master_state.load_from_dict(data)
                    self.update_ui()
            except Exception as e:
                QMessageBox.critical(self, "Error", f"Failed to open file: {e}")

    def save_file(self):
        filename, _ = QFileDialog.getSaveFileName(self, "Save Simulation File", "",
                                                  "JSON Files (*.json);;All Files (*)")
        if filename:
            try:
                with open(filename, "w") as f:
                    json.dump(self.master_state.to_dict(), f, indent=4)
            except Exception as e:
                QMessageBox.critical(self, "Error", f"Failed to save file: {e}")

    def next_day(self):
        self.master_state.advance_time(1)
        self.master_state.sell_software()
        self.apply_measures()
        self.update_ui()

    def advance_days(self, days):
        for _ in range(days):
            self.master_state.advance_time(1)
            self.master_state.sell_software()
            self.apply_measures()
        self.update_ui()

    def hire_applicant(self):
        if self.selected_applicant_id is not None:
            applicant = next((p for p in self.master_state.applicants if p.id == self.selected_applicant_id), None)
            if applicant:
                self.master_state.company.add_employee(applicant)
                self.master_state.applicants = [p for p in self.master_state.applicants if p.id != self.selected_applicant_id]
                self.update_ui()
                self.selected_applicant_id = None
            else:
                QMessageBox.information(self, "Info", "Kein Bewerber ausgewählt!")
        else:
            QMessageBox.information(self, "Info", "Kein Bewerber ausgewählt!")

    def fire_employee(self):
        if self.selected_employee_id is not None:
            self.master_state.company.remove_employee(self.selected_employee_id)
            self.update_ui()
            self.selected_employee_id = None
        else:
            QMessageBox.information(self, "Info", "Kein Mitarbeiter ausgewählt!")

    def add_project_to_company(self):
        if self.selected_project_pool_id is not None:
            proj = next((p for p in self.master_state.projects_pool if p.id == self.selected_project_pool_id), None)
            if proj:
                self.master_state.company.add_project(proj)
                self.master_state.projects_pool = [p for p in self.master_state.projects_pool if p.id != self.selected_project_pool_id]
                self.update_ui()
                self.selected_project_pool_id = None
            else:
                QMessageBox.information(self, "Info", "Kein Projekt ausgewählt!")
        else:
            QMessageBox.information(self, "Info", "Kein Projekt ausgewählt!")

    def remove_company_project(self):
        if self.selected_company_project_id is not None:
            self.master_state.company.remove_project(self.selected_company_project_id)
            self.update_ui()
            self.selected_company_project_id = None
        else:
            QMessageBox.information(self, "Info", "Kein Projekt ausgewählt!")

if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec_())