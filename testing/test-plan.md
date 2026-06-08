# ClubManager Test Plan

Ovaj dokument definiše način testiranja ClubManager aplikacije u skladu sa operativnim tokom:

```text
clubmanager-inventory.md
    ↓
module-status.md
    ↓
cleanup-backlog.md / testing
    ↓
module-status.md
    ↓
clubmanager-inventory.md
```

---

## 1. Source rule

Testiranje se ne pokreće iz chata, inventory-ja ili cleanup-backlog-a.

Tester dobija nalog isključivo iz:

```text
docs/product/module-status.md
```

i to iz sekcije:

```text
Ready for Testing
```

Checklist-a se koristi samo ako je test paket u `module-status.md` označen kao:

```text
Ready
```

Ako je paket označen kao `Draft`, `Deferred`, `Blocked` ili `Later`, tester ga ne radi kao zvanični test nalog.

---

## 2. Uloge dokumenata

| Dokument                    | Uloga                                                          |
| --------------------------- | -------------------------------------------------------------- |
| `clubmanager-inventory.md`  | Mapa proizvoda i status feature-a                              |
| `module-status.md`          | Komandni centar; odlučuje šta ide na testiranje                |
| `cleanup-backlog.md`        | Dev backlog; developer označava `Open`, `In Progress`, `Fixed` |
| `test-plan.md`              | Opšta pravila testiranja                                       |
| `checklists/*.md`           | Izvršenje konkretnog test paketa                               |
| `tester-report-template.md` | Format za prijavu `Failed` i `Blocked` rezultata               |

---

## 3. Release focus

Trenutni produkcijski cilj:

```text
Release 1 — Tenant Production MVP
```

Značenje:

```text
Prva produkcijska verzija Tenant App aplikacije za sekretara i vlasnika/menadžera kluba.
```

Primarni korisnici:

```text
club secretary
club owner / manager
```

Release 1 fokus:

| Area / Module            | R1 status         | Notes                                                                             |
| ------------------------ | ----------------- | --------------------------------------------------------------------------------- |
| Tenant App               | Included          | Glavni fokus                                                                      |
| Dashboard                | Included          | Basic dashboard                                                                   |
| Players                  | Included          | Core profile, photo, registrations, medicals, documents, contracts, eligibility   |
| Staff                    | Included          | CRUD, photo, validation, team assignments                                         |
| Teams                    | Included          | Team CRUD, player memberships, staff memberships                                  |
| Events                   | Included          | Event CRUD, lifecycle, attendance, lineup / MatchList                             |
| Documents Engine         | Included, limited | Player documents; Club documents nisu R1 dok se ne riješi schema/service mismatch |
| Finance Fees / Članarine | Included          | Tenant članarine                                                                  |
| General Finance          | Included, basic   | Categories, transactions, storno                                                  |
| Tenant users             | Minimal           | Samo ono što treba za rad kluba                                                   |
| Player Portal            | Deferred          | R1.5                                                                              |
| Admin Platform           | Deferred          | R2                                                                                |
| Platform Billing         | Deferred          | R3                                                                                |
| Notifications            | Deferred          | Later                                                                             |
| Advanced reports         | Deferred          | Later                                                                             |

---

## 4. Šta tester smije testirati

Tester smije testirati samo pakete koji su u:

```text
docs/product/module-status.md → Ready for Testing
```

i imaju:

```text
Status = Ready
```

Za svaki test paket moraju biti navedeni:

| Field        | Meaning                                                        |
| ------------ | -------------------------------------------------------------- |
| Test Package | Naziv test paketa                                              |
| Release      | Release kojem pripada                                          |
| Area         | Dio aplikacije                                                 |
| Scope        | Šta se testira                                                 |
| Checklist    | Koji checklist fajl se koristi                                 |
| Status       | Draft / Ready / Testing / Passed / Failed / Blocked / Deferred |
| Notes        | Posebne napomene i izuzeci                                     |

---

## 5. Šta tester ne smije testirati kao zvanični nalog

Tester ne smije samostalno proširivati scope testiranja mimo naloga iz `module-status.md`.

Za Release 1 ne testirati kao final verification:

