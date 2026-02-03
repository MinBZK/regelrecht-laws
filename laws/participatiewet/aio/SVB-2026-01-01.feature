Feature: AIO-aanvulling - Aanvullende Inkomensvoorziening Ouderen
  Als AOW-gerechtigde met onvolledige AOW-opbouw
  Wil ik weten of ik recht heb op AIO-aanvulling
  Zodat ik mijn inkomen tot het sociaal minimum aangevuld krijg

  Background:
    Given de datum is "2026-07-01"
    And de volgende CBS levensverwachting gegevens:
      | jaar | verwachting_65 |
      | 2026 | 20.5           |

  Scenario: Alleenstaande AOW'er met onvolledige opbouw krijgt AIO
    Given een persoon met BSN "400000001"
    And de volgende RvIG personen gegevens:
      | bsn       | geboortedatum | verblijfsadres |
      | 400000001 | 1958-03-15    | Amsterdam      |
    And de volgende RvIG relaties gegevens:
      | bsn       | partnerschap_type | partner_bsn |
      | 400000001 | GEEN              | null        |
    And de volgende SVB verzekerde_tijdvakken gegevens:
      | bsn       | woonperiodes |
      | 400000001 | 25           |
    And de volgende BELASTINGDIENST box1 gegevens:
      | bsn       | loon_uit_dienstbetrekking | uitkeringen_en_pensioenen | winst_uit_onderneming | resultaat_overige_werkzaamheden | eigen_woning |
      | 400000001 | 0                         | 8280000                   | 0                     | 0                               | 0            |
    And de volgende BELASTINGDIENST box3 gegevens:
      | bsn       | spaargeld | beleggingen | onroerend_goed | schulden |
      | 400000001 | 500000    | 0           | 0              | 0        |
    When de participatiewet/aio wordt uitgevoerd door SVB
    Then is voldaan aan de voorwaarden
    And heeft de output "is_gerechtigd" waarde "true"
    And heeft de output "sociaal_minimum" waarde "138000"
    # AOW bij 50% opbouw is 69000 eurocent per maand
    # Totaal inkomen is 69000 (AOW maandelijks)
    # AIO = 138000 - 69000 = 69000 eurocent
    And heeft de output "aio_aanvulling" waarde "69000"

  Scenario: Gehuwde AOW'ers met onvolledige opbouw krijgen AIO
    Given een persoon met BSN "400000002"
    And de volgende RvIG personen gegevens:
      | bsn       | geboortedatum | verblijfsadres |
      | 400000002 | 1957-06-20    | Rotterdam      |
      | 400000003 | 1959-02-10    | Rotterdam      |
    And de volgende RvIG relaties gegevens:
      | bsn       | partnerschap_type | partner_bsn |
      | 400000002 | HUWELIJK          | 400000003   |
    And de volgende SVB verzekerde_tijdvakken gegevens:
      | bsn       | woonperiodes |
      | 400000002 | 30           |
    And de volgende BELASTINGDIENST box1 gegevens:
      | bsn       | loon_uit_dienstbetrekking | uitkeringen_en_pensioenen | winst_uit_onderneming | resultaat_overige_werkzaamheden | eigen_woning |
      | 400000002 | 0                         | 6850000                   | 0                     | 0                               | 0            |
    And de volgende BELASTINGDIENST box3 gegevens:
      | bsn       | spaargeld | beleggingen | onroerend_goed | schulden |
      | 400000002 | 1000000   | 0           | 0              | 0        |
    When de participatiewet/aio wordt uitgevoerd door SVB
    Then is voldaan aan de voorwaarden
    And heeft de output "is_gerechtigd" waarde "true"
    And heeft de output "sociaal_minimum" waarde "197000"

  Scenario: AOW'er met volledig pensioen krijgt geen AIO
    Given een persoon met BSN "400000004"
    And de volgende RvIG personen gegevens:
      | bsn       | geboortedatum | verblijfsadres |
      | 400000004 | 1958-01-10    | Utrecht        |
    And de volgende RvIG relaties gegevens:
      | bsn       | partnerschap_type | partner_bsn |
      | 400000004 | GEEN              | null        |
    And de volgende SVB verzekerde_tijdvakken gegevens:
      | bsn       | woonperiodes |
      | 400000004 | 50           |
    And de volgende BELASTINGDIENST box1 gegevens:
      | bsn       | loon_uit_dienstbetrekking | uitkeringen_en_pensioenen | winst_uit_onderneming | resultaat_overige_werkzaamheden | eigen_woning |
      | 400000004 | 0                         | 16560000                  | 0                     | 0                               | 0            |
    And de volgende BELASTINGDIENST box3 gegevens:
      | bsn       | spaargeld | beleggingen | onroerend_goed | schulden |
      | 400000004 | 300000    | 0           | 0              | 0        |
    When de participatiewet/aio wordt uitgevoerd door SVB
    Then is voldaan aan de voorwaarden
    And heeft de output "aio_aanvulling" waarde "0"

  Scenario: AOW'er met te veel vermogen krijgt geen AIO
    Given een persoon met BSN "400000005"
    And de volgende RvIG personen gegevens:
      | bsn       | geboortedatum | verblijfsadres |
      | 400000005 | 1958-05-25    | Den Haag       |
    And de volgende RvIG relaties gegevens:
      | bsn       | partnerschap_type | partner_bsn |
      | 400000005 | GEEN              | null        |
    And de volgende SVB verzekerde_tijdvakken gegevens:
      | bsn       | woonperiodes |
      | 400000005 | 20           |
    And de volgende BELASTINGDIENST box1 gegevens:
      | bsn       | loon_uit_dienstbetrekking | uitkeringen_en_pensioenen | winst_uit_onderneming | resultaat_overige_werkzaamheden | eigen_woning |
      | 400000005 | 0                         | 6624000                   | 0                     | 0                               | 0            |
    And de volgende BELASTINGDIENST box3 gegevens:
      | bsn       | spaargeld | beleggingen | onroerend_goed | schulden |
      | 400000005 | 1000000   | 0           | 0              | 0        |
    When de participatiewet/aio wordt uitgevoerd door SVB
    Then is niet voldaan aan de voorwaarden

  Scenario: Persoon onder AOW-leeftijd krijgt geen AIO
    Given een persoon met BSN "400000006"
    And de volgende RvIG personen gegevens:
      | bsn       | geboortedatum | verblijfsadres |
      | 400000006 | 1970-08-30    | Eindhoven      |
    And de volgende RvIG relaties gegevens:
      | bsn       | partnerschap_type | partner_bsn |
      | 400000006 | GEEN              | null        |
    And de volgende SVB verzekerde_tijdvakken gegevens:
      | bsn       | woonperiodes |
      | 400000006 | 15           |
    And de volgende BELASTINGDIENST box1 gegevens:
      | bsn       | loon_uit_dienstbetrekking | uitkeringen_en_pensioenen | winst_uit_onderneming | resultaat_overige_werkzaamheden | eigen_woning |
      | 400000006 | 0                         | 0                         | 0                     | 0                               | 0            |
    And de volgende BELASTINGDIENST box3 gegevens:
      | bsn       | spaargeld | beleggingen | onroerend_goed | schulden |
      | 400000006 | 100000    | 0           | 0              | 0        |
    When de participatiewet/aio wordt uitgevoerd door SVB
    Then is niet voldaan aan de voorwaarden
