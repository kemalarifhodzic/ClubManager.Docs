# ClubManager Cleanup Backlog

Ovaj dokument prati dev cleanup stavke izvedene iz `module-status.md`.

`cleanup-backlog.md` nije izvor istine za testiranje i ne izdaje nalog testeru.

---

## Source rule

Jedini ulaz za ovaj dokument je:

```text
docs/product/module-status.md
```

Pravila:

1. Cleanup stavka ne ulazi direktno iz chata.
2. Cleanup stavka ne ulazi direktno iz `clubmanager-inventory.md`.
3. Cleanup stavka ne ulazi direktno iz Codex audit izvještaja.
4. Ako inventory, audit, chat ili tester otkriju problem, problem prvo mora biti zapisan u `module-status.md`.
5. Tek nakon toga može ući u `cleanup-backlog.md`.
6. Developer koristi ovaj dokument za rad i status fix-a.
7. Developer ne izdaje nalog testeru.
8. Kada je stavka popravljena, developer označava `Status = Fixed`.
9. `module-status.md` nakon toga odlučuje da li stavka ide u `Ready for Testing`.

---

## Process relation

Tok rada:

```text
clubmanager-inventory.md
    ↓
module-status.md
    ↓
cleanup-backlog.md
    ↓
developer fix
    ↓
cleanup-backlog.md = Fixed
    ↓
module-status.md
    ↓
Ready for Testing / Deferred / Needs more work
```

Važno:

```text
Fixed ≠ Verified
```

Značenja:

| Status   | Značenje                                                      |
| -------- | ------------------------------------------------------------- |
| Fixed    | Developer je završio popravku                                 |
| Retested | Tester je potvrdio fix                                        |
| Verified | Feature je potvrđen u inventory-ju nakon uspješnog testiranja |

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

Release 1 fokus:

* Tenant App
* Players
* Staff
* Teams
* Events
* Attendance
* Lineup / MatchList
* Documents
* Registrations
* Medicals
* Contracts
* Eligibility Lite
* Tenant Finance / Članarine
* Dashboard
* Tenant users minimalno

Deferred:

| Release             | Scope                                                  |
| ------------------- | ------------------------------------------------------ |
| R1.5 Player Portal  | Player Portal rollout nakon stabilizacije Tenant App-a |
| R2 Admin Platform   | Admin polish, roles, audit, settings, seasons          |
| R3 Platform Billing | Platform billing polish, storno, audit, exports        |
| Later               | Notifications, advanced reports, standalone payments   |

---

## Status legenda

| Status      | Značenje                                                |
| ----------- | ------------------------------------------------------- |
| Open        | Stavka je otvorena                                      |
| In Progress | Developer aktivno radi                                  |
| Fixed       | Developer završio fix; čeka odluku u `module-status.md` |
| Retested    | Tester potvrdio fix nakon naloga iz `module-status.md`  |
| Deferred    | Svjesno odloženo                                        |
| Won’t fix   | Svjesno se neće popravljati                             |

---

## Priority legenda

| Priority | Značenje                                                                |
| -------- | ----------------------------------------------------------------------- |
| P0       | Blokira Release 1 ili nosi ozbiljan sigurnosni/data rizik za Tenant App |
| P1       | Važno za stabilnost i Verified status Tenant App modula                 |
| P2       | UX cleanup, legacy, placeholder ili standardizacija                     |
| Deferred | Pripada kasnijem release-u                                              |

---

# R1 Tenant MVP — P0 cleanup

Ove stavke treba riješiti ili svjesno prihvatiti prije aktiviranja `Tenant MVP Basic Flow` testa u `module-status.md`.

