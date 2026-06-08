# ClubManager Module Status

Ovaj dokument prati operativni status ClubManager modula.

`module-status.md` je komandni centar projekta: odlučuje šta ide u cleanup, šta ide na testiranje, šta je odloženo i šta se može vratiti u inventory.

Za detaljan inventory koristiti:

```text
docs/product/clubmanager-inventory.md
```

Za tehničku mapu površine koristiti:

```text
docs/product/system-surface-map.md
```

Za definisanu proceduru toka informacija koristiti:

```text
docs/process/inventory-module-status-cleanup-testing-flow.md
```

Za strateški pregled i širi portfolio koristiti OneNote.

---

## Process rule

`module-status.md` je operativni komandni centar ClubManager projekta.

Tok rada:

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

Pravila:

1. `clubmanager-inventory.md` prikazuje stanje proizvoda.
2. `module-status.md` odlučuje šta ide u cleanup, šta ide na testiranje, šta je odloženo i šta je završeno.
3. `cleanup-backlog.md` se puni samo iz `module-status.md`.
4. Developer ne izdaje nalog testeru.
5. Developer u `cleanup-backlog.md` samo označava status rada: `Open`, `In Progress`, `Fixed`.
6. Tester dobija nalog samo iz `module-status.md`, sekcija `Ready for Testing`.
7. Tester rezultat se vraća u `module-status.md`.
8. `clubmanager-inventory.md` se ažurira tek nakon uspješnog testiranja ili jasne product odluke.
9. Chat dogovor nije sam po sebi izvor istine. Mora biti pretočen u odgovarajući dokument.

---

## Release focus

Current production goal:

```text
Release 1 — Tenant Production MVP
```

Primary users:

```text
club secretary
club owner / manager
```

Release 1 cilj:

```text
Stabilna Tenant App aplikacija za svakodnevno vođenje kluba.
```

Release 1 scope:

| Area / Module            | Included in R1     | Notes                                                                             |
| ------------------------ | ------------------ | --------------------------------------------------------------------------------- |
| Tenant App               | Yes                | Glavni fokus                                                                      |
| Dashboard                | Yes                | Basic tenant dashboard                                                            |
| People / Players         | Yes                | Core profile, photo, registrations, medicals, documents, contracts, eligibility   |
| People / Staff           | Yes                | Staff CRUD, photo, validation, team assignments                                   |
| Teams                    | Yes                | Team CRUD, player memberships, staff memberships                                  |
| Events                   | Yes                | Event CRUD, lifecycle, attendance, lineup / MatchList                             |
| Documents Engine         | Yes, limited       | Player documents; Club documents nisu R1 dok se ne riješi schema/service mismatch |
| Finance Fees / Članarine | Yes                | Tenant članarine, ne Platform Billing                                             |
| General Finance          | Yes, basic         | Categories, transactions, storno; advanced reports kasnije                        |
| Tenant users             | Minimal            | Samo ono što treba za rad kluba                                                   |
| Player Portal            | No                 | R1.5 nakon stabilizacije Tenant App-a                                             |
| Admin Platform           | Minimal / Deferred | Samo setup; polish kasnije                                                        |
| Platform Billing         | No                 | R3                                                                                |
| Notifications            | No                 | Planned/later                                                                     |
| Advanced reports         | No                 | Later                                                                             |

---

## Status legenda

| Status             | Značenje                                                |
| ------------------ | ------------------------------------------------------- |
| Done               | Završeno i trenutno nema aktivnog rada                  |
| In Progress        | Aktivno se radi                                         |
| Next               | Sljedeće za rad                                         |
| Needs Verification | Treba provjeriti kroz kod, bazu, Swagger ili aplikaciju |
| Needs Cleanup      | Radi ili djelimično radi, ali ima poznat dug/rizik      |
| Blocked            | Blokirano zbog greške, odluke ili zavisnosti            |
| Ready for Testing  | Module-status je izdao nalog za testiranje              |
| Testing            | Testiranje je u toku                                    |
| Passed             | Test prošao                                             |
| Failed             | Test pao                                                |
| Later              | Planirano za kasnije                                    |
| Deferred           | Svjesno odloženo za kasniji release                     |
| Deprecated         | Više se ne koristi                                      |

---

## Done

| Module        | Feature                      | Status | Notes                                                                                                           |
| ------------- | ---------------------------- | ------ | --------------------------------------------------------------------------------------------------------------- |
| Documentation | Central docs structure       | Done   | Kreiran centralni folder `/home/kemo/ClubManager/docs`                                                          |
| Documentation | OneNote structure            | Done   | OneNote se koristi kao radna tabla / pregled                                                                    |
| Documentation | Central docs Git repo        | Done   | `/home/kemo/ClubManager/docs` je poseban Git repo i centralna dokumentacija projekta                            |
| Documentation | System Surface Map v1        | Done   | API, Tenant FE, Admin FE i Player FE površina su mapirani                                                       |
| Documentation | Inventory workflow procedure | Done   | Definisan tok: inventory → module-status → cleanup/testing → module-status → inventory                          |
| Photos        | Photo/avatar pipeline        | Done   | Standardized `PersonThumb/usePersonPhoto/mediaStore` pipeline; legacy photo cache removed and manually verified |
| Player Portal | Player FE osnovne stranice   | Done   | Profil, događaji, prisustvo i članarine su provjereni nakon player login-a; rollout nije R1 fokus               |

