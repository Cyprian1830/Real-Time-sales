# 📊 Real-Time Sales & Inventory Analytics with Azure
### Kappa / Lambda Hybrid Architecture

---

## 👥 Autorzy
- **Bartłomiej Żurek**
- **Cyprian Szot**

---

## 📝 Opis projektu

Celem projektu jest budowa systemu **real-time analytics** do przetwarzania zdarzeń sprzedażowych z wykorzystaniem usług **Microsoft Azure**.  
System obsługuje zarówno **strumieniowe przetwarzanie danych (near real-time)**, jak i **warstwę batch**, zgodnie z podejściem **Kappa / Lambda Hybrid**.

Zdarzenia sprzedaży są generowane w czasie rzeczywistym, przetwarzane w **Azure Databricks**, a wyniki zapisywane do **Delta Lake (Azure Data Lake Storage Gen2)** oraz **Azure Database for PostgreSQL** w celu dalszej analizy SQL.

---

## 🏗 Architektura i przepływ danych

**Przepływ danych:**

1. Generator zdarzeń sprzedaży (Python)
2. **Azure Event Hubs** – ingest danych
3. **Azure Databricks (Structured Streaming)**
   - Bronze – surowe dane
   - Silver – agregacje czasowe
   - Gold – dane analityczne i alerty stock-out
4. **Azure Data Lake Storage Gen2 (Delta Lake)**
5. **Azure Database for PostgreSQL** – warstwa analityczna SQL
6. **Azure Monitor & Log Analytics** – monitoring i alerty

---

## 🔄 Warstwy danych

### 🟤 Bronze Layer
- Surowe zdarzenia z Azure Event Hubs  
- Minimalna transformacja danych  
- Dane przechowywane w formacie **Delta Lake**

### ⚪ Silver Layer
- Agregacje czasowe (windowed aggregations)
- Metryki:
  - `total_qty`
  - `total_revenue`
- Obsługa pól `eventTime` oraz `ingest_time`

### 🟡 Gold Layer
- **Daily batch analytics**
- **Stock-out alerts**
- Dane gotowe do raportowania i zapytań SQL

---

## 🚨 Stock-out Detection

Stock-out definiowany jest jako:
> brak sprzedaży danego produktu w danym sklepie w określonym oknie czasowym.

**Mechanizm detekcji:**
- agregacja strumieniowa danych sprzedażowych
- filtracja zerowej sprzedaży
- zapis alertów do warstwy Gold (`gold_stockout`)

---

## 🗃 Warstwa Batch

Raz dziennie wykonywana jest agregacja batch obejmująca:
- sprzedaż dzienną
- sumę sprzedanych ilości
- sumę przychodów

**Wyniki zapisywane są do:**
- Delta Lake (`gold_daily_sales`)
- Azure Database for PostgreSQL (`gold_daily_sales`)

---

## 📈 Monitoring & Observability

System wykorzystuje **Azure Monitor** oraz **Log Analytics** do monitorowania kluczowych komponentów:

### Monitorowane usługi:
- **Azure Event Hubs**
  - liczba zdarzeń
  - brak ingestu danych
- **Azure Databricks**
  - status jobów
  - błędy przetwarzania
- **Azure Storage**
  - dostępność
  - błędy zapisu
- **PostgreSQL**
  - połączenia
  - dostępność bazy

### Skonfigurowane alerty:
- brak danych wejściowych
- problemy operacyjne workspace
- przekroczenie limitów ingestu w Log Analytics

---

## 🧠 Technologie

- Azure Event Hubs  
- Azure Databricks (PySpark, Structured Streaming)  
- Delta Lake  
- Azure Data Lake Storage Gen2  
- Azure Database for PostgreSQL  
- Azure Monitor & Log Analytics  
- Terraform  
- GitHub Actions  

---

## ✅ Status projektu

✔ Real-time ingest danych  
✔ Streaming analytics  
✔ Batch analytics  
✔ Stock-out detection  
✔ SQL analytics (PostgreSQL)  
✔ Monitoring i alerting  

**Projekt zakończony.**