| ID            | Release       | Priority | Module                | Feature                            | Issue                                                                                                    | Next action                                                          | Source                           | Owner       | Status |
| ------------- | ------------- | -------- | --------------------- | ---------------------------------- | -------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- | -------------------------------- | ----------- | ------ |
| CLN-R1-P0-001 | R1 Tenant MVP | P0       | Staff                 | Permissions                        | Staff write operations use `ManagePlayers` although `ManageStaff` exists                                 | Standardize Staff permissions to `ManageStaff`                       | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P0-002 | R1 Tenant MVP | P0       | Tenant users          | User list permission               | `GET /api/users` nema backend `ManageUsers` capability, iako FE krije page bez `ManageUsers`             | Dodati backend `ManageUsers` na list endpoint                        | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P0-003 | R1 Tenant MVP | P0       | Documents Engine      | Document type mismatch             | FE koristi `LicenseDocument`, backend/schema očekuju `QualificationDocument`                             | Uskladiti FE dropdown i backend/schema tipove                        | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P0-004 | R1 Tenant MVP | P0       | Documents Engine      | Club documents support             | Service podržava `Club`, ali DB schema dopušta samo `Player` i `Staff`                                   | Odlučiti: ukloniti Club iz service-a ili proširiti schema constraint | module-status.md / Needs Cleanup | Dev/Product | Open   |
| CLN-R1-P0-005 | R1 Tenant MVP | P0       | Events                | Complete endpoint                  | `Complete` endpoint izgleda logički sumnjivo: odbija past-ended događaje i koristi poruku za cancel      | Provjeriti i ispraviti complete lifecycle pravilo                    | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P0-006 | R1 Tenant MVP | P0       | Events                | Attendance lock on cancelled event | Nema jasnog dokaza da lock attendance blokira cancelled event                                            | Dodati/provjeriti backend guard za cancelled event                   | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P0-007 | R1 Tenant MVP | P0       | Finance Fees          | Invoice status calculation         | `fee_invoices.status` je stored vrijednost, a dio čitanja status računa iz uplata; postoji rizik drift-a | Standardizovati source of truth za status                            | module-status.md / Needs Cleanup | Dev/Product | Open   |
| CLN-R1-P0-008 | R1 Tenant MVP | P0       | Finance Fees          | Payment method                     | FE prikazuje/šalje payment method, ali backend ga ne perzistira jasno pri create                         | Uskladiti FE polje i backend DTO/model                               | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P0-009 | R1 Tenant MVP | P0       | Team staff assignment | Error handling                     | Some validation failures may throw `ArgumentException` and result in 500                                 | Convert known validation errors to controlled 400 responses          | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P0-010 | R1 Tenant MVP | P0       | Staff memberships     | Error handling                     | `ArgumentException` može rezultirati 500 greškom                                                         | Pretvoriti poznate validation greške u kontrolisani 400              | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P0-011 | R1 Tenant MVP | P0       | Platform / System     | Default season behavior            | `/api/seasons/default` traži eksplicitni default, dok FE provider fallbacka na latest/empty              | Uskladiti API i FE očekivanje                                        | module-status.md / Needs Cleanup | Dev/Product | Open   |
| CLN-R1-P0-012 | R1 Tenant MVP | P0       | Platform / System     | Dev diagnostics exposure           | Dio `/api/dev/*` endpointa je routable bez eksplicitnog Development-only wrappera                        | Ograničiti na Development ili jasno dokumentovati zaštitu            | module-status.md / Needs Cleanup | Dev/Ops     | Open   |

---

# R1 Tenant MVP — P1 cleanup

Ove stavke direktno utiču na stabilnost i `Verified` status Tenant App modula.