---

## In Progress

| Module        | Feature                             | Status      | Notes                                                                                                  |
| ------------- | ----------------------------------- | ----------- | ------------------------------------------------------------------------------------------------------ |
| Documentation | Product Inventory v2.1              | In Progress | Inventory je ažuriran kroz FE surface audit, Backend/API audit i DB schema audit za sve glavne oblasti |
| Module Status | Command center cleanup              | In Progress | Ovaj dokument se usklađuje s novim procesom i Release 1 fokusom                                        |
| Cleanup       | R1 cleanup preparation              | In Progress | Iz `Needs Cleanup` se izdvajaju samo R1 Tenant MVP stavke za `cleanup-backlog.md`                      |
| Testing       | R1 functional verification planning | In Progress | Test nalog se izdaje iz `Ready for Testing` nakon R1 P0/P1 cleanup pregleda                            |
| Release 1     | Tenant Production MVP               | In Progress | Fokus je stabilna Tenant App aplikacija za sekretara/vlasnika kluba                                    |

---

## Audit coverage completed

| Area              | Domain / Module     | FE surface audit | Backend/API audit | DB schema audit | Manual functional test | Notes                                                                                  |
| ----------------- | ------------------- | ---------------- | ----------------- | --------------- | ---------------------- | -------------------------------------------------------------------------------------- |
| Tenant App        | People              | Done             | Done              | Done            | Partial                | Photo pipeline i Player Portal CORE imaju manual evidence; ostalo čeka functional test |
| Tenant App        | Teams               | Done             | Done              | Done            | No                     | Audit završen; Team CRUD i Staff memberships imaju cleanup stavke                      |
| Tenant App        | Events              | Done             | Done              | Done            | No                     | Audit završen; lifecycle/complete i attendance lock cleanup ostaju                     |
| Tenant App        | Finance             | Done             | Done              | Done            | No                     | Audit završen; status calculation, exports i FE caps cleanup ostaju                    |
| Tenant App        | Documents Engine    | Done             | Done              | Done            | No                     | Audit završen; Club entity/schema i document type mismatch su kritični cleanup         |
| Tenant App        | Club / Operations   | Done             | Done              | Done            | No                     | Audit završen; dashboard/users/settings/shell cleanup ostaje                           |
| Admin App         | Platform Management | Done             | Done              | Done            | Partial                | Clubs core djelimično testiran; dosta admin stranica su placeholderi; R2 fokus         |
| Platform Billing  | Billing             | Done             | Done              | Done            | Partial                | Core billing postoji; full billing polish je R3 fokus                                  |
| Player Portal App | Player Portal       | Done             | Done              | Done            | Partial / Yes for CORE | CORE je ručno potvrđen; rollout i cleanup su R1.5 fokus                                |
| Platform / System | System              | Done             | Done              | Done            | No                     | Auth/settings/lookups/seasons/health/dev/caps audit završen; security cleanup ostaje   |

---

## People audit status

Backend/API audit za `Tenant App → People` je urađen nad stvarnim backend source kodom i DB dumpom.

Audit evidence:

```text
Backend/API source:
 /mnt/c/Users/kemo/source/repos/WEB/ClubManager/src

Database schema dump:
 /home/kemo/ClubManager/docs/database/shema.sql
```

Zaključak:

```text
People blok više nije blokiran nedostatkom backend dokaza.
Većina People funkcionalnosti ima potvrđen BE/API i DB surface.
Status se ne diže na Verified dok ne prođe manual functional test.
```

| Module                   | Current status                   | Verification level                       | Main blockers / notes                                                        |
| ------------------------ | -------------------------------- | ---------------------------------------- | ---------------------------------------------------------------------------- |
| Players                  | Implemented                      | BE/FE/DB confirmed; manual test pending  | JMBG semantic validation, duplicate create flow, birthDate auto-fill cleanup |
| Player photo             | Done / Polished                  | Manual test done                         | Nema kritičnog blockera                                                      |
| Player registrations     | Implemented                      | BE/FE/DB confirmed; manual test pending  | Functional CRUD test required                                                |
| Player medicals          | Implemented                      | BE/FE/DB confirmed; manual test pending  | Functional CRUD test + eligibility impact required                           |
| Player documents         | Implemented                      | BE/FE/DB confirmed; manual test pending  | Full lifecycle test required: upload/replace/delete/restore/purge            |
| Contracts                | Needs Cleanup                    | BE/FE/DB confirmed; manual test pending  | FE raw debug alert; lock/verified behavior test                              |
| Contract verification    | Implemented                      | BE/FE/DB confirmed; manual test pending  | Verified-lock behavior test                                                  |
| Eligibility Lite         | Implemented                      | BE/FE/DB confirmed; manual test pending  | Valid/invalid scenario test                                                  |
| Staff CRUD               | Needs Cleanup                    | FE/DB confirmed; BE partial due to risks | `ManageStaff` mismatch, role/sort filter, nullability mismatch               |
| Staff photo              | Done / Polished                  | Manual photo pipeline test done          | Nema kritičnog blockera                                                      |
| Team staff assignment    | Needs Cleanup                    | BE/FE/DB confirmed with gaps             | Error handling može vratiti 500 umjesto kontrolisanog 400                    |
| Player Portal activation | Needs Cleanup / Deferred to R1.5 | Functionally tested; BE risk found       | Cross-club risk u tenant-side activation service-u; nije R1 fokus            |

