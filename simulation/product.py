# simulation/product.py
import random

class Product:
    def __init__(self, product_id, price, age=0, sold=0, in_maintenance=False, since_bugfix=0, since_revision=0, genre=None):
        self.product_id = product_id
        self.price = price
        self.age = age
        self.sold = sold
        self.in_maintenance = in_maintenance
        self.since_bugfix = since_bugfix
        self.since_revision = since_revision
        self.genre = genre if genre else random.choice([
            "Business-Software",
            "Gaming-Software",
            "Bildungs-Software",
            "Sicherheits-Software",
            "KI-Tools"
        ])
        self.base_price = self.get_base_price()

    def get_base_price(self):
        """Gibt den Basispreis basierend auf dem Genre zurück."""
        prices = {
            "Business-Software": 200,
            "Gaming-Software": 60,
            "Bildungs-Software": 100,
            "Sicherheits-Software": 150,
            "KI-Tools": 300
        }
        return prices.get(self.genre, 100)

    def to_dict(self):
        return {
            "product_id": self.product_id,
            "price": self.price,
            "age": self.age,
            "sold": self.sold,
            "in_maintenance": self.in_maintenance,
            "since_bugfix": self.since_bugfix,
            "since_revision": self.since_revision,
            "genre": self.genre
        }
