Feature: Bepalen recht op geluidsontheffing horeca Rotterdam
  Als horecaondernemer in Rotterdam
  Wil ik weten of ik een incidentele geluidsontheffing kan krijgen
  Zodat ik op specifieke avonden meer geluid mag produceren (maximaal 15 dB(A) extra)

  Background:
    Given de datum is "2024-06-15T10:00:00"
    And een aanvraag met KVK nummer "12345678"

  # Casussen gebaseerd op APV Rotterdam 2012 artikel 4:2 en 4:3

  Scenario: Succesvolle aanvraag geluidsontheffing - eerste aanvraag dit jaar op vrijdag
    # Ondernemer vraagt voor het eerst dit jaar een geluidsontheffing aan voor vrijdagavond
    # Activiteit start over 72 uur (ruim binnen de 48 uur termijn)
    # Geen geluidsklachten, bedrijf is actief
    Given de volgende KVK organisaties gegevens:
      | kvk_nummer | status |
      | 12345678   | Actief |
    And de volgende GEMEENTE_ROTTERDAM geluidsklachten gegevens:
      | kvk_nummer | heeft_actieve_klachten |
      | 12345678   | false                  |
    And er zijn "0" goedgekeurde geluidsontheffingen dit jaar voor KVK "12345678"
    And de activiteitsdatum is "2024-06-18" met starttijd "20:00"
    When de algemene_plaatselijke_verordening/ontheffingspas_geluid wordt uitgevoerd door GEMEENTE_ROTTERDAM
    Then komt het bedrijf in aanmerking voor geluidsontheffing
    And is het aantal verleende ontheffingen dit jaar "0"
    And is het aantal resterende ontheffingen dit jaar "12"
    And is de maximale eindtijd "00:00 (middernacht)"

  Scenario: Succesvolle aanvraag geluidsontheffing - op vrijdag (tot 02:00)
    # Vrijdag is dag 4 in DAY_OF_WEEK, dus geluidsontheffing geldig tot 02:00
    Given de volgende KVK organisaties gegevens:
      | kvk_nummer | status |
      | 12345678   | Actief |
    And de volgende GEMEENTE_ROTTERDAM geluidsklachten gegevens:
      | kvk_nummer | heeft_actieve_klachten |
      | 12345678   | false                  |
    And er zijn "5" goedgekeurde geluidsontheffingen dit jaar voor KVK "12345678"
    And de activiteitsdatum is "2024-06-21" met starttijd "21:00"
    When de algemene_plaatselijke_verordening/ontheffingspas_geluid wordt uitgevoerd door GEMEENTE_ROTTERDAM
    Then komt het bedrijf in aanmerking voor geluidsontheffing
    And is het aantal verleende ontheffingen dit jaar "5"
    And is het aantal resterende ontheffingen dit jaar "7"
    And is de maximale eindtijd "02:00 (volgende ochtend)"

  Scenario: Succesvolle aanvraag geluidsontheffing - op zaterdag (tot 02:00)
    # Zaterdag is dag 5 in DAY_OF_WEEK, dus geluidsontheffing geldig tot 02:00
    Given de volgende KVK organisaties gegevens:
      | kvk_nummer | status |
      | 12345678   | Actief |
    And de volgende GEMEENTE_ROTTERDAM geluidsklachten gegevens:
      | kvk_nummer | heeft_actieve_klachten |
      | 12345678   | false                  |
    And er zijn "11" goedgekeurde geluidsontheffingen dit jaar voor KVK "12345678"
    And de activiteitsdatum is "2024-06-22" met starttijd "20:00"
    When de algemene_plaatselijke_verordening/ontheffingspas_geluid wordt uitgevoerd door GEMEENTE_ROTTERDAM
    Then komt het bedrijf in aanmerking voor geluidsontheffing
    And is het aantal verleende ontheffingen dit jaar "11"
    And is het aantal resterende ontheffingen dit jaar "1"
    And is de maximale eindtijd "02:00 (volgende ochtend)"

  Scenario: Succesvolle aanvraag geluidsontheffing - doordeweeks (tot middernacht)
    # Woensdag is dag 2, dus geluidsontheffing geldig tot 00:00 (middernacht)
    Given de volgende KVK organisaties gegevens:
      | kvk_nummer | status |
      | 12345678   | Actief |
    And de volgende GEMEENTE_ROTTERDAM geluidsklachten gegevens:
      | kvk_nummer | heeft_actieve_klachten |
      | 12345678   | false                  |
    And er zijn "3" goedgekeurde geluidsontheffingen dit jaar voor KVK "12345678"
    And de activiteitsdatum is "2024-06-19" met starttijd "19:00"
    When de algemene_plaatselijke_verordening/ontheffingspas_geluid wordt uitgevoerd door GEMEENTE_ROTTERDAM
    Then komt het bedrijf in aanmerking voor geluidsontheffing
    And is het aantal verleende ontheffingen dit jaar "3"
    And is het aantal resterende ontheffingen dit jaar "9"
    And is de maximale eindtijd "00:00 (middernacht)"

  Scenario: Afwijzing - maximum van 12 ontheffingen per jaar bereikt
    # Artikel 4:2 APV Rotterdam: maximaal 12 incidentele ontheffingen per kalenderjaar
    Given de volgende KVK organisaties gegevens:
      | kvk_nummer | status |
      | 12345678   | Actief |
    And de volgende GEMEENTE_ROTTERDAM geluidsklachten gegevens:
      | kvk_nummer | heeft_actieve_klachten |
      | 12345678   | false                  |
    And er zijn "12" goedgekeurde geluidsontheffingen dit jaar voor KVK "12345678"
    And de activiteitsdatum is "2024-06-20" met starttijd "20:00"
    When de algemene_plaatselijke_verordening/ontheffingspas_geluid wordt uitgevoerd door GEMEENTE_ROTTERDAM
    Then komt het bedrijf niet in aanmerking voor geluidsontheffing
    And is het aantal resterende ontheffingen dit jaar "0"

  Scenario: Afwijzing - aanvraag te laat (minder dan 48 uur van tevoren)
    # Artikel 4:2 APV Rotterdam: aanvraag minimaal 48 uur van tevoren
    # Aanvraag op 15 juni 10:00, activiteit op 16 juni 20:00 = 34 uur verschil
    Given de volgende KVK organisaties gegevens:
      | kvk_nummer | status |
      | 12345678   | Actief |
    And de volgende GEMEENTE_ROTTERDAM geluidsklachten gegevens:
      | kvk_nummer | heeft_actieve_klachten |
      | 12345678   | false                  |
    And er zijn "0" goedgekeurde geluidsontheffingen dit jaar voor KVK "12345678"
    And de activiteitsdatum is "2024-06-16" met starttijd "20:00"
    When de algemene_plaatselijke_verordening/ontheffingspas_geluid wordt uitgevoerd door GEMEENTE_ROTTERDAM
    Then komt het bedrijf niet in aanmerking voor geluidsontheffing
    And is de aanvraag niet tijdig

  Scenario: Afwijzing - bedrijf heeft bekende geluidsklachten
    # Bij actieve geluidsklachten wordt geen ontheffing verleend
    Given de volgende KVK organisaties gegevens:
      | kvk_nummer | status |
      | 12345678   | Actief |
    And de volgende GEMEENTE_ROTTERDAM geluidsklachten gegevens:
      | kvk_nummer | heeft_actieve_klachten |
      | 12345678   | true                   |
    And er zijn "0" goedgekeurde geluidsontheffingen dit jaar voor KVK "12345678"
    And de activiteitsdatum is "2024-06-20" met starttijd "20:00"
    When de algemene_plaatselijke_verordening/ontheffingspas_geluid wordt uitgevoerd door GEMEENTE_ROTTERDAM
    Then komt het bedrijf niet in aanmerking voor geluidsontheffing
    And zijn er geluidsklachten bekend

  Scenario: Afwijzing - bedrijf niet actief in Handelsregister
    # Bedrijf moet actief geregistreerd zijn in het Handelsregister
    Given de volgende KVK organisaties gegevens:
      | kvk_nummer | status       |
      | 12345678   | Uitgeschreven |
    And de volgende GEMEENTE_ROTTERDAM geluidsklachten gegevens:
      | kvk_nummer | heeft_actieve_klachten |
      | 12345678   | false                  |
    And er zijn "0" goedgekeurde geluidsontheffingen dit jaar voor KVK "12345678"
    And de activiteitsdatum is "2024-06-20" met starttijd "20:00"
    When de algemene_plaatselijke_verordening/ontheffingspas_geluid wordt uitgevoerd door GEMEENTE_ROTTERDAM
    Then komt het bedrijf niet in aanmerking voor geluidsontheffing
    And is het bedrijf niet actief

  Scenario: Grensgevalgeval - precies 48 uur van tevoren (net op tijd)
    # Aanvraag op 15 juni 10:00, activiteit op 17 juni 10:00 = precies 48 uur
    Given de volgende KVK organisaties gegevens:
      | kvk_nummer | status |
      | 12345678   | Actief |
    And de volgende GEMEENTE_ROTTERDAM geluidsklachten gegevens:
      | kvk_nummer | heeft_actieve_klachten |
      | 12345678   | false                  |
    And er zijn "6" goedgekeurde geluidsontheffingen dit jaar voor KVK "12345678"
    And de activiteitsdatum is "2024-06-17" met starttijd "10:00"
    When de algemene_plaatselijke_verordening/ontheffingspas_geluid wordt uitgevoerd door GEMEENTE_ROTTERDAM
    Then komt het bedrijf in aanmerking voor geluidsontheffing
    And is de aanvraag tijdig

  Scenario: Nieuw kalenderjaar - teller reset naar 0
    # Bij nieuw kalenderjaar begint de teller van 12 ontheffingen opnieuw
    Given de datum is "2025-01-05T10:00:00"
    And de volgende KVK organisaties gegevens:
      | kvk_nummer | status |
      | 12345678   | Actief |
    And de volgende GEMEENTE_ROTTERDAM geluidsklachten gegevens:
      | kvk_nummer | heeft_actieve_klachten |
      | 12345678   | false                  |
    And er zijn "0" goedgekeurde geluidsontheffingen dit jaar voor KVK "12345678"
    And de activiteitsdatum is "2025-01-10" met starttijd "20:00"
    When de algemene_plaatselijke_verordening/ontheffingspas_geluid wordt uitgevoerd door GEMEENTE_ROTTERDAM
    Then komt het bedrijf in aanmerking voor geluidsontheffing
    And is het aantal verleende ontheffingen dit jaar "0"
    And is het aantal resterende ontheffingen dit jaar "12"
