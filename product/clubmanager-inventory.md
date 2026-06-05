# ClubManager Product Inventory

Ovaj dokument je radni inventory ClubManager platforme.

Cilj je pratiti stvarno stanje modula i funkcionalnosti kroz:

* backend status
* frontend status
* database status
* testiranje
* ukupni status
* napomene za dalji rad

Inventory se ne potvrđuje iz sjećanja. Svaka stavka se potvrđuje kroz kod, bazu, Swagger/API test, ručni test u aplikaciji ili deploy stanje.

---

## Status legenda

| Status        | Značenje                                                                 |
| ------------- | ------------------------------------------------------------------------ |
| Planned       | Dogovoreno, ali nije implementirano                                      |
| Backend only  | Backend/API postoji, frontend nije završen                               |
| Frontend only | UI postoji, backend nije povezan ili nije gotov                          |
| Implemented   | Kod postoji i osnovno radi                                               |
| Verified      | Funkcionalnost je provjerena kroz aplikaciju                             |
| Polished      | Funkcionalnost je testirana, UX sređen i spremna je za normalnu upotrebu |
| Needs cleanup | Radi, ali ima tehničkog duga, UX problema ili nedovršene logike          |
| Deprecated    | Postojalo je, ali se više ne koristi                                     |

---

## Inventory tabela

| Module        | Feature                          | BE      | FE      | DB      | Tested  | Status          | Notes                                                        |
| ------------- | -------------------------------- | ------- | ------- | ------- | ------- | --------------- | ------------------------------------------------------------ |
| Platform      | Multi-tenant architecture        | Yes     | N/A     | Yes     | Partial | Implemented     | RLS preko `club_id`; dodatno verifikovati policies           |
| Platform      | DEV/STAGE separation             | Yes     | Yes     | Yes     | Partial | Implemented     | Docker/env setup postoji; dalje čuvati strogo razdvajanje    |
| Platform      | Central documentation            | N/A     | N/A     | N/A     | Yes     | Verified        | Centralni docs folder: `/home/kemo/ClubManager/docs`         |
| Auth          | Login/JWT                        | Yes     | Yes     | Yes     | Partial | Implemented     | Provjeriti sve role i token claims                           |
| Auth          | Role-based FE access             | Yes     | Yes     | N/A     | Partial | Implemented     | Tenant/Admin/Player FE zone gate                             |
| Auth          | Capabilities/permissions         | Yes     | Yes     | Yes     | Partial | Needs cleanup   | Uskladiti AppCaps, DB permissions i FE helper                |
| Admin FE      | Club management                  | Yes     | Partial | Yes     | Partial | Implemented     | Osnovna platform admin funkcionalnost                        |
| Admin FE      | Feature toggles                  | Yes     | Partial | Yes     | Partial | Implemented     | Koristi se npr. za Eligibility                               |
| Tenant FE     | Main app shell                   | N/A     | Yes     | N/A     | Partial | Implemented     | Sidebar/light theme standard                                 |
| Players       | Player CRUD                      | Yes     | Yes     | Yes     | Partial | Implemented     | Potrebna formalna verifikacija                               |
| Players       | JMBG validation                  | Yes     | Yes     | N/A     | Partial | Implemented     | Uključuje auto birth date na FE                              |
| Players       | Player detail profile            | Yes     | Yes     | Yes     | Partial | Implemented     | Osnova za digitalni dosje igrača                             |
| Photos        | Photo/avatar pipeline            | Yes     | Yes     | Yes     | Yes     | Polished        | Standardized PersonThumb/usePersonPhoto/mediaStore pipeline  |
| Staff         | Staff CRUD                       | Yes     | Yes     | Yes     | Partial | Implemented     | Country/date fixes urađeni                                   |
| Staff         | Team staff assignment            | Yes     | Yes     | Yes     | Partial | Implemented     | `EndDate` nije obavezan                                      |
| Teams         | Team CRUD                        | Yes     | Yes     | Yes     | Partial | Implemented     | Tenant-scoped                                                |
| Teams         | Team members                     | Yes     | Yes     | Yes     | Partial | Implemented     | Igrači i staff povezani sa ekipama                           |
| Events        | Event CRUD                       | Yes     | Yes     | Yes     | Partial | Implemented     | Treninzi, utakmice, lokacija, vrijeme                        |
| Events        | Event status lifecycle           | Yes     | Yes     | Yes     | Partial | Needs cleanup   | Scheduled/Cancelled/Completed; verifikovati pravila          |
| Events        | Recurring event creation         | Partial | Partial | Yes     | No      | Planned/Partial | Kreiranje više pojedinačnih događaja bez recurring entity-ja |
| Attendance    | Attendance panel                 | Yes     | Yes     | Yes     | Partial | Implemented     | Prisutnost po događaju                                       |
| Attendance    | Attendance lock/unlock           | Partial | Partial | Yes     | No      | Needs cleanup   | Lock samo nakon kraja događaja; locked read-only             |
| Attendance    | Team attendance statistics       | Partial | Partial | Yes     | No      | Needs cleanup   | Statistika samo iz locked attendance događaja                |
| Lineup        | MatchList/Lineup                 | Partial | Partial | Yes     | Partial | Needs cleanup   | UI header uskladiti sa Attendance                            |
| Documents     | Upload/download documents        | Yes     | Yes     | Yes     | Partial | Implemented     | CORE modul                                                   |
| Documents     | Replace/deactivate/delete/purge  | Yes     | Yes     | Yes     | Partial | Implemented     | Potrebna formalna UX provjera                                |
| Documents     | Document title rule              | Yes     | Yes     | Yes     | Partial | Implemented     | Naslov se ne mijenja bez zamjene dokumenta                   |
| Medical       | Medical records                  | Partial | Partial | Partial | No      | Planned/Partial | Strukturisan ljekarski pregled                               |
| Eligibility   | Eligibility Lite                 | Yes     | Partial | Yes     | Partial | Implemented     | Feature gated; registracija + ljekarski                      |
| Eligibility   | Eligibility PRO                  | No      | No      | No      | No      | Planned         | Premium compliance logika                                    |
| Registrations | Basic registration record        | Partial | Partial | Partial | No      | Planned/Partial | CORE ručna registracija                                      |
| Registrations | Registration Assistant           | No      | No      | No      | No      | Planned         | Premium workflow/checkliste                                  |
| Contracts     | Player contracts                 | Partial | Partial | Partial | No      | Planned/Partial | Veza sa compliance/eligibility                               |
| Finance       | Charges/invoices                 | Yes     | Partial | Yes     | Partial | In progress     | Visok prioritet                                              |
| Finance       | Payments                         | Yes     | Partial | Yes     | Partial | In progress     | Backend source of truth                                      |
| Finance       | Financial card                   | Partial | Partial | Yes     | No      | In progress     | Sintetički i analitički prikaz                               |
| Finance       | Bulk invoices                    | Partial | Partial | Yes     | No      | In progress     | Period, amount, teams/players, dry-run                       |
| Player Portal | Portal activation from Tenant FE | Yes     | Yes     | Yes     | Partial | Implemented     | Password flow polish potreban                                |
| Player Portal | Player profile endpoint          | Yes     | Yes     | Yes     | Partial | Implemented     | `/api/player/me`                                             |
| Player Portal | Player events                    | Yes     | Partial | Yes     | Partial | Implemented     | `/api/player/events`                                         |
| Player Portal | Player attendance                | Yes     | Partial | Yes     | Partial | Implemented     | `/api/player/attendance`                                     |
| Player Portal | Player finance                   | Yes     | Partial | Yes     | Partial | Implemented     | `/api/player/finance`                                        |
| Player FE     | Player app shell                 | N/A     | Partial | N/A     | Partial | In progress     | Mobile-first                                                 |
| Player FE     | Events page                      | Yes     | Partial | Yes     | Partial | In progress     | Lista i detalj događaja                                      |
| Player FE     | Attendance page                  | Yes     | Partial | Yes     | Partial | In progress     | Summary + historija                                          |
| Player FE     | Finance page                     | Yes     | Partial | Yes     | Partial | In progress     | Dugovanja/uplate                                             |
| Notifications | Notifications                    | No      | No      | No      | No      | Planned         | Player.ViewNotifications capability postoji                  |
| QR            | QR attendance payload            | No      | No      | No      | No      | Planned         | `cm1:player:{clubId}:{playerId}[:checksum]`                  |
| Reports       | Reports module                   | Partial | Partial | Partial | No      | Planned/Partial | Igrači, staff, finansije, attendance                         |
| Audit         | Audit log                        | Partial | Partial | Yes     | No      | Needs cleanup   | Standardizovati POST/PUT/DELETE audit                        |
| Website       | Public website                   | N/A     | Partial | N/A     | Partial | In progress     | Hero, moduli, CTA, brand                                     |
| DevOps        | Docker deployment                | Yes     | Yes     | Yes     | Partial | Implemented     | DEV/STAGE setup                                              |
| DevOps        | Nginx/reverse proxy              | Yes     | Yes     | N/A     | Partial | Implemented     | Tenant/Admin/Player FE                                       |
| DevOps        | Domain/subdomain plan            | N/A     | N/A     | N/A     | Partial | Planned/Partial | club/admin/player subdomene                                  |

