Feature: Bepalen tegenprestatie verplichting
  Als bijstandsgerechtigde
  Wil ik weten of ik verplicht ben om een tegenprestatie te leveren
  Zodat ik weet welke verplichtingen ik heb naast het zoeken naar werk

  Background:
    Given de datum is "2025-03-01"

  Scenario: Bijstandsgerechtigde heeft tegenprestatie verplichting
    # Situatie: Een gezonde 32-jarige bijstandsontvanger zonder kinderen heeft volgens
    # artikel 9 lid 1 onder c de verplichting om onbeloonde maatschappelijk nuttige
    # werkzaamheden te verrichten, bijvoorbeeld vrijwilligerswerk bij een voedselbank
    # of hulp bij groenonderhoud in de wijk. Dit naast de verplichting om werk te zoeken.
    Given een persoon met BSN "999993653"
    And de volgende RvIG personen gegevens:
      | bsn       | geboortedatum |
      | 999993653 | 1993-06-10    |
    And de volgende SVB ouderdomspensioenen gegevens:
      | geboortedatum | pensioenleeftijd |
      | 1993-06-10    | 67               |
    And de volgende SZW bijstand gegevens:
      | bsn       | is_gerechtigd |
      | 999993653 | true          |
    And de volgende UWV wia gegevens:
      | bsn       | is_volledig_duurzaam_arbeidsongeschikt |
      | 999993653 | false                                  |
    And de volgende SZW relaties gegevens:
      | bsn       | is_alleenstaande_ouder | heeft_kind_onder_leeftijd_12 | heeft_kind_onder_leeftijd_5 |
      | 999993653 | false                  | false                        | false                       |
    And de volgende SZW reintegratie gegevens:
      | bsn       | heeft_dringende_zorgtaken |
      | 999993653 | false                     |
    When de participatiewet/tegenprestatie wordt uitgevoerd door SZW
    Then is het heeft_tegenprestatie_verplichting "true"
    And is het is_vrijgesteld_tegenprestatie "false"

  Scenario: Alleenstaande ouder met kind van 4 jaar is vrijgesteld van tegenprestatie
    # Situatie: Een alleenstaande ouder met een kind van 4 jaar kan volgens artikel 9a
    # vrijstelling aanvragen van de tegenprestatie verplichting totdat het jongste kind
    # 5 jaar is geworden. De ouder heeft wel nog steeds de verplichting om werk te zoeken.
    Given een persoon met BSN "999993654"
    And de volgende RvIG personen gegevens:
      | bsn       | geboortedatum |
      | 999993654 | 1992-08-15    |
    And de volgende SVB ouderdomspensioenen gegevens:
      | geboortedatum | pensioenleeftijd |
      | 1992-08-15    | 67               |
    And de volgende SZW bijstand gegevens:
      | bsn       | is_gerechtigd |
      | 999993654 | true          |
    And de volgende UWV wia gegevens:
      | bsn       | is_volledig_duurzaam_arbeidsongeschikt |
      | 999993654 | false                                  |
    And de volgende SZW relaties gegevens:
      | bsn       | is_alleenstaande_ouder | heeft_kind_onder_leeftijd_12 | heeft_kind_onder_leeftijd_5 |
      | 999993654 | true                   | true                         | true                        |
    When de participatiewet/tegenprestatie wordt uitgevoerd door SZW
    Then is het heeft_tegenprestatie_verplichting "false"
    And is het is_vrijgesteld_tegenprestatie "true"
    And is de reden_vrijstelling "Alleenstaande ouder met kind(eren) jonger dan 5 jaar"

  Scenario: Bijstandsgerechtigde met dringende zorgtaken is tijdelijk vrijgesteld
    # Situatie: Een bijstandsontvanger die intensieve mantelzorg verleent aan een ernstig
    # zieke partner (artikel 9 lid 2) kan worden vrijgesteld van de tegenprestatie verplichting.
    # Zorgtaken kunnen als dringende redenen worden aangemerkt.
    Given een persoon met BSN "999993655"
    And de volgende RvIG personen gegevens:
      | bsn       | geboortedatum |
      | 999993655 | 1980-11-22    |
    And de volgende SVB ouderdomspensioenen gegevens:
      | geboortedatum | pensioenleeftijd |
      | 1980-11-22    | 67               |
    And de volgende SZW bijstand gegevens:
      | bsn       | is_gerechtigd |
      | 999993655 | true          |
    And de volgende UWV wia gegevens:
      | bsn       | is_volledig_duurzaam_arbeidsongeschikt |
      | 999993655 | false                                  |
    And de volgende SZW relaties gegevens:
      | bsn       | is_alleenstaande_ouder | heeft_kind_onder_leeftijd_12 | heeft_kind_onder_leeftijd_5 |
      | 999993655 | false                  | false                        | false                       |
    And de volgende SZW reintegratie gegevens:
      | bsn       | heeft_dringende_zorgtaken |
      | 999993655 | true                      |
    When de participatiewet/tegenprestatie wordt uitgevoerd door SZW
    Then is het heeft_tegenprestatie_verplichting "false"
    And is het is_vrijgesteld_tegenprestatie "true"
    And is de reden_vrijstelling "Dringende zorgtaken"
