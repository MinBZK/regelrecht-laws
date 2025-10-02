# Regels voor het omzetten van wetten naar YAML

Dit document beschrijft de werkwijze voor het correct implementeren van Nederlandse wetgeving in YAML formaat volgens het regelrecht-laws schema.

## Algemene principes

### 1. Volg de praktijk, niet alleen de theorie
- **Wat de wet toestaat ≠ wat er daadwerkelijk gebruikt wordt**
- Onderzoek altijd wat er in de praktijk gebeurt
- Implementeer realistische databronnen die daadwerkelijk beschikbaar zijn
- Voorbeeld: LAA wet staat nutsverbruiksgegevens toe (Art. 28e), maar deze worden niet gebruikt in praktijk

### 2. Juiste wet bij juiste organisatie
- Elke wet/regeling hoort bij de organisatie die deze uitvoert
- Splits wetten op als meerdere organisaties betrokken zijn
- Gebruik `service` field voor de uitvoerende organisatie

**Voorbeelden:**
```yaml
# Wet BAG
service: "KADASTER"  # Kadaster distribueert BAG data

# BRP Terugmeldplicht
service: "BELASTINGDIENST"  # Belastingdienst meldt twijfel
service: "TOESLAGEN"        # Toeslagen meldt twijfel
service: "CJIB"             # CJIB meldt twijfel

# LAA
service: "RvIG"  # RvIG coördineert LAA namens minister BZK
```

### 3. Gebruik service_references waar mogelijk
- Vermijd directe `source_reference` als gegevens van andere diensten komen
- Gebruik `input` met `service_reference` voor gegevens van andere wetten
- Dit creëert een netwerk van onderling verbonden wetten

**Voorbeeld:**
```yaml
input:
  - name: "BAG_GEBRUIKSDOEL"
    type: "string"
    service_reference:
      service: "KADASTER"
      law: "wet_bag"
      field: "gebruiksdoel"
      parameters:
        - name: "ADRES"
          reference: "$ADRES"
```

### 4. Parameters: required vs optional
- Maak parameters alleen `required: true` als ze **altijd** nodig zijn
- Analyseer verschillende gebruiksscenario's
- Voorbeeld LAA:
  - `ADRES` → required (altijd nodig)
  - `BSN` → optional (alleen bij persoonsgerichte meldingen)

## Onderzoeksproces

### Stap 1: Identificeer de wet
1. Zoek de officiële wettekst op wetten.overheid.nl
2. Bepaal het BWB-ID (bijv. BWBR0033715)
3. Identificeer relevante artikelen

### Stap 2: Bepaal wat de wet daadwerkelijk regelt
**Let op**: Niet alle wetten regelen databronnen!

**Voorbeelden:**
- **LAA wet** regelt NIET de adresgegevens zelf, maar de **methode** om adreskwaliteit te controleren
- **Wet BRP Art. 2.34** regelt de **terugmeldplicht**, niet de gegevens
- **Wet BAG** regelt WEL de gegevens (gebruiksdoel, oppervlakte, etc.)

### Stap 3: Onderzoek de praktijk
Zoek naar:
- Implementatierapporten
- Evaluaties
- Algoritmeregister (algoritmes.overheid.nl)
- Beleidsregels en circulaires
- Welke organisaties zijn daadwerkelijk signaalleveranciers?

**Voorbeeld LAA:**
```
Wet zegt: nutsverbruik, waterverbruik, BAG, BRP mogelijk
Praktijk: alleen Belastingdienst, Toeslagen, CJIB meldingen + BAG + BRP
→ Implementeer wat daadwerkelijk wordt gebruikt
```

### Stap 4: Identificeer databronnen
Bepaal voor elke databron:
1. **Wie is eigenaar?** (welke organisatie heeft de data)
2. **Bestaat er al een YAML?** (check bestaande wetten)
3. **Moet nieuwe YAML gemaakt worden?**

## Structuur en naamgeving