Decision notes:

* Backend/API audit je potvrdio stvarne controller/service/entity/schema dokaze za People blok.
* Većina People redova u inventory-ju može biti `Implemented`, ne više `Partial` zbog nedostatka backend evidence-a.
* Player photo i Staff photo mogu ostati `Polished` jer je zajednički photo/avatar pipeline ručno testiran.
* Player Portal CORE je funkcionalno testiran, ali tenant-side activation ostaje `Needs Cleanup` zbog backend cross-club scope rizika.
* Staff modul ostaje `Needs Cleanup` dok se ne riješe permisije, filteri i DB/DTO nullability mismatch.
* Manual functional testing je i dalje potreban prije statusa `Verified`.

---

## Needs Cleanup

Ova sekcija je ulaz za `cleanup-backlog.md`.

Pravilo:

```text
cleanup-backlog.md se puni samo iz ove sekcije, sekcije Blocked ili sekcije Next.
```

R1 cleanup stavke imaju prioritet nad R1.5/R2/R3 stavkama.

| Release             | Priority | Module                | Feature                            | Reason                                                                                                               | Next action                                                                       |
| ------------------- | -------- | --------------------- | ---------------------------------- | -------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| R1 Tenant MVP       | P0       | Staff                 | Permissions                        | Staff write operations use `ManagePlayers` although `ManageStaff` exists                                             | Standardize Staff permissions to `ManageStaff`                                    |
| R1 Tenant MVP       | P0       | Tenant users          | User list permission               | `GET /api/users` nema backend `ManageUsers` capability, iako FE krije page bez `ManageUsers`                         | Dodati backend `ManageUsers` na list endpoint                                     |
| R1 Tenant MVP       | P0       | Documents Engine      | Document type mismatch             | FE koristi `LicenseDocument`, backend/schema očekuju `QualificationDocument`                                         | Uskladiti FE dropdown i backend/schema tipove                                     |
| R1 Tenant MVP       | P0       | Documents Engine      | Club documents support             | Service podržava `Club`, ali DB schema dopušta samo `Player` i `Staff`                                               | Odlučiti: ukloniti Club iz service-a ili proširiti schema constraint              |
| R1 Tenant MVP       | P0       | Events                | Complete endpoint                  | `Complete` endpoint izgleda logički sumnjivo: odbija past-ended događaje i koristi poruku za cancel                  | Provjeriti i ispraviti complete lifecycle pravilo                                 |
| R1 Tenant MVP       | P0       | Events                | Attendance lock on cancelled event | Nema jasnog dokaza da lock attendance blokira cancelled event                                                        | Dodati/provjeriti backend guard za cancelled event                                |
| R1 Tenant MVP       | P0       | Finance Fees          | Invoice status calculation         | `fee_invoices.status` je stored vrijednost, a dio čitanja status računa iz uplata; postoji rizik drift-a             | Standardizovati source of truth za status                                         |
| R1 Tenant MVP       | P0       | Finance Fees          | Payment method                     | FE prikazuje/šalje payment method, ali backend ga ne perzistira jasno pri create                                     | Uskladiti FE polje i backend DTO/model                                            |
| R1 Tenant MVP       | P0       | Team staff assignment | Error handling                     | Some validation failures may throw `ArgumentException` and result in 500                                             | Convert known validation errors to controlled 400 responses                       |
| R1 Tenant MVP       | P0       | Staff memberships     | Error handling                     | `ArgumentException` može rezultirati 500 greškom                                                                     | Pretvoriti poznate validation greške u kontrolisani 400                           |
| R1 Tenant MVP       | P0       | Platform / System     | Default season behavior            | `/api/seasons/default` traži eksplicitni default, dok FE provider fallbacka na latest/empty                          | Uskladiti API i FE očekivanje                                                     |
| R1 Tenant MVP       | P0       | Platform / System     | Dev diagnostics exposure           | Dio `/api/dev/*` endpointa je routable bez eksplicitnog Development-only wrappera                                    | Ograničiti na Development ili jasno dokumentovati zaštitu                         |
| R1 Tenant MVP       | P1       | Staff                 | DB/DTO consistency                 | DB `staff.jmbg` is `NOT NULL`, while entity/DTO allow nullable                                                       | Decide final rule and align DB/entity/DTO/validators                              |
| R1 Tenant MVP       | P1       | Staff                 | List filters                       | `role` and `sort` params are accepted, but service does not visibly apply all of them                                | Apply or remove unsupported filters                                               |
| R1 Tenant MVP       | P1       | Teams                 | Team CRUD validation               | Validators postoje, ali nema jasnog dokaza da se aktivno pozivaju; DB greške mogu izaći kao 500                      | Standardizovati validation/error mapping za create/update                         |
| R1 Tenant MVP       | P1       | Teams                 | Duplicate team name                | DB unique index postoji, ali duplicate name možda izlazi kao DB exception                                            | Mapirati duplicate team name na kontrolisani 409/400                              |
| R1 Tenant MVP       | P1       | Teams                 | Edit route guard                   | `/teams/:id/edit` nije jasno zaštićen sa `RequireCap`                                                                | Dodati FE cap guard za direktan URL                                               |
| R1 Tenant MVP       | P1       | Teams                 | Team list sort                     | FE šalje `sort`, backend ga ignoriše                                                                                 | Ili implementirati sort na BE, ili ukloniti očekivanje u FE                       |
| R1 Tenant MVP       | P1       | Team memberships      | Tenant/RLS consistency             | `team_memberships` nema direktni `club_id`; oslanja se na service checks i FKs                                       | Ostaviti kao poznati rizik ili kasnije razmotriti jačanje schema/RLS modela       |
| R1 Tenant MVP       | P1       | Events                | Event attendance RLS               | `event_attendance` nema direktan RLS dokaz; zaštita se oslanja na event-scoped service checks                        | Ostaviti kao rizik ili kasnije pojačati schema/RLS model                          |
| R1 Tenant MVP       | P1       | General Finance       | Category FE permissions            | `FinanceCategoriesPage` nema vidljiv FE cap guard za write akcije                                                    | Dodati FE capability guard za create/edit/delete                                  |
| R1 Tenant MVP       | P1       | General Finance       | Category code behavior             | FE šalje `code`, backend generiše code iz naziva i ignoriše poslani code                                             | Uskladiti UI sa backend pravilom                                                  |
| R1 Tenant MVP       | P1       | General Finance       | Transaction storno relation        | Storno je označen kroz description marker, nema eksplicitnog FK odnosa original ↔ reversal                           | Razmotriti strukturirani reversal/original transaction link                       |
| R1 Tenant MVP       | P1       | Documents Engine      | Soft delete metadata               | Soft delete ne popunjava `deleted_at`                                                                                | Popuniti `deleted_at` ili ukloniti očekivanje iz lifecycle-a                      |
| R1 Tenant MVP       | P1       | Documents Engine      | Purge consistency                  | DB se označi kao purged prije fizičkog brisanja fajla; moguć DB/filesystem drift                                     | Promijeniti redoslijed ili dodati recovery/consistency handling                   |
| R1 Tenant MVP       | P1       | Documents Engine      | Coarse permissions                 | List/detail/download traže `ManageDocuments`; nema read-only document capability                                     | Odlučiti da li treba `ViewDocuments` ili ostaje samo manage                       |
| R1 Tenant MVP       | P1       | Dashboard             | Backend capability                 | `GET /api/dashboard` nema backend `ReadOnly` capability, iako FE očekuje `ReadOnly`                                  | Dodati backend cap guard ili svjesno dokumentovati dashboard kao TenantOnly read  |
| R1 Tenant MVP       | P1       | Tenant users          | User detail endpoint               | `GET /api/users/{id}` je placeholder, dok `PUT /api/users/{id}` postoji                                              | Implementirati detail ili ukloniti/označiti endpoint kao nedovršen                |
| R1 Tenant MVP       | P1       | Tenant users          | Deactivation safety                | Nema vidljive zaštite od self-deactivation ili deaktivacije zadnjeg manager-like korisnika                           | Dodati sigurnosna pravila ili svjesno dokumentovati odluku                        |
| R1 Tenant MVP       | P1       | Tenant settings       | Capability mismatch                | Settings write/delete koriste `ManageUsers`, iako postoji `ManageSettings`                                           | Prebaciti na `ManageSettings` ili dokumentovati privremenu odluku                 |
| R1 Tenant MVP       | P1       | Club profile          | Summary placeholders               | `/clubs/me/summary` vraća placeholder/hardcoded vrijednosti                                                          | Popuniti stvarne vrijednosti ili ograničiti prikaz                                |
| R1 Tenant MVP       | P1       | Club branding         | Tenant logo management             | Tenant nema upload/delete logo UI/API; admin-side only                                                               | Odlučiti da li klub smije sam upravljati logom                                    |
| R1 Tenant MVP       | P1       | Platform / System     | Password reset FE mismatch         | FE koristi `/auth/password-reset/request`, backend ruta je `/auth/password/reset`                                    | Uskladiti endpoint konstante ili sakriti reset feature iz R1                      |
| R1 Tenant MVP       | P1       | Platform / System     | Health/readiness exposure          | `/healthz` i `/readyz` su anonymous i izlažu env/DB readiness detalje                                                | Definisati šta smije biti javno po okruženju                                      |
| R1 Tenant MVP       | P1       | Platform / System     | Capability constants               | FE cap konstante ne pokrivaju sve BE capove (`ManageSettings`, `ManageStaff`, `ExportFinance`, player caps)          | Uskladiti FE/BE cap source                                                        |
| R1 Tenant MVP       | P2       | Players               | Duplicate create flow              | Routed `PlayerCreatePage` and older modal create flow both exist                                                     | Choose primary flow and clean legacy path                                         |
| R1 Tenant MVP       | P2       | Players               | JMBG auto-fill                     | Auto-fill exists in older flow, not clearly in primary `PlayerForm`                                                  | Move/standardize behavior in primary Player form                                  |
| R1 Tenant MVP       | P2       | Contracts             | FE debug alert                     | Contract form contains raw `alert(JSON.stringify(err.response?.data, null, 2))`                                      | Replace with standard error UI                                                    |
| R1 Tenant MVP       | P2       | Staff detail          | Team assignment placeholder        | Staff detail ima placeholder “assign team”, dok realni flow postoji kroz Team detail                                 | Ukloniti placeholder ili preusmjeriti na Team detail flow                         |
| R1 Tenant MVP       | P2       | Events                | FE lifecycle UX                    | FE koristi `alert`, `confirm`, `window.prompt` za bitne workflowe                                                    | Kasnije zamijeniti standardnim modalima                                           |
| R1 Tenant MVP       | P2       | Events                | Legacy route/file                  | `EventAttendancePage.tsx` postoji, ali nije routan                                                                   | Očistiti ili označiti kao deprecated                                              |
| R1 Tenant MVP       | P2       | Lineup / MatchList    | Export                             | Print postoji, export/download nema evidence                                                                         | Ili dodati export ili ukloniti očekivanje iz dokumentacije                        |
| R1 Tenant MVP       | P2       | Finance Fees          | Direct invoice CRUD                | Bulk create postoji, ali single create UI/API nije aktivno potvrđen; update/delete API nije izložen u UI             | Odlučiti da li direct CRUD treba biti aktivan feature ili samo backend/admin alat |
| R1 Tenant MVP       | P2       | Finance Fees          | Exports                            | CSV export endpointi postoje, ali tenant FE export UI nije pronađen                                                  | Dodati UI ili označiti export kao backend-only                                    |
| R1 Tenant MVP       | P2       | General Finance       | Transaction export                 | Backend export postoji, ali UI nije pronađen                                                                         | Dodati UI ili dokumentovati kao backend-only                                      |
| R1 Tenant MVP       | P2       | General Finance       | Summary/report                     | Nema general finance summary endpointa; FE prikazuje samo lokalne totals za učitane podatke                          | Planirati pravi summary/report endpoint ako treba                                 |
| R1 Tenant MVP       | P2       | Finance FE            | Legacy placeholder                 | `FinanceTransactionsPage.tsx` je placeholder, aktivna ruta koristi `FinTransactionsPage.tsx`                         | Očistiti ili označiti kao deprecated                                              |
| R1 Tenant MVP       | P2       | Finance FE            | Endpoint naming                    | Koegzistiraju `EP.finance`, `EP.fin`, `EP.fees`                                                                      | Kasnije standardizovati naming                                                    |
| R1 Tenant MVP       | P2       | Documents Engine      | Staff documents UI                 | Backend/schema podržavaju Staff dokumente, ali FE surface nije pronađen                                              | Planirati Staff documents tab ili označiti kao backend-only                       |
| R1 Tenant MVP       | P2       | Documents Engine      | Document history visibility        | Replaced/archived dokumenti nisu jasno vidljivi u Player tab default prikazu                                         | Odlučiti da li history treba biti korisnički vidljiv                              |
| R1 Tenant MVP       | P2       | Documents Engine      | Endpoint helpers                   | `api.endpoints.ts` ima samo djelimičan documents helper; aktivni kod koristi raw URL-e                               | Kasnije standardizovati endpoint helper                                           |
| R1 Tenant MVP       | P2       | Shell                 | Duplicate tenant context           | `TenantBoot` i `TenantProvider` dupliraju club summary/context loading                                               | Pojednostaviti tenant context flow                                                |
| R1 Tenant MVP       | P2       | Shell                 | UI-only topbar actions             | Search/help/notifications su vidljivi, ali nisu funkcionalni                                                         | Sakriti, disable-ovati ili implementirati                                         |
| R1 Tenant MVP       | P2       | Logo                  | Content type                       | Logo endpoint može vratiti `image/jpeg` i za druge formate                                                           | Uskladiti content type sa stvarnim fajlom                                         |
| R1 Tenant MVP       | P2       | Platform / System     | JWT generation                     | `JwtTokenService` postoji, ali login koristi lokalni `BuildJwt`                                                      | Centralizovati JWT generation                                                     |
| R1 Tenant MVP       | P2       | Platform / System     | Auth/API duplication               | Tri FE aplikacije dupliraju AuthContext, JWT parsing, API clients i cap helpers                                      | Planirati kasniju standardizaciju shared obrazaca                                 |
| R1.5 Player Portal  | Deferred | Player Portal         | Tenant-side activation             | Backend service queries player by `playerId` without explicit `clubId` filter while using `app.is_admin`             | Add explicit club scoping before Player Portal rollout                            |
| R1.5 Player Portal  | Deferred | Player Portal App     | Password reset route               | Login vodi na `/password-reset`, ali Player FE nema tu rutu/page                                                     | Dodati route/page ili ukloniti link dok nije spremno                              |
| R1.5 Player Portal  | Deferred | Player Portal App     | Notifications                      | Notifications page koristi mock podatke, nema backend/API                                                            | Označiti kao planned/mock ili sakriti iz navigacije                               |
| R1.5 Player Portal  | Deferred | Player Portal App     | Role guards                        | `ProtectedRoute` i `PlayerAuthGuard` imaju duplu i nekonzistentnu role provjeru                                      | Konsolidovati guard logiku                                                        |
| R1.5 Player Portal  | Deferred | Player Portal App     | Profile photo standard             | Profile photo koristi `usePersonPhoto`, ali ne standardni `PersonThumb` wrapper                                      | Prebaciti na standardni `PersonThumb` obrazac                                     |
| R1.5 Player Portal  | Deferred | Player Portal App     | Attendance visibility              | Player attendance ne filtrira vidljivo samo locked attendance                                                        | Donijeti product odluku: player vidi draft ili samo zaključanu prisutnost         |
| R1.5 Player Portal  | Deferred | Player Portal App     | Club name display                  | Sidebar hardcodira `ClubManager`, topbar koristi realni club name                                                    | Uskladiti prikaz naziva kluba                                                     |
| R1.5 Player Portal  | Deferred | Player Portal App     | Legacy files                       | Stari `fetchSecurePhoto`, `photoCache`, duplicate EventsPage, duplicate sidebar i `PersonThumb copy` ostaju u repo-u | Očistiti nakon stabilizacije                                                      |
| R2 Admin Platform   | Deferred | Admin Platform        | Admin club-user permissions        | `AdminClubsUsersController` ima samo `AdminOnly`, bez eksplicitnog admin capability check-a                          | Dodati odgovarajuće `Admin.Users.*` ili `Admin.Clubs.*` capability guards         |
| R2 Admin Platform   | Deferred | Admin Platform        | Feature toggle permissions         | `AdminClubFeaturesController` ima samo `AdminOnly`, bez eksplicitnog feature-toggle capability check-a               | Dodati admin capability guard za feature toggles                                  |
| R2 Admin Platform   | Deferred | Admin Platform        | Admin user create permission       | `POST /api/admin/users` nema vidljiv `Admin.Users.Manage` guard                                                      | Dodati `Admin.Users.Manage` capability                                            |
| R2 Admin Platform   | Deferred | Admin Platform        | Placeholder pages                  | Dashboard, users, roles, audit, settings, seasons su aktivne nav rute, ali placeholderi                              | Sakriti iz navigacije ili jasno označiti kao planned                              |
| R3 Platform Billing | Deferred | Platform Billing      | Payment storno/reversal            | Platform payments imaju edit/delete, ali nemaju storno/reversal model                                                | Odlučiti: uvesti storno model ili svjesno ograničiti billing kao ne-auditni modul |
| R3 Platform Billing | Deferred | Platform Billing      | Billing audit logging              | Billing mutacije nemaju vidljiv audit logging                                                                        | Dodati audit za plan/subscription/invoice/payment mutacije                        |
| R3 Platform Billing | Deferred | Platform Billing      | Invoice status source of truth     | Stored invoice status može driftati od payments/due date/finalizera                                                  | Standardizovati status kao computed ili dosljedno održavan                        |
| R3 Platform Billing | Deferred | Platform Billing      | Standalone payments                | `/payments` ruta je placeholder, nema standalone API                                                                 | Sakriti rutu ili implementirati stvarni modul                                     |
| R3 Platform Billing | Deferred | Platform Billing      | Exports                            | Nema export API/UI za platform billing                                                                               | Planirati ili ostaviti kao Planned                                                |