---

## Module notes

### Photos — Photo/avatar pipeline

Current standard:

```text
PersonThumb
usePersonPhoto
mediaStore
secure API endpoint
```

Confirmed:

* centralni standard postoji
* `PersonThumb` je standardna komponenta za prikaz avatara
* `usePersonPhoto` je aktivni standardni hook
* `mediaStore` je centralni cache/load/invalidation helper
* `PhotoUploadModal` je shared upload/delete UI za players/staff
* `PlayerDetailPage` i `StaffDetailPage` su migrirani na `PersonThumb`
* `PlayerEditPage` i `StaffEditPage` direct delete pozivaju `invalidatePersonPhoto`
* `person-photo-updated` event se dispatchuje nakon brisanja fotografije
* legacy `fetchSecurePhoto.ts` je uklonjen
* legacy `photoCache.ts` je uklonjen
* TypeScript check prolazi
* ručni test player/staff list-detail-edit upload/delete je prošao

Status:

```text
Polished
```

Remaining:

* komentarisani legacy photo blokovi mogu se kasnije očistiti ako budu smetali pretrazi

---

## Prva verifikacija

Prva stavka za formalnu verifikaciju:

```text
Photos → Photo/avatar pipeline
```

Cilj verifikacije:

* potvrditi da se koristi standardizovan `PhotoAvatar` pristup
* potvrditi da su nepotrebni hookovi uklonjeni
* potvrditi da upload osvježava listu i detalj
* potvrditi da cache invalidacija radi
* potvrditi da player/staff koriste isti obrazac

Nakon verifikacije ažurirati status:

```text
Verify as Polished → Polished
```

---

## Napomena

Ovaj inventory je živi dokument.

Svaka veća dorada treba završiti kratkim updateom:

```text
Module:
Feature:
Status:
Confirmed:
Remaining:
Inventory update:
```
