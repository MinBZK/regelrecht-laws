Feature: Bepalen recht op terrasvergunning Rotterdam
  Als horecaondernemer in Rotterdam
  Wil ik weten of ik een terrasvergunning kan krijgen
  Zodat ik een terras kan exploiteren bij mijn horecabedrijf

  Background:
    Given de datum is "2024-06-01"
    And een aanvraag met KVK nummer "85234567"

  # Casussen gebaseerd op APV Rotterdam 2012 artikel 2:30b en Terrassenbeleid Rotterdam 2023

  Scenario: Succesvolle aanvraag terrasvergunning - restaurant met exploitatievergunning
    # Ondernemer heeft exploitatievergunning, pand heeft juiste bestemming,
    # voldoende obstakelvrije ruimte (1,8 meter), passende oppervlakte
    Given de volgende KVK organisaties gegevens:
      | kvk_nummer | status | vestigingsadres                          |
      | 85234567   | Actief | Witte de Withstraat 50, 3012BR Rotterdam |
    And de volgende GEMEENTE_ROTTERDAM exploitatievergunningen gegevens:
      | kvk_nummer | heeft_actieve_vergunning | verstrekt_alcoholhoudende_dranken |
      | 85234567   | true                     | false                             |
    And de volgende KADASTER bag_objecten gegevens:
      | adres                                    | gebruiksdoel       |
      | Witte de Withstraat 50, 3012BR Rotterdam | bijeenkomstfunctie |
    And de volgende GEMEENTE_ROTTERDAM bgt_terraslocaties gegevens:
      | adres                                    | locatie | beschikbare_oppervlakte | functie_oppervlak | is_openbare_weg |
      | Witte de Withstraat 50, 3012BR Rotterdam | voor    | 25                      | voetpad           | true            |
    And de volgende GEMEENTE_ROTTERDAM terrassenbeleid gegevens:
      | adres                                    | max_sluitingstijd_doordeweeks | max_sluitingstijd_weekend |
      | Witte de Withstraat 50, 3012BR Rotterdam | 1                             | 2                         |
    And de volgende GEMEENTE_ROTTERDAM precario_tarieven gegevens:
      | adres                                    | tarief_per_m2 |
      | Witte de Withstraat 50, 3012BR Rotterdam | 85.00         |
    And de volgende GEMEENTE_ROTTERDAM vergunningen gegevens:
      | kvk_nummer | heeft_alcoholvergunning |
      | 85234567   | false                   |
    And de aanvraag is voor een terras:
      | locatie | oppervlakte | obstakelvrije_ruimte | seizoen   | openingstijd | sluitingstijd_doordeweeks | sluitingstijd_weekend |
      | voor    | 20          | 2.0                  | jaarrond  | 10           | 23                        | 24                    |
    When de algemene_plaatselijke_verordening/terrassen wordt uitgevoerd door GEMEENTE_ROTTERDAM
    Then heeft de aanvrager recht op terrasvergunning
    And is de vergunde oppervlakte "20" m2
    And is de vergunde sluitingstijd doordeweeks "23" uur
    And is de vergunde sluitingstijd weekend "24" uur
    And is de precariobelasting per jaar "1700.00" euro

  Scenario: Succesvolle aanvraag terrasvergunning - cafe met alcoholvergunning
    # Cafe schenkt alcohol, heeft zowel exploitatievergunning als alcoholvergunning
    Given de volgende KVK organisaties gegevens:
      | kvk_nummer | status | vestigingsadres                       |
      | 85234567   | Actief | Nieuwe Binnenweg 100, 3015BA Rotterdam |
    And de volgende GEMEENTE_ROTTERDAM exploitatievergunningen gegevens:
      | kvk_nummer | heeft_actieve_vergunning | verstrekt_alcoholhoudende_dranken |
      | 85234567   | true                     | true                              |
    And de volgende KADASTER bag_objecten gegevens:
      | adres                                  | gebruiksdoel       |
      | Nieuwe Binnenweg 100, 3015BA Rotterdam | bijeenkomstfunctie |
    And de volgende GEMEENTE_ROTTERDAM bgt_terraslocaties gegevens:
      | adres                                  | locatie | beschikbare_oppervlakte | functie_oppervlak | is_openbare_weg |
      | Nieuwe Binnenweg 100, 3015BA Rotterdam | voor    | 30                      | voetgangersgebied | true            |
    And de volgende GEMEENTE_ROTTERDAM terrassenbeleid gegevens:
      | adres                                  | max_sluitingstijd_doordeweeks | max_sluitingstijd_weekend |
      | Nieuwe Binnenweg 100, 3015BA Rotterdam | 1                             | 2                         |
    And de volgende GEMEENTE_ROTTERDAM precario_tarieven gegevens:
      | adres                                  | tarief_per_m2 |
      | Nieuwe Binnenweg 100, 3015BA Rotterdam | 95.00         |
    And de volgende GEMEENTE_ROTTERDAM vergunningen gegevens:
      | kvk_nummer | heeft_alcoholvergunning |
      | 85234567   | true                    |
    And de aanvraag is voor een terras:
      | locatie | oppervlakte | obstakelvrije_ruimte | seizoen | openingstijd | sluitingstijd_doordeweeks | sluitingstijd_weekend |
      | voor    | 25          | 2.5                  | zomer   | 9            | 1                         | 2                     |
    When de algemene_plaatselijke_verordening/terrassen wordt uitgevoerd door GEMEENTE_ROTTERDAM
    Then heeft de aanvrager recht op terrasvergunning
    And is de vergunde oppervlakte "25" m2
    And is de precariobelasting per jaar "2375.00" euro

  Scenario: Afwijzing - geen exploitatievergunning
    # Artikel 2:30b vereist eerst een exploitatievergunning voor het horecabedrijf
    Given de volgende KVK organisaties gegevens:
      | kvk_nummer | status | vestigingsadres                          |
      | 85234567   | Actief | Witte de Withstraat 50, 3012BR Rotterdam |
    And de volgende GEMEENTE_ROTTERDAM exploitatievergunningen gegevens:
      | kvk_nummer | heeft_actieve_vergunning | verstrekt_alcoholhoudende_dranken |
      | 85234567   | false                    | false                             |
    And de volgende KADASTER bag_objecten gegevens:
      | adres                                    | gebruiksdoel       |
      | Witte de Withstraat 50, 3012BR Rotterdam | bijeenkomstfunctie |
    And de volgende GEMEENTE_ROTTERDAM bgt_terraslocaties gegevens:
      | adres                                    | locatie | beschikbare_oppervlakte | functie_oppervlak | is_openbare_weg |
      | Witte de Withstraat 50, 3012BR Rotterdam | voor    | 25                      | voetpad           | true            |
    And de aanvraag is voor een terras:
      | locatie | oppervlakte | obstakelvrije_ruimte | seizoen  | openingstijd | sluitingstijd_doordeweeks | sluitingstijd_weekend |
      | voor    | 20          | 2.0                  | jaarrond | 10           | 23                        | 24                    |
    When de algemene_plaatselijke_verordening/terrassen wordt uitgevoerd door GEMEENTE_ROTTERDAM
    Then heeft de aanvrager geen recht op terrasvergunning
    And is de weigeringsgrond "Geen geldige exploitatievergunning"

  Scenario: Afwijzing - obstakelvrije ruimte te klein (minder dan 1,8 meter)
    # Artikel 2:30b lid 3: minimaal 1,8 meter obstakelvrije ruimte vereist
    Given de volgende KVK organisaties gegevens:
      | kvk_nummer | status | vestigingsadres                          |
      | 85234567   | Actief | Witte de Withstraat 50, 3012BR Rotterdam |
    And de volgende GEMEENTE_ROTTERDAM exploitatievergunningen gegevens:
      | kvk_nummer | heeft_actieve_vergunning | verstrekt_alcoholhoudende_dranken |
      | 85234567   | true                     | false                             |
    And de volgende KADASTER bag_objecten gegevens:
      | adres                                    | gebruiksdoel       |
      | Witte de Withstraat 50, 3012BR Rotterdam | bijeenkomstfunctie |
    And de volgende GEMEENTE_ROTTERDAM bgt_terraslocaties gegevens:
      | adres                                    | locatie | beschikbare_oppervlakte | functie_oppervlak | is_openbare_weg |
      | Witte de Withstraat 50, 3012BR Rotterdam | voor    | 25                      | voetpad           | true            |
    And de aanvraag is voor een terras:
      | locatie | oppervlakte | obstakelvrije_ruimte | seizoen  | openingstijd | sluitingstijd_doordeweeks | sluitingstijd_weekend |
      | voor    | 20          | 1.5                  | jaarrond | 10           | 23                        | 24                    |
    When de algemene_plaatselijke_verordening/terrassen wordt uitgevoerd door GEMEENTE_ROTTERDAM
    Then heeft de aanvrager geen recht op terrasvergunning
    And is de weigeringsgrond "Obstakelvrije ruimte is minder dan 1,8 meter"

  Scenario: Afwijzing - gevraagde oppervlakte groter dan beschikbaar
    # De gevraagde terrasoppervlakte mag niet groter zijn dan de beschikbare BGT-oppervlakte
    Given de volgende KVK organisaties gegevens:
      | kvk_nummer | status | vestigingsadres                          |
      | 85234567   | Actief | Witte de Withstraat 50, 3012BR Rotterdam |
    And de volgende GEMEENTE_ROTTERDAM exploitatievergunningen gegevens:
      | kvk_nummer | heeft_actieve_vergunning | verstrekt_alcoholhoudende_dranken |
      | 85234567   | true                     | false                             |
    And de volgende KADASTER bag_objecten gegevens:
      | adres                                    | gebruiksdoel       |
      | Witte de Withstraat 50, 3012BR Rotterdam | bijeenkomstfunctie |
    And de volgende GEMEENTE_ROTTERDAM bgt_terraslocaties gegevens:
      | adres                                    | locatie | beschikbare_oppervlakte | functie_oppervlak | is_openbare_weg |
      | Witte de Withstraat 50, 3012BR Rotterdam | voor    | 15                      | voetpad           | true            |
    And de aanvraag is voor een terras:
      | locatie | oppervlakte | obstakelvrije_ruimte | seizoen  | openingstijd | sluitingstijd_doordeweeks | sluitingstijd_weekend |
      | voor    | 25          | 2.0                  | jaarrond | 10           | 23                        | 24                    |
    When de algemene_plaatselijke_verordening/terrassen wordt uitgevoerd door GEMEENTE_ROTTERDAM
    Then heeft de aanvrager geen recht op terrasvergunning
    And is de weigeringsgrond "Gevraagde oppervlakte groter dan beschikbare ruimte"

  Scenario: Afwijzing - pand heeft geen horecabestemming
    # Het pand moet een horecagerelateerd gebruiksdoel hebben volgens BAG
    Given de volgende KVK organisaties gegevens:
      | kvk_nummer | status | vestigingsadres                          |
      | 85234567   | Actief | Witte de Withstraat 50, 3012BR Rotterdam |
    And de volgende GEMEENTE_ROTTERDAM exploitatievergunningen gegevens:
      | kvk_nummer | heeft_actieve_vergunning | verstrekt_alcoholhoudende_dranken |
      | 85234567   | true                     | false                             |
    And de volgende KADASTER bag_objecten gegevens:
      | adres                                    | gebruiksdoel |
      | Witte de Withstraat 50, 3012BR Rotterdam | woonfunctie  |
    And de volgende GEMEENTE_ROTTERDAM bgt_terraslocaties gegevens:
      | adres                                    | locatie | beschikbare_oppervlakte | functie_oppervlak | is_openbare_weg |
      | Witte de Withstraat 50, 3012BR Rotterdam | voor    | 25                      | voetpad           | true            |
    And de aanvraag is voor een terras:
      | locatie | oppervlakte | obstakelvrije_ruimte | seizoen  | openingstijd | sluitingstijd_doordeweeks | sluitingstijd_weekend |
      | voor    | 20          | 2.0                  | jaarrond | 10           | 23                        | 24                    |
    When de algemene_plaatselijke_verordening/terrassen wordt uitgevoerd door GEMEENTE_ROTTERDAM
    Then heeft de aanvrager geen recht op terrasvergunning
    And is de weigeringsgrond "Pand heeft geen horecagerelateerd gebruiksdoel"

  Scenario: Afwijzing - BGT functie niet geschikt voor terras
    # Een terras mag alleen op geschikte oppervlakken (voetpad, voetgangersgebied, woonerf, inrit)
    Given de volgende KVK organisaties gegevens:
      | kvk_nummer | status | vestigingsadres                          |
      | 85234567   | Actief | Witte de Withstraat 50, 3012BR Rotterdam |
    And de volgende GEMEENTE_ROTTERDAM exploitatievergunningen gegevens:
      | kvk_nummer | heeft_actieve_vergunning | verstrekt_alcoholhoudende_dranken |
      | 85234567   | true                     | false                             |
    And de volgende KADASTER bag_objecten gegevens:
      | adres                                    | gebruiksdoel       |
      | Witte de Withstraat 50, 3012BR Rotterdam | bijeenkomstfunctie |
    And de volgende GEMEENTE_ROTTERDAM bgt_terraslocaties gegevens:
      | adres                                    | locatie | beschikbare_oppervlakte | functie_oppervlak | is_openbare_weg |
      | Witte de Withstraat 50, 3012BR Rotterdam | voor    | 25                      | rijbaan           | true            |
    And de aanvraag is voor een terras:
      | locatie | oppervlakte | obstakelvrije_ruimte | seizoen  | openingstijd | sluitingstijd_doordeweeks | sluitingstijd_weekend |
      | voor    | 20          | 2.0                  | jaarrond | 10           | 23                        | 24                    |
    When de algemene_plaatselijke_verordening/terrassen wordt uitgevoerd door GEMEENTE_ROTTERDAM
    Then heeft de aanvrager geen recht op terrasvergunning
    And is de weigeringsgrond "Locatie niet geschikt voor terras (verkeerde BGT-functie)"

  Scenario: Afwijzing - gevraagde sluitingstijd doordeweeks later dan toegestaan
    # Terrassen mogen doordeweeks maximaal tot 01:00 uur open zijn
    Given de volgende KVK organisaties gegevens:
      | kvk_nummer | status | vestigingsadres                          |
      | 85234567   | Actief | Witte de Withstraat 50, 3012BR Rotterdam |
    And de volgende GEMEENTE_ROTTERDAM exploitatievergunningen gegevens:
      | kvk_nummer | heeft_actieve_vergunning | verstrekt_alcoholhoudende_dranken |
      | 85234567   | true                     | false                             |
    And de volgende KADASTER bag_objecten gegevens:
      | adres                                    | gebruiksdoel       |
      | Witte de Withstraat 50, 3012BR Rotterdam | bijeenkomstfunctie |
    And de volgende GEMEENTE_ROTTERDAM bgt_terraslocaties gegevens:
      | adres                                    | locatie | beschikbare_oppervlakte | functie_oppervlak | is_openbare_weg |
      | Witte de Withstraat 50, 3012BR Rotterdam | voor    | 25                      | voetpad           | true            |
    And de volgende GEMEENTE_ROTTERDAM terrassenbeleid gegevens:
      | adres                                    | max_sluitingstijd_doordeweeks | max_sluitingstijd_weekend |
      | Witte de Withstraat 50, 3012BR Rotterdam | 23                            | 1                         |
    And de aanvraag is voor een terras:
      | locatie | oppervlakte | obstakelvrije_ruimte | seizoen  | openingstijd | sluitingstijd_doordeweeks | sluitingstijd_weekend |
      | voor    | 20          | 2.0                  | jaarrond | 10           | 1                         | 1                     |
    When de algemene_plaatselijke_verordening/terrassen wordt uitgevoerd door GEMEENTE_ROTTERDAM
    Then heeft de aanvrager geen recht op terrasvergunning
    And is de weigeringsgrond "Gevraagde sluitingstijd doordeweeks (zo-do) later dan toegestaan in dit gebied"

  Scenario: Afwijzing - alcohol schenken zonder alcoholvergunning
    # Voor het schenken van alcohol op het terras is een alcoholvergunning vereist
    Given de volgende KVK organisaties gegevens:
      | kvk_nummer | status | vestigingsadres                          |
      | 85234567   | Actief | Witte de Withstraat 50, 3012BR Rotterdam |
    And de volgende GEMEENTE_ROTTERDAM exploitatievergunningen gegevens:
      | kvk_nummer | heeft_actieve_vergunning | verstrekt_alcoholhoudende_dranken |
      | 85234567   | true                     | true                              |
    And de volgende KADASTER bag_objecten gegevens:
      | adres                                    | gebruiksdoel       |
      | Witte de Withstraat 50, 3012BR Rotterdam | bijeenkomstfunctie |
    And de volgende GEMEENTE_ROTTERDAM bgt_terraslocaties gegevens:
      | adres                                    | locatie | beschikbare_oppervlakte | functie_oppervlak | is_openbare_weg |
      | Witte de Withstraat 50, 3012BR Rotterdam | voor    | 25                      | voetpad           | true            |
    And de volgende GEMEENTE_ROTTERDAM terrassenbeleid gegevens:
      | adres                                    | max_sluitingstijd_doordeweeks | max_sluitingstijd_weekend |
      | Witte de Withstraat 50, 3012BR Rotterdam | 1                             | 2                         |
    And de volgende GEMEENTE_ROTTERDAM vergunningen gegevens:
      | kvk_nummer | heeft_alcoholvergunning |
      | 85234567   | false                   |
    And de aanvraag is voor een terras:
      | locatie | oppervlakte | obstakelvrije_ruimte | seizoen  | openingstijd | sluitingstijd_doordeweeks | sluitingstijd_weekend |
      | voor    | 20          | 2.0                  | jaarrond | 10           | 23                        | 24                    |
    When de algemene_plaatselijke_verordening/terrassen wordt uitgevoerd door GEMEENTE_ROTTERDAM
    Then heeft de aanvrager geen recht op terrasvergunning
    And is de weigeringsgrond "Geen alcoholvergunning terwijl alcohol wordt geschonken"

  Scenario: Terras op eigen grond - geen precariobelasting
    # Precariobelasting is alleen verschuldigd voor terrassen op openbare gemeentegrond
    Given de volgende KVK organisaties gegevens:
      | kvk_nummer | status | vestigingsadres                          |
      | 85234567   | Actief | Witte de Withstraat 50, 3012BR Rotterdam |
    And de volgende GEMEENTE_ROTTERDAM exploitatievergunningen gegevens:
      | kvk_nummer | heeft_actieve_vergunning | verstrekt_alcoholhoudende_dranken |
      | 85234567   | true                     | false                             |
    And de volgende KADASTER bag_objecten gegevens:
      | adres                                    | gebruiksdoel       |
      | Witte de Withstraat 50, 3012BR Rotterdam | bijeenkomstfunctie |
    And de volgende GEMEENTE_ROTTERDAM bgt_terraslocaties gegevens:
      | adres                                    | locatie | beschikbare_oppervlakte | functie_oppervlak | is_openbare_weg |
      | Witte de Withstraat 50, 3012BR Rotterdam | achter  | 40                      | woonerf           | false           |
    And de volgende GEMEENTE_ROTTERDAM terrassenbeleid gegevens:
      | adres                                    | max_sluitingstijd_doordeweeks | max_sluitingstijd_weekend |
      | Witte de Withstraat 50, 3012BR Rotterdam | 1                             | 2                         |
    And de aanvraag is voor een terras:
      | locatie | oppervlakte | obstakelvrije_ruimte | seizoen  | openingstijd | sluitingstijd_doordeweeks | sluitingstijd_weekend |
      | achter  | 30          | 3.0                  | jaarrond | 10           | 23                        | 24                    |
    When de algemene_plaatselijke_verordening/terrassen wordt uitgevoerd door GEMEENTE_ROTTERDAM
    Then heeft de aanvrager recht op terrasvergunning
    And is de vergunde oppervlakte "30" m2
    And is de precariobelasting per jaar "0.00" euro
    And is geen precariobelasting verschuldigd

  Scenario: Grensgevalgeval - precies 1,8 meter obstakelvrije ruimte (net voldoende)
    # Artikel 2:30b lid 3: minimaal 1,8 meter is vereist, precies 1,8 is dus voldoende
    Given de volgende KVK organisaties gegevens:
      | kvk_nummer | status | vestigingsadres                          |
      | 85234567   | Actief | Witte de Withstraat 50, 3012BR Rotterdam |
    And de volgende GEMEENTE_ROTTERDAM exploitatievergunningen gegevens:
      | kvk_nummer | heeft_actieve_vergunning | verstrekt_alcoholhoudende_dranken |
      | 85234567   | true                     | false                             |
    And de volgende KADASTER bag_objecten gegevens:
      | adres                                    | gebruiksdoel       |
      | Witte de Withstraat 50, 3012BR Rotterdam | bijeenkomstfunctie |
    And de volgende GEMEENTE_ROTTERDAM bgt_terraslocaties gegevens:
      | adres                                    | locatie | beschikbare_oppervlakte | functie_oppervlak | is_openbare_weg |
      | Witte de Withstraat 50, 3012BR Rotterdam | voor    | 25                      | voetpad           | true            |
    And de volgende GEMEENTE_ROTTERDAM terrassenbeleid gegevens:
      | adres                                    | max_sluitingstijd_doordeweeks | max_sluitingstijd_weekend |
      | Witte de Withstraat 50, 3012BR Rotterdam | 1                             | 2                         |
    And de volgende GEMEENTE_ROTTERDAM precario_tarieven gegevens:
      | adres                                    | tarief_per_m2 |
      | Witte de Withstraat 50, 3012BR Rotterdam | 85.00         |
    And de volgende GEMEENTE_ROTTERDAM vergunningen gegevens:
      | kvk_nummer | heeft_alcoholvergunning |
      | 85234567   | false                   |
    And de aanvraag is voor een terras:
      | locatie | oppervlakte | obstakelvrije_ruimte | seizoen  | openingstijd | sluitingstijd_doordeweeks | sluitingstijd_weekend |
      | voor    | 20          | 1.8                  | jaarrond | 10           | 23                        | 24                    |
    When de algemene_plaatselijke_verordening/terrassen wordt uitgevoerd door GEMEENTE_ROTTERDAM
    Then heeft de aanvrager recht op terrasvergunning
    And is de vergunde oppervlakte "20" m2