| ID            | Release       | Priority | Module            | Feature                     | Issue                                                                                                       | Next action                                                                      | Source                           | Owner       | Status |
| ------------- | ------------- | -------- | ----------------- | --------------------------- | ----------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------- | -------------------------------- | ----------- | ------ |
| CLN-R1-P1-001 | R1 Tenant MVP | P1       | Staff             | DB/DTO consistency          | DB `staff.jmbg` is `NOT NULL`, while entity/DTO allow nullable                                              | Decide final rule and align DB/entity/DTO/validators                             | module-status.md / Needs Cleanup | Dev/Product | Open   |
| CLN-R1-P1-002 | R1 Tenant MVP | P1       | Staff             | List filters                | `role` and `sort` params are accepted, but service does not visibly apply all of them                       | Apply or remove unsupported filters                                              | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P1-003 | R1 Tenant MVP | P1       | Teams             | Team CRUD validation        | Validators postoje, ali nema jasnog dokaza da se aktivno pozivaju; DB greške mogu izaći kao 500             | Standardizovati validation/error mapping za create/update                        | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P1-004 | R1 Tenant MVP | P1       | Teams             | Duplicate team name         | DB unique index postoji, ali duplicate name možda izlazi kao DB exception                                   | Mapirati duplicate team name na kontrolisani 409/400                             | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P1-005 | R1 Tenant MVP | P1       | Teams             | Edit route guard            | `/teams/:id/edit` nije jasno zaštićen sa `RequireCap`                                                       | Dodati FE cap guard za direktan URL                                              | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P1-006 | R1 Tenant MVP | P1       | Teams             | Team list sort              | FE šalje `sort`, backend ga ignoriše                                                                        | Ili implementirati sort na BE, ili ukloniti očekivanje u FE                      | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P1-007 | R1 Tenant MVP | P1       | Team memberships  | Tenant/RLS consistency      | `team_memberships` nema direktni `club_id`; oslanja se na service checks i FKs                              | Ostaviti kao poznati rizik ili kasnije razmotriti jačanje schema/RLS modela      | module-status.md / Needs Cleanup | Dev/DB      | Open   |
| CLN-R1-P1-008 | R1 Tenant MVP | P1       | Events            | Event attendance RLS        | `event_attendance` nema direktan RLS dokaz; zaštita se oslanja na event-scoped service checks               | Ostaviti kao rizik ili kasnije pojačati schema/RLS model                         | module-status.md / Needs Cleanup | Dev/DB      | Open   |
| CLN-R1-P1-009 | R1 Tenant MVP | P1       | General Finance   | Category FE permissions     | `FinanceCategoriesPage` nema vidljiv FE cap guard za write akcije                                           | Dodati FE capability guard za create/edit/delete                                 | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P1-010 | R1 Tenant MVP | P1       | General Finance   | Category code behavior      | FE šalje `code`, backend generiše code iz naziva i ignoriše poslani code                                    | Uskladiti UI sa backend pravilom                                                 | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P1-011 | R1 Tenant MVP | P1       | General Finance   | Transaction storno relation | Storno je označen kroz description marker, nema eksplicitnog FK odnosa original ↔ reversal                  | Razmotriti strukturirani reversal/original transaction link                      | module-status.md / Needs Cleanup | Dev/Product | Open   |
| CLN-R1-P1-012 | R1 Tenant MVP | P1       | Documents Engine  | Soft delete metadata        | Soft delete ne popunjava `deleted_at`                                                                       | Popuniti `deleted_at` ili ukloniti očekivanje iz lifecycle-a                     | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P1-013 | R1 Tenant MVP | P1       | Documents Engine  | Purge consistency           | DB se označi kao purged prije fizičkog brisanja fajla; moguć DB/filesystem drift                            | Promijeniti redoslijed ili dodati recovery/consistency handling                  | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P1-014 | R1 Tenant MVP | P1       | Documents Engine  | Coarse permissions          | List/detail/download traže `ManageDocuments`; nema read-only document capability                            | Odlučiti da li treba `ViewDocuments` ili ostaje samo manage                      | module-status.md / Needs Cleanup | Dev/Product | Open   |
| CLN-R1-P1-015 | R1 Tenant MVP | P1       | Dashboard         | Backend capability          | `GET /api/dashboard` nema backend `ReadOnly` capability, iako FE očekuje `ReadOnly`                         | Dodati backend cap guard ili svjesno dokumentovati dashboard kao TenantOnly read | module-status.md / Needs Cleanup | Dev/Product | Open   |
| CLN-R1-P1-016 | R1 Tenant MVP | P1       | Tenant users      | User detail endpoint        | `GET /api/users/{id}` je placeholder, dok `PUT /api/users/{id}` postoji                                     | Implementirati detail ili ukloniti/označiti endpoint kao nedovršen               | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P1-017 | R1 Tenant MVP | P1       | Tenant users      | Deactivation safety         | Nema vidljive zaštite od self-deactivation ili deaktivacije zadnjeg manager-like korisnika                  | Dodati sigurnosna pravila ili svjesno dokumentovati odluku                       | module-status.md / Needs Cleanup | Dev/Product | Open   |
| CLN-R1-P1-018 | R1 Tenant MVP | P1       | Tenant settings   | Capability mismatch         | Settings write/delete koriste `ManageUsers`, iako postoji `ManageSettings`                                  | Prebaciti na `ManageSettings` ili dokumentovati privremenu odluku                | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P1-019 | R1 Tenant MVP | P1       | Club profile      | Summary placeholders        | `/clubs/me/summary` vraća placeholder/hardcoded vrijednosti                                                 | Popuniti stvarne vrijednosti ili ograničiti prikaz                               | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P1-020 | R1 Tenant MVP | P1       | Club branding     | Tenant logo management      | Tenant nema upload/delete logo UI/API; admin-side only                                                      | Odlučiti da li klub smije sam upravljati logom                                   | module-status.md / Needs Cleanup | Product     | Open   |
| CLN-R1-P1-021 | R1 Tenant MVP | P1       | Platform / System | Password reset FE mismatch  | FE koristi `/auth/password-reset/request`, backend ruta je `/auth/password/reset`                           | Uskladiti endpoint konstante ili sakriti reset feature iz R1                     | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P1-022 | R1 Tenant MVP | P1       | Platform / System | Health/readiness exposure   | `/healthz` i `/readyz` su anonymous i izlažu env/DB readiness detalje                                       | Definisati šta smije biti javno po okruženju                                     | module-status.md / Needs Cleanup | Dev/Ops     | Open   |
| CLN-R1-P1-023 | R1 Tenant MVP | P1       | Platform / System | Capability constants        | FE cap konstante ne pokrivaju sve BE capove (`ManageSettings`, `ManageStaff`, `ExportFinance`, player caps) | Uskladiti FE/BE cap source                                                       | module-status.md / Needs Cleanup | Dev         | Open   |

