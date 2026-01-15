Feature: Machtigingenwet - Delegation provider for KVK
  Als ondernemer
  Wil ik namens mijn bedrijf kunnen handelen
  Zodat ik regelingen kan aanvragen voor mijn onderneming

  Background:
    Given de datum is "2025-03-01"
    And een persoon met BSN "999993653"

  Scenario: Ondernemer met actieve inschrijving heeft delegatie
    Given de volgende KVK inschrijvingen gegevens
      | bsn       | kvk_nummer | handelsnaam       | rechtsvorm  | status |
      | 999993653 | 12345678   | Test Onderneming  | EENMANSZAAK | ACTIEF |
    And de volgende KVK functionarissen gegevens
      | bsn       | kvk_nummer | functie  | bevoegdheid |
      | 999993653 | 12345678   | EIGENAAR | VOLLEDIG    |
    When de machtigingenwet wordt uitgevoerd door KVK
    Then heeft de output "heeft_delegaties" waarde "true"
    And bevat de output "subject_ids" waarde "12345678"
    And bevat de output "subject_names" waarde "Test Onderneming"
    And bevat de output "subject_types" waarde "BUSINESS"
    And bevat de output "delegation_types" waarde "EIGENAAR"

  Scenario: Persoon zonder inschrijvingen heeft geen delegaties
    Given de volgende KVK inschrijvingen gegevens
      | bsn       | kvk_nummer | handelsnaam | rechtsvorm | status |
      | 111111111 | 00000000   | Leeg        | EENMANSZAAK| ACTIEF |
    And de volgende KVK functionarissen gegevens
      | bsn       | kvk_nummer | functie | bevoegdheid |
      | 111111111 | 00000000   | EIGENAAR| VOLLEDIG    |
    When de machtigingenwet wordt uitgevoerd door KVK
    Then heeft de output "heeft_delegaties" waarde "false"

  Scenario: Ondernemer met meerdere bedrijven heeft meerdere delegaties
    Given de volgende KVK inschrijvingen gegevens
      | bsn       | kvk_nummer | handelsnaam    | rechtsvorm  | status |
      | 999993653 | 11111111   | Bedrijf Een    | EENMANSZAAK | ACTIEF |
      | 999993653 | 22222222   | Bedrijf Twee   | VOF         | ACTIEF |
    And de volgende KVK functionarissen gegevens
      | bsn       | kvk_nummer | functie  | bevoegdheid |
      | 999993653 | 11111111   | EIGENAAR | VOLLEDIG    |
      | 999993653 | 22222222   | VENNOOT  | BEPERKT     |
    When de machtigingenwet wordt uitgevoerd door KVK
    Then heeft de output "heeft_delegaties" waarde "true"
    And bevat de output "subject_ids" waarde "11111111"
    And bevat de output "subject_ids" waarde "22222222"