---

## Blocked

| Module | Feature | Reason | Next action |
| ------ | ------- | ------ | ----------- |
| -      | -       | -      | -           |

---

## Ready for Testing

Tester dobija nalog samo iz ove sekcije.

| Test Package                  | Release            | Area              | Scope                                                                                       | Checklist                                                 | Status   | Notes                                                                                                                  |
| ----------------------------- | ------------------ | ----------------- | ------------------------------------------------------------------------------------------- | --------------------------------------------------------- | -------- | ---------------------------------------------------------------------------------------------------------------------- |
| Tenant MVP Basic Flow         | R1 Tenant MVP      | Tenant App        | Dashboard, People, Teams, Events, Attendance, Documents, Finance Fees, Tenant Users minimal | `docs/testing/checklists/tenant-mvp-basic-checklist.md`   | Draft    | Aktivirati kao `Ready` tek nakon što R1 P0 cleanup bude pregledan i ključne stavke budu `Fixed` ili svjesno prihvaćene |
| Player Portal CORE Regression | R1.5 Player Portal | Player Portal App | Login, dashboard, profile, events, attendance, finance                                      | `docs/testing/checklists/player-portal-core-checklist.md` | Deferred | CORE je ranije ručno potvrđen, ali rollout nije R1 fokus                                                               |