| Area                    | Reason                                         |
| ----------------------- | ---------------------------------------------- |
| Player Portal rollout   | R1.5                                           |
| Admin Platform polish   | R2                                             |
| Platform Billing        | R3                                             |
| Notifications           | Planned/later                                  |
| Password reset          | Poznati cleanup/gap                            |
| Club documents          | Schema/service mismatch                        |
| Admin placeholder pages | Nisu R1 fokus                                  |
| Standalone payments     | Platform Billing / later                       |
| Advanced reports        | Later                                          |
| Dev diagnostics         | Ciljani security cleanup, ne opšti tester flow |

---

## 6. Test statusi

| Status       | Značenje                                                               |
| ------------ | ---------------------------------------------------------------------- |
| Not tested   | Test još nije izvršen                                                  |
| Passed       | Test je prošao                                                         |
| Failed       | Test nije prošao                                                       |
| Blocked      | Test se ne može izvršiti zbog greške, poznatog blockera ili zavisnosti |
| Needs retest | Test treba ponoviti nakon fix-a                                        |
| Deferred     | Svjesno odloženo                                                       |

---

## 7. Pravilo za Failed / Blocked

Za svaki `Failed` ili `Blocked` rezultat tester mora popuniti report po template-u:

```text
docs/testing/checklists/tester-report-template.md
```

Minimalno mora navesti:

```text
Test ID:
Status:
Environment:
User / role:
URL:
Steps:
Expected result:
Actual result:
Screenshot:
Notes:
```

---

## 8. Kretanje tester nalaza

Ako tester nađe bug:

```text
Tester report
    ↓
module-status.md
    ↓
cleanup-backlog.md
    ↓
developer fix
    ↓
cleanup-backlog.md = Fixed
    ↓
module-status.md = Ready for Testing
    ↓
tester retest
    ↓
module-status.md = Passed / Failed / Blocked
    ↓
inventory update only if feature is verified
```

Tester ne ažurira inventory direktno.

Developer ne izdaje nalog testeru.

---

## 9. Verified pravilo

Feature može preći u `Verified` samo ako:

1. Postoji u inventory-ju.
2. Nema otvoren R1 P0 blocker za taj feature.
3. P1 blocker je riješen ili svjesno prihvaćen.
4. Test paket ili relevantni test case je prošao.
5. Rezultat je evidentiran u `module-status.md`.
6. Inventory se ažurira nakon dokaza.

Važno:

```text
Fixed nije isto što i Verified.
```

| Termin   | Značenje                                                        |
| -------- | --------------------------------------------------------------- |
| Fixed    | Developer je završio popravku                                   |
| Retested | Tester je ponovio test nakon fix-a                              |
| Verified | Feature je funkcionalno potvrđen i inventory status je ažuriran |
| Polished | Feature je potvrđen i dodatno UX/visualno dotjeran              |

---

## 10. Prvi planirani test paket

Trenutni prvi planirani paket:

```text
Tenant Production Basic Flow
```

Checklist:

```text
docs/testing/checklists/tenant-production-basic-checklist.md
```

Ovaj paket se ne smatra aktivnim dok `module-status.md → Ready for Testing` ne kaže:

```text
Status = Ready
```

Dok je status `Draft`, checklist postoji samo kao priprema.

---

## 11. Test environment

| Field           | Value       |
| --------------- | ----------- |
| Environment     | DEV / STAGE |
| Tenant FE URL   |             |
| API URL         |             |
| Browser         |             |
| Tester          |             |
| Test date       |             |
| Club            |             |
| User / role     |             |
| Build / version |             |
| Notes           |             |

---

## 12. Release 1 exit criteria

Release 1 može ići prema produkciji kada:

* Tenant login radi stabilno.
* Dashboard se učitava bez greške.
* Players osnovni tok radi.
* Staff osnovni tok radi.
* Teams i memberships osnovno rade.
* Events osnovno rade.
* Attendance osnovno radi.
* Lineup / MatchList osnovno radi.
* Player documents osnovni lifecycle radi.
* Registrations, medicals, contracts i Eligibility Lite imaju potvrđene osnovne tokove.
* Finance Fees osnovni tok radi: invoice, payment, partial/full, storno, refresh.
* Tenant users minimalni flow radi ili je jasno ograničen.
* Nema otvorenih R1 P0 stavki koje direktno ugrožavaju Tenant App.
* Kritični P1 problemi su riješeni ili svjesno prihvaćeni.
* `module-status.md` i `clubmanager-inventory.md` su ažurirani.