---

# R1 Tenant MVP — P2 cleanup

Ove stavke su polish, UX, legacy i standardizacija. Ne moraju blokirati prvi test ciklus ako R1 P0/P1 nisu pogođeni.

| ID            | Release       | Priority | Module             | Feature                     | Issue                                                                                                    | Next action                                                                       | Source                           | Owner       | Status |
| ------------- | ------------- | -------- | ------------------ | --------------------------- | -------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- | -------------------------------- | ----------- | ------ |
| CLN-R1-P2-001 | R1 Tenant MVP | P2       | Players            | Duplicate create flow       | Routed `PlayerCreatePage` and older modal create flow both exist                                         | Choose primary flow and clean legacy path                                         | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P2-002 | R1 Tenant MVP | P2       | Players            | JMBG auto-fill              | Auto-fill exists in older flow, not clearly in primary `PlayerForm`                                      | Move/standardize behavior in primary Player form                                  | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P2-003 | R1 Tenant MVP | P2       | Contracts          | FE debug alert              | Contract form contains raw `alert(JSON.stringify(err.response?.data, null, 2))`                          | Replace with standard error UI                                                    | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P2-004 | R1 Tenant MVP | P2       | Staff detail       | Team assignment placeholder | Staff detail ima placeholder “assign team”, dok realni flow postoji kroz Team detail                     | Ukloniti placeholder ili preusmjeriti na Team detail flow                         | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P2-005 | R1 Tenant MVP | P2       | Events             | FE lifecycle UX             | FE koristi `alert`, `confirm`, `window.prompt` za bitne workflowe                                        | Kasnije zamijeniti standardnim modalima                                           | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P2-006 | R1 Tenant MVP | P2       | Events             | Legacy route/file           | `EventAttendancePage.tsx` postoji, ali nije routan                                                       | Očistiti ili označiti kao deprecated                                              | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P2-007 | R1 Tenant MVP | P2       | Lineup / MatchList | Export                      | Print postoji, export/download nema evidence                                                             | Ili dodati export ili ukloniti očekivanje iz dokumentacije                        | module-status.md / Needs Cleanup | Product/Dev | Open   |
| CLN-R1-P2-008 | R1 Tenant MVP | P2       | Finance Fees       | Direct invoice CRUD         | Bulk create postoji, ali single create UI/API nije aktivno potvrđen; update/delete API nije izložen u UI | Odlučiti da li direct CRUD treba biti aktivan feature ili samo backend/admin alat | module-status.md / Needs Cleanup | Product/Dev | Open   |
| CLN-R1-P2-009 | R1 Tenant MVP | P2       | Finance Fees       | Exports                     | CSV export endpointi postoje, ali tenant FE export UI nije pronađen                                      | Dodati UI ili označiti export kao backend-only                                    | module-status.md / Needs Cleanup | Product/Dev | Open   |
| CLN-R1-P2-010 | R1 Tenant MVP | P2       | General Finance    | Transaction export          | Backend export postoji, ali UI nije pronađen                                                             | Dodati UI ili dokumentovati kao backend-only                                      | module-status.md / Needs Cleanup | Product/Dev | Open   |
| CLN-R1-P2-011 | R1 Tenant MVP | P2       | General Finance    | Summary/report              | Nema general finance summary endpointa; FE prikazuje samo lokalne totals za učitane podatke              | Planirati pravi summary/report endpoint ako treba                                 | module-status.md / Needs Cleanup | Product     | Open   |
| CLN-R1-P2-012 | R1 Tenant MVP | P2       | Finance FE         | Legacy placeholder          | `FinanceTransactionsPage.tsx` je placeholder, aktivna ruta koristi `FinTransactionsPage.tsx`             | Očistiti ili označiti kao deprecated                                              | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P2-013 | R1 Tenant MVP | P2       | Finance FE         | Endpoint naming             | Koegzistiraju `EP.finance`, `EP.fin`, `EP.fees`                                                          | Kasnije standardizovati naming                                                    | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P2-014 | R1 Tenant MVP | P2       | Documents Engine   | Staff documents UI          | Backend/schema podržavaju Staff dokumente, ali FE surface nije pronađen                                  | Planirati Staff documents tab ili označiti kao backend-only                       | module-status.md / Needs Cleanup | Product/Dev | Open   |
| CLN-R1-P2-015 | R1 Tenant MVP | P2       | Documents Engine   | Document history visibility | Replaced/archived dokumenti nisu jasno vidljivi u Player tab default prikazu                             | Odlučiti da li history treba biti korisnički vidljiv                              | module-status.md / Needs Cleanup | Product/Dev | Open   |
| CLN-R1-P2-016 | R1 Tenant MVP | P2       | Documents Engine   | Endpoint helpers            | `api.endpoints.ts` ima samo djelimičan documents helper; aktivni kod koristi raw URL-e                   | Kasnije standardizovati endpoint helper                                           | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P2-017 | R1 Tenant MVP | P2       | Shell              | Duplicate tenant context    | `TenantBoot` i `TenantProvider` dupliraju club summary/context loading                                   | Pojednostaviti tenant context flow                                                | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P2-018 | R1 Tenant MVP | P2       | Shell              | UI-only topbar actions      | Search/help/notifications su vidljivi, ali nisu funkcionalni                                             | Sakriti, disable-ovati ili implementirati                                         | module-status.md / Needs Cleanup | Product/Dev | Open   |
| CLN-R1-P2-019 | R1 Tenant MVP | P2       | Logo               | Content type                | Logo endpoint može vratiti `image/jpeg` i za druge formate                                               | Uskladiti content type sa stvarnim fajlom                                         | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P2-020 | R1 Tenant MVP | P2       | Platform / System  | JWT generation              | `JwtTokenService` postoji, ali login koristi lokalni `BuildJwt`                                          | Centralizovati JWT generation                                                     | module-status.md / Needs Cleanup | Dev         | Open   |
| CLN-R1-P2-021 | R1 Tenant MVP | P2       | Platform / System  | Auth/API duplication        | Tri FE aplikacije dupliraju AuthContext, JWT parsing, API clients i cap helpers                          | Planirati kasniju standardizaciju shared obrazaca                                 | module-status.md / Needs Cleanup | Dev         | Open   |