---

## Testing Results

| Date | Test Package | Release | Result | Summary | Follow-up |
| ---- | ------------ | ------- | ------ | ------- | --------- |
| -    | -            | -       | -      | -       | -         |

---

## Needs Verification

| Release             | Module               | Feature                        | What to verify                                                                                                        |
| ------------------- | -------------------- | ------------------------------ | --------------------------------------------------------------------------------------------------------------------- |
| R1 Tenant MVP       | Players              | Player CRUD                    | Create, edit, detail, delete, refresh/reload behavior, duplicate create flow                                          |
| R1 Tenant MVP       | Players              | JMBG validation                | Format, duplicate-in-club, invalid semantic JMBG, birth-date consistency if implemented                               |
| R1 Tenant MVP       | Players              | Birth date auto-fill from JMBG | Primary `PlayerForm` create/edit flow should be checked; auto-fill currently appears only in older modal flow         |
| R1 Tenant MVP       | Player photo         | Photo workflow                 | Already polished, but keep regression test for upload/delete/list/detail/edit display                                 |
| R1 Tenant MVP       | Player Registrations | Registrations                  | CRUD, player detail tab, permissions, duplicate active registration behavior                                          |
| R1 Tenant MVP       | Player Medicals      | Medical records                | CRUD, player detail tab, status/expiry behavior, eligibility impact                                                   |
| R1 Tenant MVP       | Documents            | Documents module               | Upload, download, replace, restore, purge, permissions                                                                |
| R1 Tenant MVP       | Contracts            | Contracts module               | CRUD, player detail tab, verify endpoint, verified-lock behavior                                                      |
| R1 Tenant MVP       | Eligibility          | Eligibility Lite               | Feature flag, endpoint behavior, player detail integration, valid/invalid scenarios                                   |
| R1 Tenant MVP       | Staff                | Staff module                   | Staff CRUD, photo upload/delete, quick create vs edit form, permissions, country/date logic and team staff assignment |
| R1 Tenant MVP       | Team staff           | Assignment flow                | Add/update/end membership, validation errors, controlled 400 instead of 500                                           |
| R1 Tenant MVP       | Teams                | Team module                    | CRUD, team members, staff assignment, tenant scope                                                                    |
| R1 Tenant MVP       | Events               | Lifecycle rules                | Edit/delete behavior with lineup, draft attendance and locked attendance                                              |
| R1 Tenant MVP       | Attendance           | Lock rules                     | Lock only after event end, locked read-only, statistics from locked attendance                                        |
| R1 Tenant MVP       | Lineup               | MatchList / Lineup             | Lineup display, staff candidates, lock/unlock behavior                                                                |
| R1 Tenant MVP       | Finance Fees         | Fee module                     | Charges, payments, status calculation, bulk ops, storno, export                                                       |
| R1 Tenant MVP       | Finance General      | Transactions/categories        | CRUD, storno, export, category behavior                                                                               |
| R1 Tenant MVP       | Users                | Tenant users                   | Create/update/activate/deactivate/set-password, role/cap behavior                                                     |
| R1 Tenant MVP       | Dashboard            | Tenant dashboard               | Cards, counts, API data, permission behavior                                                                          |
| R1 Tenant MVP       | Dev Diagnostics      | Dev/system endpoints           | Confirm dev/debug endpoints are not exposed where they should not be                                                  |
| R1.5 Player Portal  | Player FE            | Cleanup items                  | Notifications mock, missing password-reset route, duplicated role guards, legacy files                                |
| R2 Admin Platform   | Admin Platform       | Admin FE                       | Active clubs/billing screens and placeholder modules                                                                  |
| R3 Platform Billing | Platform Billing     | Billing module                 | Plans, subscriptions, invoices, invoice payments, standalone payments placeholder                                     |

