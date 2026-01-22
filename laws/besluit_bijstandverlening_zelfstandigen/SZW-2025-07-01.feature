# NOTE: Date arithmetic operations (einddatum_bijstand, volgende_herbeoordelingsdatum) are not yet supported
# These outputs would require ADD_MONTHS or similar date operations that need to be implemented in the platform

Feature: Bijstand voor beginnende zelfstandigen (Bbz 2004 Artikel 23)
  Als persoon die vanuit werkloosheid een bedrijf begint
  Wil ik weten of ik recht heb op Bbz bijstand en voor welke duur
  Zodat ik financiële ondersteuning kan krijgen tijdens het opstarten van mijn onderneming

  Background:
    Given de datum is "2025-08-01"
    And een persoon met BSN "999993653"

  Scenario: Beginnende zelfstandige krijgt bijstand voor 18 maanden (standaard vanaf 2025-07-01)
    Given de volgende KVK inschrijvingen gegevens:
      | bsn       | rechtsvorm  | status | activiteit      |
      | 999993653 | EENMANSZAAK | ACTIEF | Grafisch ontwerp |
    And de parameter "STARTDATUM_ONDERNEMING" is "2025-07-01"
    And de parameter "EINDDATUM_WW_UITKERING" is "2025-06-30"
    When de besluit_bijstandverlening_zelfstandigen wordt uitgevoerd door SZW
    Then is voldaan aan de voorwaarden
    And is de maximale duur "18" maanden

  Scenario: Persoon zonder actieve onderneming krijgt geen Bbz bijstand
    Given de volgende KVK inschrijvingen gegevens:
      | bsn       | rechtsvorm  | status   | activiteit |
      | 999993653 | EENMANSZAAK | GESTOPT  | Webdesign  |
    And de parameter "STARTDATUM_ONDERNEMING" is "2024-01-01"
    And de parameter "EINDDATUM_WW_UITKERING" is "2023-12-31"
    When de besluit_bijstandverlening_zelfstandigen wordt uitgevoerd door SZW
    Then is niet voldaan aan de voorwaarden

  Scenario: Verlenging tot 36 maanden na positieve herbeoordeling levensvatbaarheid
    Given de volgende KVK inschrijvingen gegevens:
      | bsn       | rechtsvorm  | status | activiteit     |
      | 999993653 | EENMANSZAAK | ACTIEF | Thuiszorg      |
    And de parameter "STARTDATUM_ONDERNEMING" is "2025-07-01"
    And de parameter "EINDDATUM_WW_UITKERING" is "2025-06-30"
    And de parameter "IS_HERBEOORDELING_LEVENSVATBAAR" is "true"
    When de besluit_bijstandverlening_zelfstandigen wordt uitgevoerd door SZW
    Then is voldaan aan de voorwaarden
    And is de maximale duur "36" maanden

  Scenario: Verlenging tot 36 maanden wegens medische redenen zonder herbeoordeling
    Given de volgende KVK inschrijvingen gegevens:
      | bsn       | rechtsvorm | status | activiteit        |
      | 999993653 | VOF        | ACTIEF | Cateringbedrijf   |
    And de parameter "STARTDATUM_ONDERNEMING" is "2025-07-01"
    And de parameter "EINDDATUM_WW_UITKERING" is "2025-06-30"
    And de parameter "IS_MEDISCHE_OF_SOCIALE_REDEN" is "true"
    When de besluit_bijstandverlening_zelfstandigen wordt uitgevoerd door SZW
    Then is voldaan aan de voorwaarden
    And is de maximale duur "36" maanden

  Scenario: Geen verlenging als bedrijf niet levensvatbaar blijkt na herbeoordeling
    Given de volgende KVK inschrijvingen gegevens:
      | bsn       | rechtsvorm  | status | activiteit    |
      | 999993653 | EENMANSZAAK | ACTIEF | Webshop       |
    And de parameter "STARTDATUM_ONDERNEMING" is "2025-01-15"
    And de parameter "EINDDATUM_WW_UITKERING" is "2025-01-14"
    And de parameter "IS_HERBEOORDELING_LEVENSVATBAAR" is "false"
    When de besluit_bijstandverlening_zelfstandigen wordt uitgevoerd door SZW
    Then is voldaan aan de voorwaarden
    And is de maximale duur "18" maanden

  Scenario: VOF partner met WW-uitkering start onderneming
    Given de volgende KVK inschrijvingen gegevens:
      | bsn       | rechtsvorm | status | activiteit      |
      | 999993653 | VOF        | ACTIEF | Bouwbedrijf     |
    And de parameter "STARTDATUM_ONDERNEMING" is "2025-07-15"
    And de parameter "EINDDATUM_WW_UITKERING" is "2025-07-14"
    When de besluit_bijstandverlening_zelfstandigen wordt uitgevoerd door SZW
    Then is voldaan aan de voorwaarden
    And is de maximale duur "18" maanden

  Scenario: Combinatie van levensvatbare herbeoordeling en medische reden geeft 36 maanden
    Given de volgende KVK inschrijvingen gegevens:
      | bsn       | rechtsvorm  | status | activiteit     |
      | 999993653 | EENMANSZAAK | ACTIEF | Fysiotherapie  |
    And de parameter "STARTDATUM_ONDERNEMING" is "2025-06-01"
    And de parameter "EINDDATUM_WW_UITKERING" is "2025-05-31"
    And de parameter "IS_HERBEOORDELING_LEVENSVATBAAR" is "true"
    And de parameter "IS_MEDISCHE_OF_SOCIALE_REDEN" is "true"
    When de besluit_bijstandverlening_zelfstandigen wordt uitgevoerd door SZW
    Then is voldaan aan de voorwaarden
    And is de maximale duur "36" maanden

  Scenario: Onderneming met status TIJDELIJK_GESTAAKT blijft in aanmerking voor bijstand
    Given de volgende KVK inschrijvingen gegevens:
      | bsn       | rechtsvorm  | status             | activiteit   |
      | 999993653 | EENMANSZAAK | TIJDELIJK_GESTAAKT | Eventbedrijf |
    And de parameter "STARTDATUM_ONDERNEMING" is "2025-04-01"
    And de parameter "EINDDATUM_WW_UITKERING" is "2025-03-31"
    When de besluit_bijstandverlening_zelfstandigen wordt uitgevoerd door SZW
    Then is voldaan aan de voorwaarden
    And is de maximale duur "18" maanden
