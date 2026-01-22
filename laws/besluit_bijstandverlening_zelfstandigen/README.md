# Besluit bijstandverlening zelfstandigen 2004 (Bbz 2004)

## Overzicht

Dit besluit regelt bijstand aan zelfstandigen en ondernemers. Het Bbz 2004 is gebaseerd op de Participatiewet en vormt een aanvullend stelsel voor bijstandverlening aan personen die een eigen bedrijf of beroep uitoefenen.

- **BWB-ID**: BWBR0015711
- **Officiële naam**: Besluit bijstandverlening zelfstandigen 2004
- **Basis**: Participatiewet (BWBR0015703)
- **Uitvoering**: Gemeenten (coördinatie: Ministerie SZW)

## Implementaties in deze directory

### SZW-2025-07-01.yaml

**Artikel 23: Duur algemene bijstand beginnende zelfstandige**

Deze implementatie regelt de duur van algemene bijstand voor personen die vanuit werkloosheid een bedrijf of zelfstandig beroep beginnen.

**Belangrijkste wijziging per 2025-07-01** (Staatsblad 2025, 220):
- **Oude situatie**: Bijstand voor maximaal 36 maanden
- **Nieuwe situatie**: Bijstand voor maximaal 18 maanden
- **Verlenging mogelijk**: Tot 36 maanden na herbeoordeling levensvatbaarheid bedrijf
- **Verlenging bij medische/sociale redenen**: Ook mogelijk tot 36 maanden

**Voorwaarden**:
1. Persoon ontving werkloosheidsuitkering (WW)
2. Persoon is actieve ondernemer (geregistreerd bij KVK)
3. Bedrijf is levensvatbaar (beoordeling door gemeente)

**Herbeoordeling levensvatbaarheid**:
- Na 6 maanden vanaf start bijstand
- Daarna opnieuw na 6 maanden (totaal 12 maanden)
- Daarna opnieuw na 12 maanden (totaal 24 maanden)
- Bij verlenging wegens medische/sociale redenen: jaarlijks

**Parameters**:
- `BSN`: Identificatie van de persoon (verplicht)
- `STARTDATUM_ONDERNEMING`: Datum start bedrijf (verplicht)
- `EINDDATUM_WW_UITKERING`: Datum einde WW-uitkering (verplicht)
- `IS_MEDISCHE_OF_SOCIALE_REDEN`: Bedrijf kan niet volledig worden uitgeoefend (optioneel)
- `IS_HERBEOORDELING_LEVENSVATBAAR`: Herbeoordeling levensvatbaarheid positief (optioneel)

**Output**:
- `heeft_recht_op_bijstand`: Boolean - recht op Bbz bijstand
- `maximale_duur_maanden`: Number - maximale duur in maanden (18 of 36)
- `einddatum_bijstand`: Date - datum waarop bijstand eindigt
- `volgende_herbeoordelingsdatum`: Date - datum volgende herbeoordeling
- `reden_geen_recht`: String - reden bij afwijzing

## Relaties met andere wetten

### Directe afhankelijkheden (service references)

De Bbz 2004 implementatie maakt gebruik van de volgende andere wetten:

1. **Handelsregisterwet (KVK-2024-01-01.yaml)**
   - Output gebruikt: `is_actieve_ondernemer`
   - Doel: Verificatie dat persoon actief ingeschreven staat als ondernemer
   - Locatie: `laws/handelsregisterwet/KVK-2024-01-01.yaml`

2. **Werkloosheidswet** (nog te implementeren)
   - Benodigde output: `einddatum_uitkering`, `heeft_recht_op_ww`
   - Doel: Verificatie dat persoon werkloosheidsuitkering ontving/ontvangt
   - Status: Deze service reference is nog niet geïmplementeerd in het huidige YAML

### Indirecte relaties

De Bbz 2004 is gerelateerd aan maar niet afhankelijk van:

1. **Participatiewet (participatiewet/bijstand/SZW-2023-01-01.yaml)**
   - Relatie: Bbz 2004 is gebaseerd op Participatiewet
   - Geen directe service reference: Bbz 2004 vervangt reguliere bijstand voor startende ondernemers
   - Personen die in aanmerking komen voor Bbz komen niet in aanmerking voor reguliere bijstand