---

## Next

| Priority | Release             | Module                | Feature                                        | Notes                                                                          |
| -------- | ------------------- | --------------------- | ---------------------------------------------- | ------------------------------------------------------------------------------ |
| 1        | R1 Tenant MVP       | Module Status         | Finalize command center document               | Ovaj fajl mora ostati jedini izvor test naloga                                 |
| 2        | R1 Tenant MVP       | Cleanup               | Create cleanup-backlog from module-status      | Izvesti samo R1 P0/P1/P2 + Deferred sekcije                                    |
| 3        | R1 Tenant MVP       | Cleanup               | Fix or explicitly accept R1 P0 items           | Bez ovoga Tenant MVP Basic Flow ostaje Draft                                   |
| 4        | R1 Tenant MVP       | Testing               | Activate Tenant MVP Basic Flow                 | Promijeniti status iz Draft u Ready kada P0 bude riješen ili svjesno prihvaćen |
| 5        | R1 Tenant MVP       | Functional testing    | Run Tenant MVP Basic Flow                      | Tester radi samo po nalogu iz `Ready for Testing`                              |
| 6        | R1 Tenant MVP       | Inventory update      | Update inventory after Passed tests            | `Verified` se upisuje tek nakon test dokaza                                    |
| 7        | R1.5 Player Portal  | Player Portal cleanup | Prepare Player Portal rollout after Tenant MVP | Ne ulazi u R1 osim ako direktno blokira tenant rad                             |
| 8        | R2 Admin Platform   | Admin cleanup         | Admin polish later                             | Minimal admin setup sada, full admin kasnije                                   |
| 9        | R3 Platform Billing | Billing cleanup       | Billing polish later                           | Platform Billing nije R1 fokus                                                 |

