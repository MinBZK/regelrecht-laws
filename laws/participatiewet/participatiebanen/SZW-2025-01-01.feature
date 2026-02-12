Feature: Bepalen recht op participatiebanen en loonkostensubsidie
  Als bijstandsgerechtigde met beperkte arbeidsmogelijkheden
  Wil ik weten of ik in aanmerking kom voor een participatiebaan of loonkostensubsidie
  Zodat ik werkervaring kan opdoen of aan het werk kan blijven

  Background:
    Given de datum is "2025-03-01"

  Scenario: Bijstandsgerechtigde met geringe werkkanst komt in aanmerking voor participatieplaats
    # Situatie: Een bijstandsontvanger van 42 jaar die al langere tijd werkloos is en
    # door beperkte opleiding en werkervaring weinig kans heeft op regulier werk (artikel 10a).
    # Deze persoon komt in aanmerking voor een participatieplaats van maximaal 24 maanden,
    # waarbij onbeloonde maatschappelijk nuttige werkzaamheden worden verricht naast begeleiding.
    Given een persoon met BSN "999993653"
    And de volgende SZW bijstand gegevens:
      | bsn       | is_gerechtigd |
      | 999993653 | true          |
    And de volgende SZW reintegratie gegevens:
      | bsn       | kans_op_werk_gering |
      | 999993653 | true                |
    And de volgende UWV wia gegevens:
      | bsn       | uitsluitend_beschut_werk_mogelijk | kan_geen_minimumloon_verdienen |
      | 999993653 | false                             | false                          |
    When de participatiewet/participatiebanen wordt uitgevoerd door SZW
    Then is het is_gerechtigd_participatieplaats "true"
    And is het maximale_duur_participatieplaats_maanden "24"

  Scenario: Berekening loonkostensubsidie voor persoon met lage loonwaarde
    # Situatie: Een persoon met een arbeidsbeperking heeft een vastgestelde loonwaarde van
    # €900 per maand, terwijl het minimumloon €2.100 bedraagt (artikel 10d lid 4).
    # De werkgever ontvangt een loonkostensubsidie van maximaal het verschil (€1.296 inclusief vakantietoeslag),
    # maar niet meer dan 70% van het minimumloon + vakantietoeslag (8%) + werkgeversbijdrage (15%).
    Given een persoon met BSN "999993654"
    And de volgende SZW bijstand gegevens:
      | bsn       | is_gerechtigd |
      | 999993654 | true          |
    And de volgende UWV wia gegevens:
      | bsn       | loonwaarde_maandelijks | kan_geen_minimumloon_verdienen | uitsluitend_beschut_werk_mogelijk |
      | 999993654 | 90000                  | true                           | false                             |
    And de volgende SZW minimumloon gegevens:
      | referentiedatum | minimumloon_maandelijks | vakantietoeslag_percentage | werkgeversbijdrage_percentage |
      | 2025-03-01      | 210000                  | 0.08                       | 0.15                          |
    When de participatiewet/participatiebanen wordt uitgevoerd door SZW
    Then is het is_gerechtigd_loonkostensubsidie "true"
    And is het loonkostensubsidie_bedrag "129600" eurocent

  Scenario: Persoon die alleen in beschutte omgeving kan werken komt in aanmerking voor beschut werk
    # Situatie: Een persoon met een ernstige arbeidsbeperking kan volgens UWV-beoordeling (artikel 10b)
    # alleen werken in een beschutte omgeving met aangepaste omstandigheden en begeleiding.
    # Voor deze persoon wordt een beschut werkplek gecreëerd met intensieve ondersteuning.
    Given een persoon met BSN "999993655"
    And de volgende SZW bijstand gegevens:
      | bsn       | is_gerechtigd |
      | 999993655 | true          |
    And de volgende UWV wia gegevens:
      | bsn       | uitsluitend_beschut_werk_mogelijk | kan_geen_minimumloon_verdienen |
      | 999993655 | true                              | true                           |
    When de participatiewet/participatiebanen wordt uitgevoerd door SZW
    Then is het is_gerechtigd_beschut_werk "true"