### Directory structuur
```
laws/
  wet_naam/
    ORGANISATIE-YYYY-MM-DD.yaml          # Hoofdwet
    subdomein/
      ORGANISATIE-YYYY-MM-DD.yaml        # Specifieke implementatie
```

**Voorbeelden:**
```
laws/wet_brp/
  RvIG-2020-01-01.yaml                   # BRP algemeen
  terugmelding/
    BELASTINGDIENST-2023-05-15.yaml      # Terugmeldplicht per organisatie
    TOESLAGEN-2023-05-15.yaml
    CJIB-2023-05-15.yaml
  laa/
    RvIG-2023-05-15.yaml                 # LAA coördinatie

laws/wet_bag/
  KADASTER-2018-07-28.yaml               # BAG distributie
```

### Bestandsnaamconventies
- Format: `{SERVICE}-{YYYY-MM-DD}.yaml`
- Service: HOOFDLETTERS
- Datum: `valid_from` datum uit de wet
- Gebruik organisatie-afkortingen: BELASTINGDIENST, TOESLAGEN, CJIB, KADASTER, RvIG

## YAML velden specificatie

### Verplichte metadata
```yaml
$id: https://raw.githubusercontent.com/MinBZK/poc-machine-law/refs/heads/main/schema/v0.1.6/schema.json
uuid: xxxxxxxx-xxxx-4xxx-xxxx-xxxxxxxxxxxx  # Let op: versie 4 UUID (4 op positie 13)
name: "Korte beschrijvende naam"
law: wet_naam
law_type: "FORMELE_WET"
legal_character: "BESCHIKKING"  # of "BESLUIT_VAN_ALGEMENE_STREKKING"
decision_type: "TOEKENNING"     # of "ANDERE_HANDELING", etc.
valid_from: 2023-05-15
service: "ORGANISATIE"
```

### Legal basis structuur
Elk veld/actie moet een `legal_basis` hebben:
```yaml
legal_basis:
  law: "Volledige naam van de wet"
  bwb_id: "BWBR0012345"
  article: "2.34"
  paragraph: "1"           # optioneel
  sentence: "2"            # optioneel
  url: "https://wetten.overheid.nl/BWBR0012345/2024-01-01#..."
  juriconnect: "jci1.3:c:BWBR0012345&artikel=2.34&lid=1&z=2024-01-01&g=2024-01-01"
  explanation: "Artikel 2.34 lid 1 bepaalt dat..."
```

### Parameters vs Sources vs Input

**Parameters** - door gebruiker aangeleverd:
```yaml
parameters:
  - name: "BSN"
    type: "string"
    required: true  # of false
    description: "BSN van de persoon"
```

**Sources** - uit eigen databron van deze organisatie:
```yaml
sources:
  - name: "GEBOORTEDATUM"
    type: "date"
    source_reference:
      table: "personen"
      field: "geboortedatum"
      select_on:
        - name: "bsn"
          value: "$BSN"
```

**Input** - van andere organisaties/wetten:
```yaml
input:
  - name: "BAG_GEBRUIKSDOEL"
    type: "string"
    service_reference:
      service: "KADASTER"
      law: "wet_bag"
      field: "gebruiksdoel"
      parameters:
        - name: "ADRES"
          reference: "$ADRES"
```

### Output specificatie
```yaml
output:
  - name: "heeft_recht"
    description: "Of persoon recht heeft op toeslag"
    type: "boolean"
    temporal:
      type: "point_in_time"
      reference: "$calculation_date"
    legal_basis:
      law: "..."
      # etc.
```

## Validatie checklist

Voordat je commit:
1. ✅ Run `python3 script/validate.py`
2. ✅ Controleer: "All service references have corresponding outputs"
3. ✅ Controleer: "All variables are properly defined"
4. ✅ UUID is versie 4 format (4 op positie 13)
5. ✅ Alle legal_basis velden zijn ingevuld
6. ✅ Service naam komt overeen met daadwerkelijke organisatie

## Veelgemaakte fouten