---

## Later / Deferred

| Release             | Module                                           | Feature                                      | Notes                                                                   |
| ------------------- | ------------------------------------------------ | -------------------------------------------- | ----------------------------------------------------------------------- |
| R1.5 Player Portal  | Player Portal rollout                            | Player/member portal                         | CORE postoji i testiran je, ali rollout ide nakon stabilne Tenant App   |
| R1.5 Player Portal  | Notifications                                    | Player/member notifications                  | Capability/UI postoji, ali modul nije prioritet sada                    |
| R1.5 Player Portal  | Password reset                                   | Player password reset                        | Backend postoji; FE route missing                                       |
| R2 Admin Platform   | Admin users / roles / audit / settings / seasons | Admin polish                                 | Placeholderi i partial API postoje; nije R1 fokus                       |
| R3 Platform Billing | Platform billing                                 | Plans/subscriptions/invoices/payments polish | Core postoji, ali full billing discipline ide kasnije                   |
| Later               | QR Attendance                                    | QR-based attendance                          | Payload standard definisan: `cm1:player:{clubId}:{playerId}[:checksum]` |
| Later               | Registration Assistant                           | Registration workflow/checklists             | Premium modul                                                           |
| Later               | Eligibility PRO                                  | Advanced eligibility/compliance              | Premium modul                                                           |
| Later               | Reports                                          | Advanced reports                             | Planirano nakon stabilizacije osnovnih modula                           |
| Later               | Website                                          | Public website polish                        | Nastaviti nakon operativnih prioriteta                                  |

