Feature: Bepalen recht op re-integratie ondersteuning
  Als bijstandsgerechtigde
  Wil ik weten of ik in aanmerking kom voor re-integratie ondersteuning
  Zodat ik ondersteuning kan krijgen bij het vinden van werk

  Background:
    Given de datum is "2025-03-01"

  Scenario: Bijstandsgerechtigde komt in aanmerking voor re-integratie ondersteuning
    # Situatie: Een 35-jarige bijstandsontvanger die gezond en arbeidsbeschikbaar is,
    # heeft volgens artikel 7 lid 1 recht op re-integratie ondersteuning en volgens
    # artikel 9 lid 1 arbeidsverplichtingen om werk te zoeken en aan te nemen.
    Given een persoon met BSN "999993653"
    And de volgende RvIG personen gegevens:
      | bsn       | geboortedatum |
      | 999993653 | 1990-01-01    |
    And de volgende SVB ouderdomspensioenen gegevens:
      | geboortedatum | pensioenleeftijd |
      | 1990-01-01    | 67               |
    And de volgende SZW bijstand gegevens:
      | bsn       | is_gerechtigd |
      | 999993653 | true          |
    And de volgende UWV wia gegevens:
      | bsn       | is_volledig_duurzaam_arbeidsongeschikt |
      | 999993653 | false                                  |
    And de volgende SZW relaties gegevens:
      | bsn       | is_alleenstaande_ouder | heeft_kind_onder_leeftijd_12 |
      | 999993653 | false                  | false                        |
    When de participatiewet/reintegratie wordt uitgevoerd door SZW
    Then is voldaan aan de voorwaarden
    And is het is_gerechtigd_reintegratie "true"
    And is het heeft_arbeidsverplichting "true"
    And is het is_vrijgesteld_tegenprestatie "false"

  Scenario: Volledig en duurzaam arbeidsongeschikte persoon is vrijgesteld van verplichtingen
    # Situatie: Een persoon die volgens UWV volledig en duurzaam arbeidsongeschikt is
    # (artikel 9 lid 3 onder b), is vrijgesteld van arbeidsverplichtingen en tegenprestatie.
    # Deze persoon komt wel nog in aanmerking voor aangepaste re-integratie ondersteuning.
    Given een persoon met BSN "999993654"
    And de volgende RvIG personen gegevens:
      | bsn       | geboortedatum |
      | 999993654 | 1985-05-15    |
    And de volgende SVB ouderdomspensioenen gegevens:
      | geboortedatum | pensioenleeftijd |
      | 1985-05-15    | 67               |
    And de volgende SZW bijstand gegevens:
      | bsn       | is_gerechtigd |
      | 999993654 | true          |
    And de volgende UWV wia gegevens:
      | bsn       | is_volledig_duurzaam_arbeidsongeschikt |
      | 999993654 | true                                   |
    When de participatiewet/reintegratie wordt uitgevoerd door SZW
    Then is voldaan aan de voorwaarden
    And is het is_gerechtigd_reintegratie "true"
    And is het heeft_arbeidsverplichting "false"
    And is het is_vrijgesteld_tegenprestatie "true"

  Scenario: Alleenstaande ouder met kind van 11 jaar is vrijgesteld van tegenprestatie
    # Situatie: Een alleenstaande ouder met een kind van 11 jaar (artikel 9 lid 3 onder a)
    # is vrijgesteld van de tegenprestatie verplichting. De arbeidsverplichting blijft wel bestaan,
    # maar kan worden aangepast rekening houdend met de zorgtaken voor het kind.
    Given een persoon met BSN "999993655"
    And de volgende RvIG personen gegevens:
      | bsn       | geboortedatum |
      | 999993655 | 1988-03-20    |
    And de volgende SVB ouderdomspensioenen gegevens:
      | geboortedatum | pensioenleeftijd |
      | 1988-03-20    | 67               |
    And de volgende SZW bijstand gegevens:
      | bsn       | is_gerechtigd |
      | 999993655 | true          |
    And de volgende UWV wia gegevens:
      | bsn       | is_volledig_duurzaam_arbeidsongeschikt |
      | 999993655 | false                                  |
    And de volgende SZW relaties gegevens:
      | bsn       | is_alleenstaande_ouder | heeft_kind_onder_leeftijd_12 |
      | 999993655 | true                   | true                         |
    When de participatiewet/reintegratie wordt uitgevoerd door SZW
    Then is voldaan aan de voorwaarden
    And is het is_gerechtigd_reintegratie "true"
    And is het heeft_arbeidsverplichting "true"
    And is het is_vrijgesteld_tegenprestatie "true"