2. **BRP (Basisregistratie Personen)** (wet_brp/RvIG-2020-01-01.yaml)
   - Potentiële toekomstige integratie voor verificatie woonadres en identiteit
   - Momenteel niet geïmplementeerd in service references

## Impact van wijziging 2025-07-01

### Wat verandert er?

**Voor beginnende ondernemers**:
- Initiële termijn verkort van 36 naar 18 maanden
- Na 18 maanden: herbeoordeling noodzakelijk voor verlenging tot 36 maanden
- Gemeente moet levensvatbaarheid bedrijf opnieuw beoordelen

**Voor gemeenten**:
- Strengere monitoring van levensvatbaarheid vereist
- Herbeoordelingsmomenten blijven gelijk (6, 12, 24 maanden)
- Bij positieve herbeoordeling: verlenging tot maximaal 36 maanden mogelijk

### Wat blijft gelijk?

- Doelgroep: personen die vanuit WW een bedrijf starten
- Herbeoordelingsschema: 6, 12, 24 maanden
- Mogelijkheid tot verlenging bij medische/sociale redenen
- Maximale totale duur: 36 maanden (na herbeoordeling)
- Beëindiging bij niet-levensvatbaar bedrijf (artikel 23 lid 2)

## Toekomstige ontwikkelingen

### Te implementeren

1. **Werkloosheidswet YAML**
   - Noodzakelijk voor volledige implementatie Bbz artikel 23
   - Moet output leveren: `heeft_recht_op_ww`, `einddatum_uitkering`
   - Uitvoerende dienst: UWV

2. **Gemeentelijke implementaties**
   - Vergelijkbaar met `participatiewet/bijstand/gemeenten/GEMEENTE_*.yaml`
   - Gemeenten kunnen eigen beleid toevoegen binnen landelijk kader
   - Bijvoorbeeld aanvullende voorwaarden voor levensvatbaarheidsbeoordeling

3. **Andere artikelen Bbz 2004**
   - Artikel 18: Kapitaalverstrekking levensvatbare ondernemers
   - Artikel 27a: Bijstand bij beëindiging onderneming (nieuw per 2025-07-01)
   - Artikel 17a: Experimenten (nieuw per 2025-07-01, max 3 jaar)

### Participatiewet in Balans

De wijziging per 2025-07-01 (Stb. 2025, 220) implementeert een deel van de "Participatiewet in Balans" hervorming in het Bbz 2004. De grotere hervorming van de Participatiewet zelf is gepland voor 2026-01-01.

**Belangrijke noot**: Artikel 60ba Bbz 2004 (nieuw per 2025-07-01) bepaalt expliciet welke artikelen van de Participatiewet in Balans **niet** van toepassing zijn op het Bbz 2004, waaronder:
- Artikel 34 (vermogenstoets)
- Artikel 43a (vereenvoudigde terugkeer)
- Artikel 32 lid 2 en 5 (geautomatiseerde inkomensverrekening)
- Artikel 34a (verhoogde vrijlatingen werk)
- Artikel 34b (bufferbudget)
- Artikelen 10a-10h (nieuwe bepalingen)
- Artikel 45 (nieuwe bepalingen)

## Bronnen

- [Besluit bijstandverlening zelfstandigen 2004 (wetten.overheid.nl)](https://wetten.overheid.nl/BWBR0015711)
- [Staatsblad 2025, 220 (wijziging artikel 23)](https://zoek.officielebekendmakingen.nl/stb-2025-220.html)
- [Participatiewet (wetten.overheid.nl)](https://wetten.overheid.nl/BWBR0015703)
- [Handelsregisterwet 2007 (wetten.overheid.nl)](https://wetten.overheid.nl/BWBR0021777)

## Metadata

- **Laatst bijgewerkt**: 2025-10-28
- **Schema versie**: v0.1.6
- **Status**: Geïmplementeerd per 2025-07-01
