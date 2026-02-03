# Status: Pensioenwetgeving Implementatie

Laatst bijgewerkt: 2026-02-03

## Wetten Status

### Nieuwe Wetten
| Wet | Bestand | Status | Voortgang | Notities |
|-----|---------|--------|-----------|----------|
| Pensioenwet | `laws/pensioenwet/PENSIOENFONDS-2026-01-01.yaml` | ✅ Compleet | 100% | Basis voor alle berekeningen |
| Anw | `laws/algemene_nabestaandenwet/SVB-2026-01-01.yaml` | ✅ Compleet | 100% | Nabestaandenuitkering |
| AIO-aanvulling | `laws/participatiewet/aio/SVB-2026-01-01.yaml` | ✅ Compleet | 100% | Aanvulling sociaal minimum |
| Bijdrage Zvw | `laws/zorgverzekeringswet/bijdrage/BELASTINGDIENST-2026-01-01.yaml` | ✅ Compleet | 100% | Inkomensafhankelijke bijdrage |

### Bestaande Wetten (Verificatie)
| Wet | Bestand | Status | Notities |
|-----|---------|--------|----------|
| AOW | `laws/algemene_ouderdomswet/SVB-2024-01-01.yaml` | ✅ Compleet | Geen wijzigingen nodig |
| Zorgtoeslag | `laws/zorgtoeslagwet/TOESLAGEN-2025-01-01.yaml` | ✅ Compleet | Pensioen via BOX1_UITKERINGEN |
| Huurtoeslag | `laws/wet_op_de_huurtoeslag/TOESLAGEN-2025-01-01.yaml` | ✅ Compleet | Pensioen via INKOMEN |
| WW | `laws/werkloosheidswet/UWV-2025-01-01.yaml` | ✅ Compleet | Geen overlap met pensioen |
| WIA | `laws/wet_werk_en_inkomen_naar_arbeidsvermogen/UWV-2025-01-01.yaml` | ✅ Compleet | Geen overlap met pensioen |
| Inkomstenbelasting | `laws/wet_inkomstenbelasting/BELASTINGDIENST-2001-01-01.yaml` | ✅ Compleet | BOX1_UITKERINGEN bevat pensioen |

## Tests Status
| Test | Wet | Status | Notities |
|------|-----|--------|----------|
| `laws/pensioenwet/*.feature` | Pensioenwet | ✅ Aangemaakt | 6 scenario's |
| `laws/algemene_nabestaandenwet/*.feature` | Anw | ✅ Aangemaakt | 6 scenario's |
| `laws/participatiewet/aio/*.feature` | AIO | ✅ Aangemaakt | 5 scenario's |
| `laws/zorgverzekeringswet/bijdrage/*.feature` | Bijdrage Zvw | ✅ Aangemaakt | 5 scenario's |

## Validatie Status
| Actie | Status | Datum | Notities |
|-------|--------|-------|----------|
| Schema validatie | ✅ Compleet | 2026-02-03 | `python script/validate.py` geslaagd |
| Service references check | ✅ Compleet | 2026-02-03 | Alle references bestaan |
| Pre-commit hooks | ⏳ Pending | | Te runnen |
| Behave tests | ⏳ Pending | | Te runnen |

## Acties Log
| Datum | Actie | Resultaat |
|-------|-------|-----------|
| 2026-02-03 | Worktree aangemaakt | ✅ |
| 2026-02-03 | docs/PLAN.md en STATUS.md aangemaakt | ✅ |
| 2026-02-03 | Pensioenwet YAML geïmplementeerd | ✅ |
| 2026-02-03 | Pensioenwet feature tests geschreven | ✅ |
| 2026-02-03 | Bijdrage Zvw YAML geïmplementeerd | ✅ |
| 2026-02-03 | Bijdrage Zvw feature tests geschreven | ✅ |
| 2026-02-03 | Anw YAML geïmplementeerd | ✅ |
| 2026-02-03 | Anw feature tests geschreven | ✅ |
| 2026-02-03 | AIO-aanvulling YAML geïmplementeerd | ✅ |
| 2026-02-03 | AIO-aanvulling feature tests geschreven | ✅ |
| 2026-02-03 | Schema validatie uitgevoerd | ✅ |
| 2026-02-03 | Service references check geslaagd | ✅ |

## Legenda
- ⏳ Pending - Nog niet gestart
- 🔄 In Progress - Wordt aan gewerkt
- ✅ Compleet - Afgerond en gevalideerd
- ❌ Geblokkeerd - Wacht op andere actie
- ⚠️ Aandacht - Heeft review nodig
