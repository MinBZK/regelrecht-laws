Feature: Machtigingenwet - Delegation provider for KVK
  Als ondernemer
  Wil ik namens mijn bedrijf kunnen handelen
  Zodat ik regelingen kan aanvragen voor mijn onderneming

  Background:
    Given de datum is "2025-03-01"
    And een persoon met BSN "999993653"

  Scenario: Ondernemer met actieve inschrijving heeft delegatie
    Given de volgende KVK functionarissen gegevens
      | bsn       | kvk_nummer | handelsnaam       | rechtsvorm  | status | functie  | bevoegdheid |
      | 999993653 | 12345678   | Test Onderneming  | EENMANSZAAK | ACTIEF | EIGENAAR | VOLLEDIG    |
    When de machtigingenwet wordt uitgevoerd door KVK
    Then heeft de output "heeft_delegaties" waarde "true"
    And bevat de output "subject_ids" waarde "12345678"
    And bevat de output "subject_names" waarde "Test Onderneming"
    And bevat de output "subject_types" waarde "BUSINESS"
    And bevat de output "delegation_types" waarde "EIGENAAR"

  Scenario: Persoon zonder inschrijvingen heeft geen delegaties
    Given de volgende KVK functionarissen gegevens
      | bsn       | kvk_nummer | handelsnaam | rechtsvorm  | status | functie  | bevoegdheid |
      | 111111111 | 00000000   | Leeg        | EENMANSZAAK | ACTIEF | EIGENAAR | VOLLEDIG    |
    When de machtigingenwet wordt uitgevoerd door KVK
    Then heeft de output "heeft_delegaties" waarde "false"

  Scenario: Ondernemer met meerdere bedrijven heeft meerdere delegaties
    Given de volgende KVK functionarissen gegevens
      | bsn       | kvk_nummer | handelsnaam    | rechtsvorm  | status | functie  | bevoegdheid |
      | 999993653 | 11111111   | Bedrijf Een    | EENMANSZAAK | ACTIEF | EIGENAAR | VOLLEDIG    |
      | 999993653 | 22222222   | Bedrijf Twee   | VOF         | ACTIEF | VENNOOT  | BEPERKT     |
    When de machtigingenwet wordt uitgevoerd door KVK
    Then heeft de output "heeft_delegaties" waarde "true"
    And bevat de output "subject_ids" waarde "11111111"
    And bevat de output "subject_ids" waarde "22222222"

  Scenario: Commissaris heeft geen vertegenwoordigingsbevoegdheid
    # Art. 2:240 BW: alleen bestuurders, eigenaren en gemachtigden zijn bevoegd
    # Commissarissen zijn toezichthouders en hebben GEEN vertegenwoordigingsbevoegdheid
    Given de volgende KVK functionarissen gegevens
      | bsn       | kvk_nummer | handelsnaam      | rechtsvorm | status | functie     | bevoegdheid |
      | 999993653 | 33333333   | Holdings BV      | BV         | ACTIEF | COMMISSARIS | GEEN        |
    When de machtigingenwet wordt uitgevoerd door KVK
    Then heeft de output "heeft_delegaties" waarde "false"
    And is de output "subject_ids" leeg

  Scenario: Gemengde rollen - alleen bevoegde functies krijgen delegatie
    # Persoon heeft meerdere functies bij verschillende bedrijven
    # Alleen EIGENAAR en VENNOOT zijn bevoegd, COMMISSARIS niet
    Given de volgende KVK functionarissen gegevens
      | bsn       | kvk_nummer | handelsnaam           | rechtsvorm  | status | functie     | bevoegdheid |
      | 999993653 | 44444444   | Eigen Bedrijf         | EENMANSZAAK | ACTIEF | EIGENAAR    | VOLLEDIG    |
      | 999993653 | 55555555   | Zorggroep VOF         | VOF         | ACTIEF | VENNOOT     | BEPERKT     |
      | 999993653 | 66666666   | Toezicht Holdings BV  | BV          | ACTIEF | COMMISSARIS | GEEN        |
    When de machtigingenwet wordt uitgevoerd door KVK
    Then heeft de output "heeft_delegaties" waarde "true"
    And bevat de output "subject_ids" waarde "44444444"
    And bevat de output "subject_ids" waarde "55555555"
    And bevat de output "subject_ids" niet de waarde "66666666"
    And bevat de output "subject_names" waarde "Eigen Bedrijf"
    And bevat de output "subject_names" waarde "Zorggroep VOF"
    And bevat de output "subject_names" niet de waarde "Toezicht Holdings BV"
    And bevat de output "delegation_types" waarde "EIGENAAR"
    And bevat de output "delegation_types" waarde "VENNOOT"
    And bevat de output "delegation_types" niet de waarde "COMMISSARIS"

  Scenario: Bestuurder van BV heeft delegatie
    Given de volgende KVK functionarissen gegevens
      | bsn       | kvk_nummer | handelsnaam      | rechtsvorm | status | functie    | bevoegdheid |
      | 999993653 | 77777777   | Tech Solutions BV| BV         | ACTIEF | BESTUURDER | VOLLEDIG    |
    When de machtigingenwet wordt uitgevoerd door KVK
    Then heeft de output "heeft_delegaties" waarde "true"
    And bevat de output "subject_ids" waarde "77777777"
    And bevat de output "delegation_types" waarde "BESTUURDER"

  Scenario: Gemachtigde heeft delegatie
    # Art. 2:240 lid 4 BW: statuten kunnen ook aan anderen bevoegdheid toekennen
    Given de volgende KVK functionarissen gegevens
      | bsn       | kvk_nummer | handelsnaam    | rechtsvorm | status | functie     | bevoegdheid |
      | 999993653 | 88888888   | Groot Bedrijf BV| BV        | ACTIEF | GEMACHTIGDE | BEPERKT     |
    When de machtigingenwet wordt uitgevoerd door KVK
    Then heeft de output "heeft_delegaties" waarde "true"
    And bevat de output "subject_ids" waarde "88888888"
    And bevat de output "delegation_types" waarde "GEMACHTIGDE"
