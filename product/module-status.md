# ClubManager Module Status

Ovaj dokument prati kratki operativni status ClubManager modula.

Za detaljan inventory koristiti:

```text
docs/product/clubmanager-inventory.md
```

Za strateški pregled i širi portfolio koristiti OneNote.

---

## Status legenda

| Status             | Značenje                                                |
| ------------------ | ------------------------------------------------------- |
| Done               | Završeno i trenutno nema aktivnog rada                  |
| In Progress        | Aktivno se radi                                         |
| Next               | Sljedeće za rad                                         |
| Needs Verification | Treba provjeriti kroz kod, bazu, Swagger ili aplikaciju |
| Blocked            | Blokirano zbog greške, odluke ili zavisnosti            |
| Later              | Planirano za kasnije                                    |
| Deprecated         | Više se ne koristi                                      |

---

## Done

| Module        | Feature                            | Status             | Notes                                                                                                         |
| ------------- | ---------------------------------- | ------------------ | ------------------------------------------------------------------------------------------------------------- |
| Documentation | Central docs structure             | Done               | Kreiran centralni folder `/home/kemo/ClubManager/docs`                                                        |
| Documentation | OneNote structure                  | Done               | OneNote se koristi kao radna tabla / pregled                                                                  |
| Documentation | Central docs Git repo              | Done               | `/home/kemo/ClubManager/docs` je poseban Git repo i centralna dokumentacija projekta                          |
| Players       | Player CRUD                        | Needs Verification | Smatra se implementiranim, ali treba formalna provjera                                                        |
| Staff         | Basic Staff module                 | Needs Verification | CRUD i osnovne popravke postoje, treba potvrditi stanje                                                       |
| Teams         | Basic Teams module                 | Needs Verification | Osnovni modul postoji, treba potvrditi status                                                                 |
| Documents     | Basic document handling            | Needs Verification | Upload/download/replace/delete postoje, treba potvrditi kroz aplikaciju                                       |
| Photos        | Photo/avatar pipeline              | Done               | Standardized PersonThumb/usePersonPhoto/mediaStore pipeline; legacy photo cache removed and manually verified |
| Player Portal | Aktivacija, deaktivacija i lozinka | Done               | Aktivacija, deaktivacija, reaktivacija i promjena lozinke su testirane                                        |
| Player Portal | Player FE osnovne stranice         | Done               | Profil, događaji, prisustvo i članarine su provjereni nakon player login-a                                    |

---

---

## In Progress

| Module     | Feature                           | Status      | Notes                                                           |
| ---------- | --------------------------------- | ----------- | --------------------------------------------------------------- |
| Finance    | Charges, payments, financial card | In Progress | Visok prioritet prije većeg DevOps razdvajanja                  |
| Attendance | Lock/unlock and statistics rules  | In Progress | Lock poslije kraja eventa; statistika samo iz locked attendance |
| Events     | Event lifecycle rules             | In Progress | Edit/delete pravila zavise od lineup/attendance stanja          |
| Lineup     | MatchList/Lineup UI               | In Progress | Header treba uskladiti sa Attendance panelom                    |
| Player FE  | UI/mobile polish                  | In Progress | Core stranice su verificirane; ostaje vizuelni i UX polish      |

---

## Next

| Priority | Module        | Feature                                     | Notes                                                                 |
| -------- | ------------- | ------------------------------------------- | --------------------------------------------------------------------- |
| 1        | Finance       | Continue finance finalization               | BE + FE + testiranje                                                  |
| 2        | Player Portal | Reactivation email uniqueness check         | Backend treba spriječiti dupli `users.email` kod reaktivacije portala |
| 3        | Player Portal | Clarify contact vs portal email labels      | UI treba jasno razlikovati kontakt email i email za prijavu           |
| 4        | Attendance    | Apply lock/read-only rules                  | Zaključan attendance ne smije dozvoliti izmjene                       |
| 5        | Events        | Verify lifecycle rules                      | Posebno direct URL i zabrane edit/delete                              |
| 6        | Documentation | Update inventory after each verified module | Svaku potvrdu unijeti u inventory tabelu                              |

---

## Needs Verification

| Module    | Feature          | What to verify                                                           |
| --------- | ---------------- | ------------------------------------------------------------------------ |
| Players   | Player CRUD      | Create/edit/delete/detail, JMBG validation, auto birth date              |
| Staff     | Staff module     | CRUD, country select, date input, team staff assignment                  |
| Teams     | Team module      | CRUD, team members, staff assignment, tenant scope                       |
| Documents | Documents module | Upload, download, replace, deactivate, delete, purge                     |
| Attendance| Lock rules       | Lock only after event end, locked read-only                              |
| Events    | Lifecycle rules  | Edit/delete behavior with lineup, draft attendance and locked attendance |
| Finance   | Finance module   | Charges, payments, status calculation, financial card                    |

---

## Blocked

| Module | Feature | Reason | Next action |
| ------ | ------- | ------ | ----------- |
| -      | -       | -      | -           |

---

## Later

| Module                 | Feature                          | Notes                                                                   |
| ---------------------- | -------------------------------- | ----------------------------------------------------------------------- |
| Notifications          | Player/member notifications      | Capability postoji, modul nije prioritet sada                           |
| QR Attendance          | QR-based attendance              | Payload standard definisan: `cm1:player:{clubId}:{playerId}[:checksum]` |
| Registration Assistant | Registration workflow/checklists | Premium modul                                                           |
| Eligibility PRO        | Advanced eligibility/compliance  | Premium modul                                                           |
| Reports                | Advanced reports                 | Planirano nakon stabilizacije osnovnih modula                           |
| Website                | Public website polish            | Nastaviti nakon operativnih prioriteta                                  |

---

## Current working focus

Trenutni fokus:

1. Završiti Player Portal activation/password/login flow
2. Nastaviti Finance finalizaciju
3. Ispeglati Attendance/Event lifecycle pravila
4. Ažurirati inventory nakon svake potvrđene cjeline

---

## Update rule

Nakon svake veće dorade upisati kratak update:

```text
Date:
Module:
Feature:
Status:
Confirmed:
Remaining:
Inventory update:
```

Primjer:

```text
Date: 2026-06-05
Module: Photos
Feature: Photo/avatar pipeline
Status: Polished
Confirmed:
- Standardized PhotoAvatar usage
- Old hooks removed
- Cache invalidation works after upload
Remaining:
- None
Inventory update:
- Photos | Photo/avatar pipeline | Polished
```
