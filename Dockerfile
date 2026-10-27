# --- Étape 1 : Builder (Installation des dépendances) ---
FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# --- Étape 2 : Image Finale (Légère et sécurisée) ---
FROM python:3.11-slim
WORKDIR /app

# Création d'un utilisateur non-root (Sécurité)
RUN useradd -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

# Copie des dépendances depuis l'étape builder
COPY --from=builder /root/.local /home/appuser/.local
COPY --chown=appuser:appuser . .

ENV PATH=/home/appuser/.local/bin:$PATH
EXPOSE 5000

CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:5000", "app:app"]