---

# Deferred — R1.5 Player Portal

Ove stavke nisu R1 fokus. Rješavaju se prije aktivnog Player Portal rollout-a.

| ID          | Release            | Priority | Module            | Feature                | Issue                                                                                                                | Next action                                                               | Source                           | Owner       | Status   |
| ----------- | ------------------ | -------- | ----------------- | ---------------------- | -------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- | -------------------------------- | ----------- | -------- |
| CLN-R15-001 | R1.5 Player Portal | Deferred | Player Portal     | Tenant-side activation | Backend service queries player by `playerId` without explicit `clubId` filter while using `app.is_admin`             | Add explicit club scoping before Player Portal rollout                    | module-status.md / Needs Cleanup | Dev         | Deferred |
| CLN-R15-002 | R1.5 Player Portal | Deferred | Player Portal App | Password reset route   | Login vodi na `/password-reset`, ali Player FE nema tu rutu/page                                                     | Dodati route/page ili ukloniti link dok nije spremno                      | module-status.md / Needs Cleanup | Dev         | Deferred |
| CLN-R15-003 | R1.5 Player Portal | Deferred | Player Portal App | Notifications          | Notifications page koristi mock podatke, nema backend/API                                                            | Označiti kao planned/mock ili sakriti iz navigacije                       | module-status.md / Needs Cleanup | Product/Dev | Deferred |
| CLN-R15-004 | R1.5 Player Portal | Deferred | Player Portal App | Role guards            | `ProtectedRoute` i `PlayerAuthGuard` imaju duplu i nekonzistentnu role provjeru                                      | Konsolidovati guard logiku                                                | module-status.md / Needs Cleanup | Dev         | Deferred |
| CLN-R15-005 | R1.5 Player Portal | Deferred | Player Portal App | Profile photo standard | Profile photo koristi `usePersonPhoto`, ali ne standardni `PersonThumb` wrapper                                      | Prebaciti na standardni `PersonThumb` obrazac                             | module-status.md / Needs Cleanup | Dev         | Deferred |
| CLN-R15-006 | R1.5 Player Portal | Deferred | Player Portal App | Attendance visibility  | Player attendance ne filtrira vidljivo samo locked attendance                                                        | Donijeti product odluku: player vidi draft ili samo zaključanu prisutnost | module-status.md / Needs Cleanup | Product/Dev | Deferred |
| CLN-R15-007 | R1.5 Player Portal | Deferred | Player Portal App | Club name display      | Sidebar hardcodira `ClubManager`, topbar koristi realni club name                                                    | Uskladiti prikaz naziva kluba                                             | module-status.md / Needs Cleanup | Dev         | Deferred |
| CLN-R15-008 | R1.5 Player Portal | Deferred | Player Portal App | Legacy files           | Stari `fetchSecurePhoto`, `photoCache`, duplicate EventsPage, duplicate sidebar i `PersonThumb copy` ostaju u repo-u | Očistiti nakon stabilizacije                                              | module-status.md / Needs Cleanup | Dev         | Deferred |