---

## Current working focus

Trenutni fokus:

1. Uspostaviti `module-status.md` kao komandni centar.
2. Iz ove sekcije `Needs Cleanup` izvesti `cleanup-backlog.md`.
3. Prvo raditi R1 Tenant MVP P0 cleanup.
4. Nakon P0 cleanup-a odlučiti da li `Tenant MVP Basic Flow` prelazi iz `Draft` u `Ready`.
5. Tester dobija nalog samo iz `Ready for Testing`.
6. Tester rezultat se vraća u `Testing Results`.
7. Nakon uspješnog testiranja ažurirati `clubmanager-inventory.md`.
8. Player Portal, Admin Platform i Platform Billing ostaju deferred dok Tenant App ne bude stabilna.

---

## Update rule

Nakon svake veće provjere, cleanup-a ili testiranja upisati kratak update u `Testing Results`, `Needs Cleanup`, `Ready for Testing` ili `Current working focus`, zavisno od promjene.

Format:

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
- Standardized PersonThumb usage
- usePersonPhoto/mediaStore pipeline verified
- Legacy photo cache removed
- Upload/delete/list/detail tests passed
Remaining:
- Commented legacy blocks can be cleaned later if they make search noisy
Inventory update:
- Photos | Photo/avatar pipeline | Polished
```

Primjer:

```text
Date: 2026-06-06
Module: Tenant App / People
Feature: Backend/API + DB schema audit
Status: Implemented with cleanup required
Confirmed:
- Backend source audited from /mnt/c/Users/kemo/source/repos/WEB/ClubManager/src
- DB schema audited from /home/kemo/ClubManager/docs/database/shema.sql
- Players, registrations, medicals, documents, contracts and eligibility have BE/DB evidence
- Staff and Player Portal activation have backend risks requiring cleanup
Remaining:
- Staff permission and nullability cleanup
- Team staff assignment controlled validation errors
- Manual functional People checklist
Inventory update:
- People inventory rows updated from FE-only evidence to FE + Backend/API + DB schema evidence
```
