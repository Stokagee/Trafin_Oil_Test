## 📌 **Jak spustit testy**

    Pokud máte docker spusťte z rootu repozitáře v PowerShellu

    docker run --rm -v ${PWD}:/test --ipc=host marketsquare/robotframework-browser:latest bash -c "pip install --break-system-packages -r /test/Requirements.txt; robot --variable BASE_URL:https://to-barrel-monitor.azurewebsites.net/ --output-dir /test/output /test/Tests"
    
    A nebo

1. **Vytvořte a aktivujte virtuální prostředí** (doporučeno pro izolaci závislostí)
    
    ```bash
    bash
    Zkopírovat
    python -m venv venv
    source venv/bin/activate  # Linux/macOS
    venv\Scripts\activate     # Windows
    
    ```
    
2. **Nainstalujte závislosti**
    
    ```bash
    bash
    Zkopírovat
    pip install -r requirements.txt
    
        
3. **Spusťte testy pomocí Robot Frameworku**
    
    ```bash
    bash
    Najeď do rootu repozitáře
    Zkopírovat
    robot --variable BASE_URL:https://to-barrel-monitor.azurewebsites.net .

    
    ```
    
    - `d results` zajistí, že výstupy testů budou uloženy do složky `results`.

---

## 📌 **Požadavky a závislosti**

- **Python** ≥ 3.7
- **Robot Framework**
- **RequestsLibrary** (pro HTTP požadavky)
- **Další závislosti** uvedené v `requirements.txt`

Pokud `requirements.txt` není přiložen, vytvořte ho a doplňte závislosti:

```
txt
Zkopírovat
robotframework
robotframework-requests

```

Nainstalujte je pak pomocí:

```bash
bash
Zkopírovat
pip install -r requirements.txt

```

---

## 📌 **Přehled testovacích scénářů**

Testy pokrývají následující API operace:

### ✅ **Základní funkčnost**

- **Vytvoření barelu** (`POST /barrels`)
- **Získání seznamu všech barelů** (`GET /barrels`)
- **Přidání měření nečistot k barelu** (`POST /measurements`)
- **Získání všech měření** (`GET /measurements`)
- **Získání detailu konkrétního barelu** (`GET /barrels/{id}`)
- **Smazání konkrétního barelu** (`DELETE /barrels/{id}`)

### 🚨 **Edge-case scénáře**

- Odeslání nevalidních dat (např. chybějící nebo špatně zadané hodnoty).
- Operace na neexistujících ID (např. pokus o smazání neexistujícího barelu).
- Ověření maximálních délek vstupních hodnot.
- Testy na speciální znaky v hodnotách.

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 📌 **How to Run Tests**  

    If u have Docker go to root repository and run in PowerShell

    docker run --rm -v ${PWD}:/test --ipc=host marketsquare/robotframework-browser:latest bash -c "pip install --break-system-packages -r /test/Requirements.txt; robot --variable BASE_URL:https://to-barrel-monitor.azurewebsites.net/ --output-dir /test/output /test/Tests"

    Or 

1. **Create and activate a virtual environment** (recommended for dependency isolation)  

    ```bash
    python -m venv venv
    source venv/bin/activate  # Linux/macOS
    venv\Scripts\activate     # Windows
    ```

2. **Install dependencies**  

    ```bash
    pip install -r requirements.txt

3. **Run tests using Robot Framework**  

    ```bash
    Go to root repository
    robot --variable BASE_URL:https://to-barrel-monitor.azurewebsites.net .
    ```

    - `-d results` ensures that test outputs are saved in the `results` folder.  

---

## 📌 **Requirements and Dependencies**  

- **Python** ≥ 3.7  
- **Robot Framework**  
- **RequestsLibrary** (for HTTP requests)  
- **Additional dependencies** listed in `requirements.txt`  

If `requirements.txt` is missing, create it and add the dependencies:  

    ```txt
    robotframework
    robotframework-requests
    ```

Then install them using:  

    ```bash
    pip install -r requirements.txt
    ```

---

## 📌 **Test Scenario Overview**  

The tests cover the following API operations:  

### ✅ **Basic Functionality**  

- **Create a barrel** (`POST /barrels`)  
- **Retrieve a list of all barrels** (`GET /barrels`)  
- **Add impurity measurement to a barrel** (`POST /measurements`)  
- **Retrieve all measurements** (`GET /measurements`)  
- **Get details of a specific barrel** (`GET /barrels/{id}`)  
- **Delete a specific barrel** (`DELETE /barrels/{id}`)  

### 🚨 **Edge-Case Scenarios**  

- Sending invalid data (e.g., missing or incorrectly formatted values).  
- Performing operations on non-existent IDs (e.g., attempting to delete a non-existent barrel).  
- Verifying maximum input lengths.  
- Testing special characters in input values.  









