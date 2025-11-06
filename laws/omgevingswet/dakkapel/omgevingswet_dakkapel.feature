Feature: Omgevingswet - Vergunningsvrije Dakkapellen
  Als burger
  Wil ik weten of mijn dakkapel vergunningsvrij geplaatst mag worden
  Zodat ik weet of ik een omgevingsvergunning moet aanvragen

  Background:
    Given de datum is "2024-06-01"

  # ==========================================
  # A. RIJKSREGELS - Basisscenarios (8)
  # ==========================================

  Scenario: 1. Vergunningsvrij - achterdak met correcte afmetingen
    When de omgevingswet/besluit_bouwwerken_leefomgeving wordt uitgevoerd door IENW met
      | LOCATIE | GRENST_AAN_OPENBAAR_GEBIED | HOOGTE_M | AFSTAND_DAKVOET_M | AFSTAND_DAKNOK_M | AFSTAND_ZIJKANT_LINKS_M | AFSTAND_ZIJKANT_RECHTS_M | DAKVORM | IS_RIJKSMONUMENT | IS_GEMEENTELIJK_MONUMENT | IS_BESCHERMD_STADS_OF_DORPSGEZICHT |
      | ACHTER  | false                      | 1.5      | 0.7               | 0.6              | 0.8                     | 0.8                      | PLAT    | false            | false                    | false                              |
    Then is voldaan aan de voorwaarden
    And is voldoet_aan_rijksregels "true"
    And is artikel_2_29_compliant "true"
    And is reden_afwijzing "Voldoet aan alle rijksregels voor vergunningsvrij bouwen"

  Scenario: 2. Vergunningsvrij - zijdak niet grenzend aan openbaar gebied
    When de omgevingswet/besluit_bouwwerken_leefomgeving wordt uitgevoerd door IENW met
      | LOCATIE | GRENST_AAN_OPENBAAR_GEBIED | HOOGTE_M | AFSTAND_DAKVOET_M | AFSTAND_DAKNOK_M | AFSTAND_ZIJKANT_LINKS_M | AFSTAND_ZIJKANT_RECHTS_M | DAKVORM | IS_RIJKSMONUMENT | IS_GEMEENTELIJK_MONUMENT | IS_BESCHERMD_STADS_OF_DORPSGEZICHT |
      | ZIJ     | false                      | 1.7      | 0.6               | 0.8              | 1.0                     | 1.0                      | PLAT    | false            | false                    | false                              |
    Then is voldaan aan de voorwaarden
    And is voldoet_aan_rijksregels "true"
    And is artikel_2_29_compliant "true"

  Scenario: 3. Vergunning vereist - voordak (openbaar gebied)
    When de omgevingswet/besluit_bouwwerken_leefomgeving wordt uitgevoerd door IENW met
      | LOCATIE | GRENST_AAN_OPENBAAR_GEBIED | HOOGTE_M | AFSTAND_DAKVOET_M | AFSTAND_DAKNOK_M | AFSTAND_ZIJKANT_LINKS_M | AFSTAND_ZIJKANT_RECHTS_M | DAKVORM | IS_RIJKSMONUMENT | IS_GEMEENTELIJK_MONUMENT | IS_BESCHERMD_STADS_OF_DORPSGEZICHT |
      | VOOR    | true                       | 1.5      | 0.7               | 0.6              | 0.8                     | 0.8                      | PLAT    | false            | false                    | false                              |
    Then is voldaan aan de voorwaarden
    And is voldoet_aan_rijksregels "false"
    And is artikel_2_29_compliant "false"
    And is reden_afwijzing "Locatie: voordakvlak is niet vergunningsvrij volgens artikel 2.29 lid 1 onder b Bbl"

  Scenario: 4. Vergunning vereist - te hoog (2.0m > 1.75m max)
    When de omgevingswet/besluit_bouwwerken_leefomgeving wordt uitgevoerd door IENW met
      | LOCATIE | GRENST_AAN_OPENBAAR_GEBIED | HOOGTE_M | AFSTAND_DAKVOET_M | AFSTAND_DAKNOK_M | AFSTAND_ZIJKANT_LINKS_M | AFSTAND_ZIJKANT_RECHTS_M | DAKVORM | IS_RIJKSMONUMENT | IS_GEMEENTELIJK_MONUMENT | IS_BESCHERMD_STADS_OF_DORPSGEZICHT |
      | ACHTER  | false                      | 2.0      | 0.7               | 0.6              | 0.8                     | 0.8                      | PLAT    | false            | false                    | false                              |
    Then is voldaan aan de voorwaarden
    And is voldoet_aan_rijksregels "false"
    And is artikel_2_29_compliant "false"
    And is reden_afwijzing "Hoogte: dakkapel overschrijdt maximum van 1,75 meter volgens artikel 2.29 lid 1 onder b Bbl"

  Scenario: 5. Vergunning vereist - te laag bij dakvoet (0.3m < 0.5m min)
    When de omgevingswet/besluit_bouwwerken_leefomgeving wordt uitgevoerd door IENW met
      | LOCATIE | GRENST_AAN_OPENBAAR_GEBIED | HOOGTE_M | AFSTAND_DAKVOET_M | AFSTAND_DAKNOK_M | AFSTAND_ZIJKANT_LINKS_M | AFSTAND_ZIJKANT_RECHTS_M | DAKVORM | IS_RIJKSMONUMENT | IS_GEMEENTELIJK_MONUMENT | IS_BESCHERMD_STADS_OF_DORPSGEZICHT |
      | ACHTER  | false                      | 1.5      | 0.3               | 0.6              | 0.8                     | 0.8                      | PLAT    | false            | false                    | false                              |
    Then is voldaan aan de voorwaarden
    And is voldoet_aan_rijksregels "false"
    And is reden_afwijzing "Afstand dakvoet: onderzijde moet meer dan 0,5 meter boven dakvoet zijn volgens artikel 2.29 lid 1 onder b Bbl"

  Scenario: 6. Vergunning vereist - schuin dak
    When de omgevingswet/besluit_bouwwerken_leefomgeving wordt uitgevoerd door IENW met
      | LOCATIE | GRENST_AAN_OPENBAAR_GEBIED | HOOGTE_M | AFSTAND_DAKVOET_M | AFSTAND_DAKNOK_M | AFSTAND_ZIJKANT_LINKS_M | AFSTAND_ZIJKANT_RECHTS_M | DAKVORM | IS_RIJKSMONUMENT | IS_GEMEENTELIJK_MONUMENT | IS_BESCHERMD_STADS_OF_DORPSGEZICHT |
      | ACHTER  | false                      | 1.5      | 0.7               | 0.6              | 0.8                     | 0.8                      | SCHUIN  | false            | false                    | false                              |
    Then is voldaan aan de voorwaarden
    And is voldoet_aan_rijksregels "false"
    And is reden_afwijzing "Dakvorm: dakkapel moet plat dak hebben volgens artikel 2.29 lid 1 onder b Bbl"

  Scenario: 7. Vergunning vereist - zijdak grenzend aan openbaar gebied
    When de omgevingswet/besluit_bouwwerken_leefomgeving wordt uitgevoerd door IENW met
      | LOCATIE | GRENST_AAN_OPENBAAR_GEBIED | HOOGTE_M | AFSTAND_DAKVOET_M | AFSTAND_DAKNOK_M | AFSTAND_ZIJKANT_LINKS_M | AFSTAND_ZIJKANT_RECHTS_M | DAKVORM | IS_RIJKSMONUMENT | IS_GEMEENTELIJK_MONUMENT | IS_BESCHERMD_STADS_OF_DORPSGEZICHT |
      | ZIJ     | true                       | 1.5      | 0.7               | 0.6              | 0.8                     | 0.8                      | PLAT    | false            | false                    | false                              |
    Then is voldaan aan de voorwaarden
    And is voldoet_aan_rijksregels "false"
    And is reden_afwijzing "Locatie: zijdakvlak grenst aan openbaar toegankelijk gebied, niet vergunningsvrij volgens artikel 2.29 lid 1 onder b Bbl"

  Scenario: 8. Vergunning vereist - afstand zijkant te klein
    When de omgevingswet/besluit_bouwwerken_leefomgeving wordt uitgevoerd door IENW met
      | LOCATIE | GRENST_AAN_OPENBAAR_GEBIED | HOOGTE_M | AFSTAND_DAKVOET_M | AFSTAND_DAKNOK_M | AFSTAND_ZIJKANT_LINKS_M | AFSTAND_ZIJKANT_RECHTS_M | DAKVORM | IS_RIJKSMONUMENT | IS_GEMEENTELIJK_MONUMENT | IS_BESCHERMD_STADS_OF_DORPSGEZICHT |
      | ACHTER  | false                      | 1.5      | 0.7               | 0.6              | 0.3                     | 0.8                      | PLAT    | false            | false                    | false                              |
    Then is voldaan aan de voorwaarden
    And is voldoet_aan_rijksregels "false"
    And is reden_afwijzing "Afstand zijkant: linkerzijde moet meer dan 0,5 meter van zijkant dakvlak zijn volgens artikel 2.29 lid 1 onder b Bbl"

  # ==========================================
  # B. MONUMENTEN - Artikel 2.30 (4)
  # ==========================================

  Scenario: 9. Vergunning vereist - rijksmonument
    When de omgevingswet/besluit_bouwwerken_leefomgeving wordt uitgevoerd door IENW met
      | LOCATIE | GRENST_AAN_OPENBAAR_GEBIED | HOOGTE_M | AFSTAND_DAKVOET_M | AFSTAND_DAKNOK_M | AFSTAND_ZIJKANT_LINKS_M | AFSTAND_ZIJKANT_RECHTS_M | DAKVORM | IS_RIJKSMONUMENT | IS_GEMEENTELIJK_MONUMENT | IS_BESCHERMD_STADS_OF_DORPSGEZICHT |
      | ACHTER  | false                      | 1.5      | 0.7               | 0.6              | 0.8                     | 0.8                      | PLAT    | true             | false                    | false                              |
    Then is niet voldaan aan de voorwaarden

  Scenario: 10. Vergunning vereist - gemeentelijk monument
    When de omgevingswet/besluit_bouwwerken_leefomgeving wordt uitgevoerd door IENW met
      | LOCATIE | GRENST_AAN_OPENBAAR_GEBIED | HOOGTE_M | AFSTAND_DAKVOET_M | AFSTAND_DAKNOK_M | AFSTAND_ZIJKANT_LINKS_M | AFSTAND_ZIJKANT_RECHTS_M | DAKVORM | IS_RIJKSMONUMENT | IS_GEMEENTELIJK_MONUMENT | IS_BESCHERMD_STADS_OF_DORPSGEZICHT |
      | ACHTER  | false                      | 1.5      | 0.7               | 0.6              | 0.8                     | 0.8                      | PLAT    | false            | true                     | false                              |
    Then is niet voldaan aan de voorwaarden

  Scenario: 11. Vergunning vereist - beide monumenten
    When de omgevingswet/besluit_bouwwerken_leefomgeving wordt uitgevoerd door IENW met
      | LOCATIE | GRENST_AAN_OPENBAAR_GEBIED | HOOGTE_M | AFSTAND_DAKVOET_M | AFSTAND_DAKNOK_M | AFSTAND_ZIJKANT_LINKS_M | AFSTAND_ZIJKANT_RECHTS_M | DAKVORM | IS_RIJKSMONUMENT | IS_GEMEENTELIJK_MONUMENT | IS_BESCHERMD_STADS_OF_DORPSGEZICHT |
      | ACHTER  | false                      | 1.5      | 0.7               | 0.6              | 0.8                     | 0.8                      | PLAT    | true             | true                     | false                              |
    Then is niet voldaan aan de voorwaarden

  Scenario: 12. Vergunningsvrij - beschermd stads/dorpsgezicht (alleen waarschuwing)
    When de omgevingswet/besluit_bouwwerken_leefomgeving wordt uitgevoerd door IENW met
      | LOCATIE | GRENST_AAN_OPENBAAR_GEBIED | HOOGTE_M | AFSTAND_DAKVOET_M | AFSTAND_DAKNOK_M | AFSTAND_ZIJKANT_LINKS_M | AFSTAND_ZIJKANT_RECHTS_M | DAKVORM | IS_RIJKSMONUMENT | IS_GEMEENTELIJK_MONUMENT | IS_BESCHERMD_STADS_OF_DORPSGEZICHT |
      | ACHTER  | false                      | 1.5      | 0.7               | 0.6              | 0.8                     | 0.8                      | PLAT    | false            | false                    | true                               |
    Then is voldaan aan de voorwaarden
    And is voldoet_aan_rijksregels "true"

  # ==========================================
  # C. ROTTERDAM - Strengere regels (6)
  # ==========================================

  Scenario: 13. Rotterdam vergunningsvrij - achterdak 1.4m hoog
    When de omgevingswet/omgevingsplan_rotterdam wordt uitgevoerd door GEMEENTE_ROTTERDAM met
      | LOCATIE | GRENST_AAN_OPENBAAR_GEBIED | HOOGTE_M | AFSTAND_DAKVOET_M | AFSTAND_DAKNOK_M | AFSTAND_ZIJKANT_LINKS_M | AFSTAND_ZIJKANT_RECHTS_M | DAKVORM | WONING_BREEDTE_M | BREEDTE_DAKKAPEL_M | HEEFT_OVERSTEK | OVERSTEK_DIEPTE_M | IS_RIJKSMONUMENT | IS_GEMEENTELIJK_MONUMENT | IS_BESCHERMD_STADS_OF_DORPSGEZICHT |
      | ACHTER  | false                      | 1.4      | 0.7               | 0.6              | 0.8                     | 0.8                      | PLAT    | 10.0             | 3.0                | true           | 0.08              | false            | false                    | false                              |
    Then is voldaan aan de voorwaarden

  Scenario: 14. Rotterdam vergunning vereist - te hoog (1.6m > 1.5m Rotterdam max)
    When de omgevingswet/omgevingsplan_rotterdam wordt uitgevoerd door GEMEENTE_ROTTERDAM met
      | LOCATIE | GRENST_AAN_OPENBAAR_GEBIED | HOOGTE_M | AFSTAND_DAKVOET_M | AFSTAND_DAKNOK_M | AFSTAND_ZIJKANT_LINKS_M | AFSTAND_ZIJKANT_RECHTS_M | DAKVORM | WONING_BREEDTE_M | BREEDTE_DAKKAPEL_M | HEEFT_OVERSTEK | OVERSTEK_DIEPTE_M | IS_RIJKSMONUMENT | IS_GEMEENTELIJK_MONUMENT | IS_BESCHERMD_STADS_OF_DORPSGEZICHT |
      | ACHTER  | false                      | 1.6      | 0.7               | 0.6              | 0.8                     | 0.8                      | PLAT    | 10.0             | 3.0                | true           | 0.08              | false            | false                    | false                              |
    Then is voldaan aan de voorwaarden

  Scenario: 15. Rotterdam vergunning vereist - te breed (50% > 33% max)
    When de omgevingswet/omgevingsplan_rotterdam wordt uitgevoerd door GEMEENTE_ROTTERDAM met
      | LOCATIE | GRENST_AAN_OPENBAAR_GEBIED | HOOGTE_M | AFSTAND_DAKVOET_M | AFSTAND_DAKNOK_M | AFSTAND_ZIJKANT_LINKS_M | AFSTAND_ZIJKANT_RECHTS_M | DAKVORM | WONING_BREEDTE_M | BREEDTE_DAKKAPEL_M | HEEFT_OVERSTEK | OVERSTEK_DIEPTE_M | IS_RIJKSMONUMENT | IS_GEMEENTELIJK_MONUMENT | IS_BESCHERMD_STADS_OF_DORPSGEZICHT |
      | ACHTER  | false                      | 1.4      | 0.7               | 0.6              | 0.8                     | 0.8                      | PLAT    | 10.0             | 5.0                | true           | 0.08              | false            | false                    | false                              |
    Then is voldaan aan de voorwaarden

  Scenario: 16. Rotterdam vergunning vereist - geen overstek
    When de omgevingswet/omgevingsplan_rotterdam wordt uitgevoerd door GEMEENTE_ROTTERDAM met
      | LOCATIE | GRENST_AAN_OPENBAAR_GEBIED | HOOGTE_M | AFSTAND_DAKVOET_M | AFSTAND_DAKNOK_M | AFSTAND_ZIJKANT_LINKS_M | AFSTAND_ZIJKANT_RECHTS_M | DAKVORM | WONING_BREEDTE_M | BREEDTE_DAKKAPEL_M | HEEFT_OVERSTEK | OVERSTEK_DIEPTE_M | IS_RIJKSMONUMENT | IS_GEMEENTELIJK_MONUMENT | IS_BESCHERMD_STADS_OF_DORPSGEZICHT |
      | ACHTER  | false                      | 1.4      | 0.7               | 0.6              | 0.8                     | 0.8                      | PLAT    | 10.0             | 3.0                | false          | 0.0               | false            | false                    | false                              |
    Then is voldaan aan de voorwaarden

  Scenario: 17. Rotterdam vergunning vereist - zijdak te dicht bij openbaar gebied
    When de omgevingswet/omgevingsplan_rotterdam wordt uitgevoerd door GEMEENTE_ROTTERDAM met
      | LOCATIE | GRENST_AAN_OPENBAAR_GEBIED | HOOGTE_M | AFSTAND_DAKVOET_M | AFSTAND_DAKNOK_M | AFSTAND_ZIJKANT_LINKS_M | AFSTAND_ZIJKANT_RECHTS_M | DAKVORM | WONING_BREEDTE_M | BREEDTE_DAKKAPEL_M | HEEFT_OVERSTEK | OVERSTEK_DIEPTE_M | AFSTAND_OPENBAAR_GEBIED_M | IS_RIJKSMONUMENT | IS_GEMEENTELIJK_MONUMENT | IS_BESCHERMD_STADS_OF_DORPSGEZICHT |
      | ZIJ     | true                       | 1.4      | 0.7               | 0.6              | 0.8                     | 0.8                      | PLAT    | 10.0             | 3.0                | true           | 0.08              | 1.5                       | false            | false                    | false                              |
    Then is voldaan aan de voorwaarden

  Scenario: 18. Rotterdam vergunningsvrij - zijdak met 2.5m afstand openbaar gebied
    When de omgevingswet/omgevingsplan_rotterdam wordt uitgevoerd door GEMEENTE_ROTTERDAM met
      | LOCATIE | GRENST_AAN_OPENBAAR_GEBIED | HOOGTE_M | AFSTAND_DAKVOET_M | AFSTAND_DAKNOK_M | AFSTAND_ZIJKANT_LINKS_M | AFSTAND_ZIJKANT_RECHTS_M | DAKVORM | WONING_BREEDTE_M | BREEDTE_DAKKAPEL_M | HEEFT_OVERSTEK | OVERSTEK_DIEPTE_M | AFSTAND_OPENBAAR_GEBIED_M | IS_RIJKSMONUMENT | IS_GEMEENTELIJK_MONUMENT | IS_BESCHERMD_STADS_OF_DORPSGEZICHT |
      | ZIJ     | true                       | 1.4      | 0.7               | 0.6              | 0.8                     | 0.8                      | PLAT    | 10.0             | 3.0                | true           | 0.08              | 2.5                       | false            | false                    | false                              |
    Then is voldaan aan de voorwaarden

  # ==========================================
  # D. AMSTERDAM - Welstand (4)
  # ==========================================

  Scenario: 19. Amsterdam vergunningsvrij - achterdak buiten beschermd gebied
    When de omgevingswet/omgevingsplan_amsterdam wordt uitgevoerd door GEMEENTE_AMSTERDAM met
      | LOCATIE | GRENST_AAN_OPENBAAR_GEBIED | HOOGTE_M | AFSTAND_DAKVOET_M | AFSTAND_DAKNOK_M | AFSTAND_ZIJKANT_LINKS_M | AFSTAND_ZIJKANT_RECHTS_M | DAKVORM | POSTCODE | IS_RIJKSMONUMENT | IS_GEMEENTELIJK_MONUMENT | IS_BESCHERMD_STADS_OF_DORPSGEZICHT |
      | ACHTER  | false                      | 1.5      | 0.7               | 0.6              | 0.8                     | 0.8                      | PLAT    | 1055       | false            | false                    | false                              |
    Then is voldaan aan de voorwaarden

  Scenario: 20. Amsterdam welstandstoets vereist - voordak grachtengordel
    When de omgevingswet/omgevingsplan_amsterdam wordt uitgevoerd door GEMEENTE_AMSTERDAM met
      | LOCATIE | GRENST_AAN_OPENBAAR_GEBIED | HOOGTE_M | AFSTAND_DAKVOET_M | AFSTAND_DAKNOK_M | AFSTAND_ZIJKANT_LINKS_M | AFSTAND_ZIJKANT_RECHTS_M | DAKVORM | POSTCODE | IS_RIJKSMONUMENT | IS_GEMEENTELIJK_MONUMENT | IS_BESCHERMD_STADS_OF_DORPSGEZICHT |
      | VOOR    | true                       | 1.5      | 0.7               | 0.6              | 0.8                     | 0.8                      | PLAT    | 1015       | false            | false                    | false                              |
    Then is voldaan aan de voorwaarden

  Scenario: 21. Amsterdam achterdak in beschermd gebied - vergunningsvrij zonder welstand
    When de omgevingswet/omgevingsplan_amsterdam wordt uitgevoerd door GEMEENTE_AMSTERDAM met
      | LOCATIE | GRENST_AAN_OPENBAAR_GEBIED | HOOGTE_M | AFSTAND_DAKVOET_M | AFSTAND_DAKNOK_M | AFSTAND_ZIJKANT_LINKS_M | AFSTAND_ZIJKANT_RECHTS_M | DAKVORM | POSTCODE | IS_RIJKSMONUMENT | IS_GEMEENTELIJK_MONUMENT | IS_BESCHERMD_STADS_OF_DORPSGEZICHT |
      | ACHTER  | false                      | 1.5      | 0.7               | 0.6              | 0.8                     | 0.8                      | PLAT    | 1016       | false            | false                    | true                               |
    Then is voldaan aan de voorwaarden

  Scenario: 22. Amsterdam monument - vergunning vereist
    When de omgevingswet/omgevingsplan_amsterdam wordt uitgevoerd door GEMEENTE_AMSTERDAM met
      | LOCATIE | GRENST_AAN_OPENBAAR_GEBIED | HOOGTE_M | AFSTAND_DAKVOET_M | AFSTAND_DAKNOK_M | AFSTAND_ZIJKANT_LINKS_M | AFSTAND_ZIJKANT_RECHTS_M | DAKVORM | POSTCODE | IS_RIJKSMONUMENT | IS_GEMEENTELIJK_MONUMENT | IS_BESCHERMD_STADS_OF_DORPSGEZICHT |
      | ACHTER  | false                      | 1.5      | 0.7               | 0.6              | 0.8                     | 0.8                      | PLAT    | 1015       | false            | true                     | false                              |
    Then is voldaan aan de voorwaarden
    And is vergunningvrij "false"
    And is vergunning_vereist "true"

  # ==========================================
  # E. EDGE CASES (6)
  # ==========================================

  Scenario: 23. Vergunningsvrij - exact op grenzen rijksregels
    When de omgevingswet/besluit_bouwwerken_leefomgeving wordt uitgevoerd door IENW met
      | LOCATIE | GRENST_AAN_OPENBAAR_GEBIED | HOOGTE_M | AFSTAND_DAKVOET_M | AFSTAND_DAKNOK_M | AFSTAND_ZIJKANT_LINKS_M | AFSTAND_ZIJKANT_RECHTS_M | DAKVORM | IS_RIJKSMONUMENT | IS_GEMEENTELIJK_MONUMENT | IS_BESCHERMD_STADS_OF_DORPSGEZICHT |
      | ACHTER  | false                      | 1.75     | 0.5               | 0.5              | 0.5                     | 0.5                      | PLAT    | false            | false                    | false                              |
    Then is voldaan aan de voorwaarden
    And is voldoet_aan_rijksregels "true"

  Scenario: 24. Vergunning vereist - net boven grens rijksregels
    When de omgevingswet/besluit_bouwwerken_leefomgeving wordt uitgevoerd door IENW met
      | LOCATIE | GRENST_AAN_OPENBAAR_GEBIED | HOOGTE_M | AFSTAND_DAKVOET_M | AFSTAND_DAKNOK_M | AFSTAND_ZIJKANT_LINKS_M | AFSTAND_ZIJKANT_RECHTS_M | DAKVORM | IS_RIJKSMONUMENT | IS_GEMEENTELIJK_MONUMENT | IS_BESCHERMD_STADS_OF_DORPSGEZICHT |
      | ACHTER  | false                      | 1.76     | 0.7               | 0.6              | 0.8                     | 0.8                      | PLAT    | false            | false                    | false                              |
    Then is voldaan aan de voorwaarden
    And is voldoet_aan_rijksregels "false"

  Scenario: 25. Rotterdam exact op grens - 1.5m max
    When de omgevingswet/omgevingsplan_rotterdam wordt uitgevoerd door GEMEENTE_ROTTERDAM met
      | LOCATIE | GRENST_AAN_OPENBAAR_GEBIED | HOOGTE_M | AFSTAND_DAKVOET_M | AFSTAND_DAKNOK_M | AFSTAND_ZIJKANT_LINKS_M | AFSTAND_ZIJKANT_RECHTS_M | DAKVORM | WONING_BREEDTE_M | BREEDTE_DAKKAPEL_M | HEEFT_OVERSTEK | OVERSTEK_DIEPTE_M | IS_RIJKSMONUMENT | IS_GEMEENTELIJK_MONUMENT | IS_BESCHERMD_STADS_OF_DORPSGEZICHT |
      | ACHTER  | false                      | 1.5      | 0.7               | 0.6              | 0.8                     | 0.8                      | PLAT    | 10.0             | 3.3                | true           | 0.05              | false            | false                    | false                              |
    Then is voldaan aan de voorwaarden

  Scenario: 26. Rotterdam exact 1/3 breedte - 3.33m op 10m
    When de omgevingswet/omgevingsplan_rotterdam wordt uitgevoerd door GEMEENTE_ROTTERDAM met
      | LOCATIE | GRENST_AAN_OPENBAAR_GEBIED | HOOGTE_M | AFSTAND_DAKVOET_M | AFSTAND_DAKNOK_M | AFSTAND_ZIJKANT_LINKS_M | AFSTAND_ZIJKANT_RECHTS_M | DAKVORM | WONING_BREEDTE_M | BREEDTE_DAKKAPEL_M | HEEFT_OVERSTEK | OVERSTEK_DIEPTE_M | IS_RIJKSMONUMENT | IS_GEMEENTELIJK_MONUMENT | IS_BESCHERMD_STADS_OF_DORPSGEZICHT |
      | ACHTER  | false                      | 1.4      | 0.7               | 0.6              | 0.8                     | 0.8                      | PLAT    | 10.0             | 3.33               | true           | 0.08              | false            | false                    | false                              |
    Then is voldaan aan de voorwaarden

  Scenario: 27. Vergunning vereist - minimale overstek te klein Rotterdam
    When de omgevingswet/omgevingsplan_rotterdam wordt uitgevoerd door GEMEENTE_ROTTERDAM met
      | LOCATIE | GRENST_AAN_OPENBAAR_GEBIED | HOOGTE_M | AFSTAND_DAKVOET_M | AFSTAND_DAKNOK_M | AFSTAND_ZIJKANT_LINKS_M | AFSTAND_ZIJKANT_RECHTS_M | DAKVORM | WONING_BREEDTE_M | BREEDTE_DAKKAPEL_M | HEEFT_OVERSTEK | OVERSTEK_DIEPTE_M | IS_RIJKSMONUMENT | IS_GEMEENTELIJK_MONUMENT | IS_BESCHERMD_STADS_OF_DORPSGEZICHT |
      | ACHTER  | false                      | 1.4      | 0.7               | 0.6              | 0.8                     | 0.8                      | PLAT    | 10.0             | 3.0                | true           | 0.03              | false            | false                    | false                              |
    Then is voldaan aan de voorwaarden

  Scenario: 28. Vergunning vereist - dakvoet te hoog (1.2m > 1.0m max)
    When de omgevingswet/besluit_bouwwerken_leefomgeving wordt uitgevoerd door IENW met
      | LOCATIE | GRENST_AAN_OPENBAAR_GEBIED | HOOGTE_M | AFSTAND_DAKVOET_M | AFSTAND_DAKNOK_M | AFSTAND_ZIJKANT_LINKS_M | AFSTAND_ZIJKANT_RECHTS_M | DAKVORM | IS_RIJKSMONUMENT | IS_GEMEENTELIJK_MONUMENT | IS_BESCHERMD_STADS_OF_DORPSGEZICHT |
      | ACHTER  | false                      | 1.5      | 1.2               | 0.6              | 0.8                     | 0.8                      | PLAT    | false            | false                    | false                              |
    Then is voldaan aan de voorwaarden
    And is voldoet_aan_rijksregels "false"
    And is reden_afwijzing "Afstand dakvoet: onderzijde moet minder dan 1 meter boven dakvoet zijn volgens artikel 2.29 lid 1 onder b Bbl"
