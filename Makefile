ENV_NAME=autoomics-env

install:
	@echo "📦 Installation de l'environnement..."
	./setup.sh

run:
	@echo "🚀 Lancement AutoOmics..."
	conda run -n $(ENV_NAME) python -m autoomics.main

test:
	@echo "🧪 Exécution des tests..."
	conda run -n $(ENV_NAME) pytest tests/

clean:
	rm -rf .nextflow scratch/ results/ .pytest_cache/

report:
	@echo "📄 Génération du rapport..."
	conda run -n $(ENV_NAME) python autoomics/report_generator.py
