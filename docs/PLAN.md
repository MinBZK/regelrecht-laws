# Plan: Pensioenwetgeving Machine-Uitvoerbaar

## Doel
Implementatie van Nederlandse pensioenwetgeving in YAML-formaat zodat effecten van de wet "bedrag ineens" doorgerekend kunnen worden met scenario's.

## Inventaris: Bestaande vs Nieuwe Wetten

### Reeds Geïmplementeerd
| Wet | Bestand | Status |
|-----|---------|--------|
| AOW | `laws/algemene_ouderdomswet/SVB-2024-01-01.yaml` | Compleet |
| AOW Leeftijdsbepaling | `laws/algemene_ouderdomswet/leeftijdsbepaling/SVB-2024-01-01.yaml` | Compleet |
| Zorgtoeslag | `laws/zorgtoeslagwet/TOESLAGEN-2025-01-01.yaml` | Compleet |
| Huurtoeslag | `laws/wet_op_de_huurtoeslag/TOESLAGEN-2025-01-01.yaml` | Compleet |
| WW | `laws/werkloosheidswet/UWV-2025-01-01.yaml` | Compleet |
| WIA | `laws/wet_werk_en_inkomen_naar_arbeidsvermogen/UWV-2025-01-01.yaml` | Compleet |
| Inkomstenbelasting | `laws/wet_inkomstenbelasting/BELASTINGDIENST-2001-01-01.yaml` | Compleet |

### Nieuw Te Implementeren
| Wet | Bestand | Service | BWB-ID |
|-----|---------|---------|--------|
| Pensioenwet | `laws/pensioenwet/PENSIOENFONDS-2026-01-01.yaml` | PENSIOENFONDS | BWBR0020809 |
| Anw | `laws/algemene_nabestaandenwet/SVB-2026-01-01.yaml` | SVB | BWBR0007795 |
| AIO-aanvulling | `laws/participatiewet/aio/SVB-2026-01-01.yaml` | SVB | BWBR0015703 |
| Bijdrage Zvw | `laws/zorgverzekeringswet/bijdrage/BELASTINGDIENST-2026-01-01.yaml` | BELASTINGDIENST | BWBR0018450 |

## Implementatievolgorde

### Fase 0: Setup ✅
- Worktree aangemaakt
- docs/ directory aangemaakt
- PLAN.md en STATUS.md aangemaakt

### Fase 1: Pensioenwet
- Implementeer YAML
- Schrijf feature tests
- Valideer

### Fase 2: Bijdrage Zvw
- Implementeer YAML
- Schrijf feature tests
- Valideer

### Fase 3: Anw
- Implementeer YAML
- Schrijf feature tests
- Valideer

### Fase 4: AIO-aanvulling
- Implementeer YAML
- Schrijf feature tests
- Valideer

### Fase 5: Eindvalidatie
- Run alle behave tests
- Run pre-commit hooks
- Maak PR naar main

## Dataflow

```
PENSIOENFONDS (pensioen_uitkering_bruto)
        │
        ↓
BELASTINGDIENST (BOX1_UITKERINGEN bevat pensioen)
        │
        ├──→ TOESLAGEN (zorgtoeslag via INKOMEN)
        ├──→ TOESLAGEN (huurtoeslag via INKOMEN)
        └──→ SVB (AIO via INKOMEN)
```