### ❌ Fout: Theoretische databronnen gebruiken
```yaml
# FOUT: Staat in wet maar wordt niet gebruikt
sources:
  - name: "NUTSVERBRUIK"
    source_reference:
      table: "nutsverbruik"  # Bestaat niet bij RvIG!
```

### ✅ Correct: Realistische databronnen
```yaml
# CORRECT: Wordt daadwerkelijk gebruikt
input:
  - name: "BELASTINGDIENST_TWIJFEL"
    service_reference:
      service: "BELASTINGDIENST"
      law: "wet_brp"
      field: "heeft_gerede_twijfel_adres"
```

### ❌ Fout: Alles in één YAML
```yaml
# FOUT: LAA met alle meldingen in één bestand
name: "LAA met alle meldingen"
service: "RvIG"
# ... bevat ook Belastingdienst logica
```

### ✅ Correct: Gesplitste YAMLs
```yaml
# CORRECT: Elke organisatie eigen YAML
# wet_brp/terugmelding/BELASTINGDIENST-2023-05-15.yaml
service: "BELASTINGDIENST"

# wet_brp/laa/RvIG-2023-05-15.yaml
service: "RvIG"
# gebruikt service_references naar Belastingdienst
```

### ❌ Fout: Verkeerde service naam
```yaml
# FOUT: RvIG is distributor, niet eigenaar
name: "BAG gegevens"
service: "RvIG"  # FOUT!
```

### ✅ Correct: Juiste eigenaar
```yaml
# CORRECT: Kadaster distribueert BAG
name: "BAG gegevens"
service: "KADASTER"
```

## Bronnen voor onderzoek

### Primaire bronnen
- **wetten.overheid.nl** - Officiële wetteksten
- **zoek.officielebekendmakingen.nl** - Staatsbladen, kamerstukken
- **algoritmes.overheid.nl** - Algoritmeregister met profielen

### Secundaire bronnen
- **rijksoverheid.nl** - Beleid en uitvoering
- **Organisatie websites** - RvIG, Kadaster, Belastingdienst, etc.
- **VNG publicaties** - Gemeentelijke uitvoering
- **Evaluatierapporten** - Praktijkervaringen

## Voorbeeld: Volledige workflow LAA

1. **Onderzoek wet**: Besluit BRP Art. 28a-28g (LAA)
2. **Identificeer wat wet regelt**: Methode voor adreskwaliteitscontrole, NIET de gegevens zelf
3. **Onderzoek praktijk**:
   - Signaalleveranciers: Belastingdienst, Toeslagen, CJIB
   - Databronnen: BRP (aantal bewoners), BAG (gebruiksdoel)
   - Géén nutsverbruik in praktijk
4. **Maak YAMLs**:
   - `wet_bag/KADASTER-2018-07-28.yaml` (BAG gegevens)
   - `wet_brp/terugmelding/BELASTINGDIENST-2023-05-15.yaml` (Terugmeldplicht)
   - `wet_brp/terugmelding/TOESLAGEN-2023-05-15.yaml` (Terugmeldplicht)
   - `wet_brp/terugmelding/CJIB-2023-05-15.yaml` (Terugmeldplicht)
   - `wet_brp/laa/RvIG-2023-05-15.yaml` (LAA coördinatie met service_references)
5. **Valideer**: `python3 script/validate.py`
6. **Commit**: Met duidelijke beschrijving

## Tips

- **Begin simpel**: Implementeer eerst de hoofdstroom, voeg later edge cases toe
- **Hergebruik**: Kijk altijd eerst naar bestaande YAMLs voor voorbeelden
- **Documenteer**: Leg in comments uit waarom keuzes gemaakt zijn
- **Test service references**: Controleer dat alle referenced outputs bestaan
- **Wees kritisch**: Als iets theoretisch mogelijk is maar niet gebruikt wordt, laat het weg

---

*Laatst bijgewerkt: 2025-10-01*
*Schema versie: v0.1.6*