---

# Deferred — R2 Admin Platform

Ove stavke pripadaju kasnijem Admin Platform polish-u.

| ID         | Release           | Priority | Module         | Feature                      | Issue                                                                                                  | Next action                                                               | Source                           | Owner       | Status   |
| ---------- | ----------------- | -------- | -------------- | ---------------------------- | ------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------- | -------------------------------- | ----------- | -------- |
| CLN-R2-001 | R2 Admin Platform | Deferred | Admin Platform | Admin club-user permissions  | `AdminClubsUsersController` ima samo `AdminOnly`, bez eksplicitnog admin capability check-a            | Dodati odgovarajuće `Admin.Users.*` ili `Admin.Clubs.*` capability guards | module-status.md / Needs Cleanup | Dev         | Deferred |
| CLN-R2-002 | R2 Admin Platform | Deferred | Admin Platform | Feature toggle permissions   | `AdminClubFeaturesController` ima samo `AdminOnly`, bez eksplicitnog feature-toggle capability check-a | Dodati admin capability guard za feature toggles                          | module-status.md / Needs Cleanup | Dev         | Deferred |
| CLN-R2-003 | R2 Admin Platform | Deferred | Admin Platform | Admin user create permission | `POST /api/admin/users` nema vidljiv `Admin.Users.Manage` guard                                        | Dodati `Admin.Users.Manage` capability                                    | module-status.md / Needs Cleanup | Dev         | Deferred |
| CLN-R2-004 | R2 Admin Platform | Deferred | Admin Platform | Placeholder pages            | Dashboard, users, roles, audit, settings, seasons su aktivne nav rute, ali placeholderi                | Sakriti iz navigacije ili jasno označiti kao planned                      | module-status.md / Needs Cleanup | Product/Dev | Deferred |

---

# Deferred — R3 Platform Billing

Ove stavke pripadaju kasnijem Platform Billing razvoju.

| ID         | Release             | Priority | Module           | Feature                        | Issue                                                                 | Next action                                                                       | Source                           | Owner       | Status   |
| ---------- | ------------------- | -------- | ---------------- | ------------------------------ | --------------------------------------------------------------------- | --------------------------------------------------------------------------------- | -------------------------------- | ----------- | -------- |
| CLN-R3-001 | R3 Platform Billing | Deferred | Platform Billing | Payment storno/reversal        | Platform payments imaju edit/delete, ali nemaju storno/reversal model | Odlučiti: uvesti storno model ili svjesno ograničiti billing kao ne-auditni modul | module-status.md / Needs Cleanup | Product/Dev | Deferred |
| CLN-R3-002 | R3 Platform Billing | Deferred | Platform Billing | Billing audit logging          | Billing mutacije nemaju vidljiv audit logging                         | Dodati audit za plan/subscription/invoice/payment mutacije                        | module-status.md / Needs Cleanup | Dev         | Deferred |
| CLN-R3-003 | R3 Platform Billing | Deferred | Platform Billing | Invoice status source of truth | Stored invoice status može driftati od payments/due date/finalizera   | Standardizovati status kao computed ili dosljedno održavan                        | module-status.md / Needs Cleanup | Dev/Product | Deferred |
| CLN-R3-004 | R3 Platform Billing | Deferred | Platform Billing | Standalone payments            | `/payments` ruta je placeholder, nema standalone API                  | Sakriti rutu ili implementirati stvarni modul                                     | module-status.md / Needs Cleanup | Product/Dev | Deferred |
| CLN-R3-005 | R3 Platform Billing | Deferred | Platform Billing | Exports                        | Nema export API/UI za platform billing                                | Planirati ili ostaviti kao Planned                                                | module-status.md / Needs Cleanup | Product     | Deferred |

---

# Product decisions

Ove stavke zahtijevaju product odluku prije ili tokom odgovarajuće release faze.

| ID          | Release             | Module             | Decision                                                         | Why it matters                                                | Owner       | Status   |
| ----------- | ------------------- | ------------------ | ---------------------------------------------------------------- | ------------------------------------------------------------- | ----------- | -------- |
| DEC-R1-001  | R1 Tenant MVP       | Documents Engine   | Should Club documents exist in Tenant App?                       | Service and schema disagree; UI does not exist                | Product/Dev | Open     |
| DEC-R1-002  | R1 Tenant MVP       | Documents Engine   | Should replaced document history be visible?                     | Affects digital dossier transparency                          | Product     | Open     |
| DEC-R1-003  | R1 Tenant MVP       | Documents Engine   | Should there be `ViewDocuments` separate from `ManageDocuments`? | Affects read-only roles                                       | Product/Dev | Open     |
| DEC-R1-004  | R1 Tenant MVP       | Club branding      | Can tenant manage own logo?                                      | Currently admin-side only                                     | Product     | Open     |
| DEC-R1-005  | R1 Tenant MVP       | Lineup / MatchList | Is export required or is print enough?                           | Print exists, export does not                                 | Product     | Open     |
| DEC-R1-006  | R1 Tenant MVP       | Finance Fees       | Should direct invoice CRUD exist outside bulk workflow?          | Bulk workflow exists; direct UI not active                    | Product     | Open     |
| DEC-R15-001 | R1.5 Player Portal  | Player Portal App  | Should player see draft attendance or only locked attendance?    | Affects trust and communication with players                  | Product/Dev | Deferred |
| DEC-R3-001  | R3 Platform Billing | Platform Billing   | Is Platform Billing accounting-grade or operational only?        | Determines whether storno/audit is mandatory                  | Product/Dev | Deferred |
| DEC-R3-002  | R3 Platform Billing | Platform Billing   | Should standalone payments exist?                                | Route exists as placeholder, no API                           | Product     | Deferred |
| DEC-R1-007  | R1 Tenant MVP       | Platform / System  | What health/readiness data may be public?                        | `/healthz` and `/readyz` expose environment/readiness details | Product/Ops | Open     |

---

# Current work split

## Dev focus for Release 1

1. Work only from this backlog after items have been accepted through `module-status.md`.
2. Start with R1 P0 items.
3. Mark item as `In Progress` when work starts.
4. Mark item as `Fixed` when fix is completed.
5. Do not issue test instructions directly to tester.
6. Wait for `module-status.md` to move item into `Ready for Testing`.

## Tester focus for Release 1

Tester does not use this file as a test command source.

Tester receives instructions only from:

```text
docs/product/module-status.md → Ready for Testing
```

## Not ready for Release 1 final verification

Do not mark these as `Verified` for Release 1:

* Player Portal rollout
* Admin Platform polish
* Platform Billing
* Notifications
* Password reset
* Club documents, until schema/service decision is made
* Dev diagnostics, until exposure is decided
* Admin user-management edge cases
* Platform/System security edge cases not needed for tenant daily operation

---

# Update rule

When work starts:

```text
Status: Open → In Progress
```

When developer completes fix:

```text
Status: In Progress → Fixed
```

After this, update `module-status.md`.

Only after tester retest issued from `module-status.md`:

```text
Status: Fixed → Retested
```

If intentionally postponed:

```text
Status: Deferred
```

If intentionally not fixed:

```text
Status: Won’t fix
```

Every `Fixed` item should be reflected back in:

```text
docs/product/module-status.md
```

Inventory is updated only after test evidence or explicit product decision.
