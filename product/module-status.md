# ClubManager Module Status

Ovaj dokument prati kratki operativni status ClubManager modula.

Za detaljan inventory koristiti:

```text
docs/product/clubmanager-inventory.md
```

Za tehničku mapu površine koristiti:

```text
docs/product/system-surface-map.md
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
| Needs Cleanup      | Radi ili djelimično radi, ali ima poznat dug/rizik      |
| Blocked            | Blokirano zbog greške, odluke ili zavisnosti            |
| Later              | Planirano za kasnije                                    |
| Deprecated         | Više se ne koristi                                      |

---

## Done

| Module        | Feature                    | Status | Notes                                                                                                           |
| ------------- | -------------------------- | ------ | --------------------------------------------------------------------------------------------------------------- |
| Documentation | Central docs structure     | Done   | Kreiran centralni folder `/home/kemo/ClubManager/docs`                                                          |
| Documentation | OneNote structure          | Done   | OneNote se koristi kao radna tabla / pregled                                                                    |
| Documentation | Central docs Git repo      | Done   | `/home/kemo/ClubManager/docs` je poseban Git repo i centralna dokumentacija projekta                            |
| Documentation | System Surface Map v1      | Done   | API, Tenant FE, Admin FE i Player FE površina su mapirani                                                       |
| Photos        | Photo/avatar pipeline      | Done   | Standardized `PersonThumb/usePersonPhoto/mediaStore` pipeline; legacy photo cache removed and manually verified |
| Player Portal | Player FE osnovne stranice | Done   | Profil, događaji, prisustvo i članarine su provjereni nakon player login-a                                      |

---

## In Progress

| Module        | Feature                          | Status      | Notes                                                                                                                                                               |
| ------------- | -------------------------------- | ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Documentation | Product Inventory v2.1           | In Progress | Glavni inventory je ažuriran kroz FE surface audit, Backend/API audit i DB schema audit za sve glavne oblasti                                                       |
| Verification  | Audit coverage completed         | In Progress | Codex audit završen za People, Teams, Events, Finance, Documents Engine, Club / Operations, Admin Platform, Platform Billing, Player Portal App i Platform / System |
| Cleanup       | Central cleanup backlog          | In Progress | Nalazi iz svih audita su objedinjeni u `Needs Cleanup`; sljedeći korak je prioritetizacija                                                                          |
| Testing       | Functional verification planning | In Progress | Manual functional testovi još nisu sistematski pokrenuti; kreću nakon kritičnog cleanup-a                                                                           |

---

## Audit coverage tracker

| Scope                | FE audit | Backend/API audit | DB schema audit | Manual test | Status                         |
| -------------------- | -------- | ----------------- | --------------- | ----------- | ------------------------------ |
| Tenant App → People  | Done     | Done              | Done            | Partial     | Cleanup + functional test next |
| Tenant App → Teams   | Pending  | Pending           | Pending         | No          | Next audit                     |
| Tenant App → Events  | Pending  | Pending           | Pending         | No          | Pending                        |
| Tenant App → Finance | Pending  | Pending           | Pending         | No          | Pending                        |
| Admin App            | Done     | Pending           | Pending         | Partial     | Pending BE/DB audit            |
| Platform Billing     | Done     | Pending           | Pending         | Partial     | Pending BE/DB audit            |
| Player Portal App    | Done     | Partial           | Partial         | Yes         | Core verified, cleanup pending |

---

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
| Admin App         | Platform Management | Done             | Done              | Done            | Partial                | Clubs core djelimično testiran; dosta admin stranica su placeholderi                   |
| Platform Billing  | Billing             | Done             | Done              | Done            | Partial                | Core billing postoji; storno/audit/status cleanup je važan                             |
| Player Portal App | Player Portal       | Done             | Done              | Done            | Partial / Yes for CORE | CORE je ručno potvrđen; password reset, notifications i guard cleanup ostaju           |
| Platform / System | System              | Done             | Done              | Done            | No                     | Auth/settings/lookups/seasons/health/dev/caps audit završen; security cleanup ostaje   |

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

| Module                   | Current status  | Verification level                       | Main blockers / notes                                                        |
| ------------------------ | --------------- | ---------------------------------------- | ---------------------------------------------------------------------------- |
| Players                  | Implemented     | BE/FE/DB confirmed; manual test pending  | JMBG semantic validation, duplicate create flow, birthDate auto-fill cleanup |
| Player photo             | Done / Polished | Manual test done                         | Nema kritičnog blockera                                                      |
| Player registrations     | Implemented     | BE/FE/DB confirmed; manual test pending  | Functional CRUD test required                                                |
| Player medicals          | Implemented     | BE/FE/DB confirmed; manual test pending  | Functional CRUD test + eligibility impact required                           |
| Player documents         | Implemented     | BE/FE/DB confirmed; manual test pending  | Full lifecycle test required: upload/replace/delete/restore/purge            |
| Contracts                | Needs Cleanup   | BE/FE/DB confirmed; manual test pending  | FE raw debug alert; lock/verified behavior test                              |
| Contract verification    | Implemented     | BE/FE/DB confirmed; manual test pending  | Verified-lock behavior test                                                  |
| Eligibility Lite         | Implemented     | BE/FE/DB confirmed; manual test pending  | Valid/invalid scenario test                                                  |
| Staff CRUD               | Needs Cleanup   | FE/DB confirmed; BE partial due to risks | `ManageStaff` mismatch, role/sort filter, nullability mismatch               |
| Staff photo              | Done / Polished | Manual photo pipeline test done          | Nema kritičnog blockera                                                      |
| Team staff assignment    | Needs Cleanup   | BE/FE/DB confirmed with gaps             | Error handling može vratiti 500 umjesto kontrolisanog 400                    |
| Player Portal activation | Needs Cleanup   | Functionally tested; BE risk found       | Cross-club risk u tenant-side activation service-u                           |

Decision notes:

* Backend/API audit je potvrdio stvarne controller/service/entity/schema dokaze za People blok.
* Većina People redova u inventory-ju može biti `Implemented`, ne više `Partial` zbog nedostatka backend evidence-a.
* Player photo i Staff photo mogu ostati `Polished` jer je zajednički photo/avatar pipeline ručno testiran.
* Player Portal CORE je funkcionalno testiran, ali tenant-side activation ostaje `Needs Cleanup` zbog backend cross-club scope rizika.
* Staff modul ostaje `Needs Cleanup` dok se ne riješe permisije, filteri i DB/DTO nullability mismatch.
* Manual functional testing je i dalje potreban prije statusa `Verified`.

---

## Next

> Napomena: People, Teams, Events, Finance i Documents Engine su već prošli FE surface + Backend/API + DB schema audit. Sljedeći prioriteti su preostali audit blokovi, zatim cleanup, pa manual functional verification.

| Priority | Module                   | Feature                                    | Notes                                                                                           |
| -------- | ------------------------ | ------------------------------------------ | ----------------------------------------------------------------------------------------------- |
| 1        | Club / Users / Dashboard | Codex audit tenant club operations         | Users, dashboard, club profile/branding                                                         |
| 2        | Admin Platform           | Codex audit Admin App                      | Clubs, users, roles, audit, settings, seasons, feature toggles                                  |
| 3        | Platform Billing         | Codex audit Platform Billing               | Plans, subscriptions, invoices, invoice payments, standalone payments, ops/finalize             |
| 4        | Player Portal App        | Codex audit Player Portal cleanup          | Notifications mock, missing password reset route, role guards, profile photo standard           |
| 5        | Platform / System        | Codex audit system modules                 | Auth, account, settings, lookups, photo config, meta/health, dev diagnostics                    |
| 6        | People cleanup           | Critical cleanup before final verification | Player Portal club scoping, Staff permissions, Staff JMBG nullability, Team staff errors        |
| 7        | Teams cleanup            | Cleanup before final verification          | Team CRUD validation/error mapping, edit route guard, staff membership error handling           |
| 8        | Events cleanup           | Cleanup before final verification          | Complete endpoint, cancelled-event attendance lock, prompt/alert UX, EventAttendancePage legacy |
| 9        | Finance cleanup          | Cleanup before final verification          | Invoice status source of truth, exports UI, category caps, payment method mismatch              |
| 10       | Documents cleanup        | Cleanup before final verification          | Club entity schema mismatch, LicenseDocument mismatch, deleted_at, purge consistency            |
| 11       | Functional tests         | People + Teams                             | Run manual tests after audit coverage and critical cleanup                                      |
| 12       | Functional tests         | Events + Finance + Documents               | Run manual tests after their cleanup notes are documented                                       |
| 13       | Functional tests         | Admin + Billing + Player Portal + System   | Run after remaining audits are completed                                                        |

---

## Needs Verification

| Module               | Feature                        | What to verify                                                                                                        |
| -------------------- | ------------------------------ | --------------------------------------------------------------------------------------------------------------------- |
| Players              | Player CRUD                    | Create, edit, detail, delete, refresh/reload behavior, duplicate create flow                                          |
| Players              | JMBG validation                | Format, duplicate-in-club, invalid semantic JMBG, birth-date consistency if implemented                               |
| Players              | Birth date auto-fill from JMBG | Primary `PlayerForm` create/edit flow should be checked; auto-fill currently appears only in older modal flow         |
| Player photo         | Photo workflow                 | Already polished, but keep regression test for upload/delete/list/detail/edit display                                 |
| Player Registrations | Registrations                  | CRUD, player detail tab, permissions, duplicate active registration behavior                                          |
| Player Medicals      | Medical records                | CRUD, player detail tab, status/expiry behavior, eligibility impact                                                   |
| Documents            | Documents module               | Upload, download, replace, restore, purge, permissions                                                                |
| Contracts            | Contracts module               | CRUD, player detail tab, verify endpoint, verified-lock behavior                                                      |
| Eligibility          | Eligibility Lite               | Feature flag, endpoint behavior, player detail integration, valid/invalid scenarios                                   |
| Staff                | Staff module                   | Staff CRUD, photo upload/delete, quick create vs edit form, permissions, country/date logic and team staff assignment |
| Team staff           | Assignment flow                | Add/update/end membership, validation errors, controlled 400 instead of 500                                           |
| Teams                | Team module                    | CRUD, team members, staff assignment, tenant scope                                                                    |
| Events               | Lifecycle rules                | Edit/delete behavior with lineup, draft attendance and locked attendance                                              |
| Attendance           | Lock rules                     | Lock only after event end, locked read-only, statistics from locked attendance                                        |
| Lineup               | MatchList / Lineup             | Lineup display, staff candidates, lock/unlock behavior                                                                |
| Finance Fees         | Fee module                     | Charges, payments, status calculation, bulk ops, storno, export                                                       |
| Finance General      | Transactions/categories        | CRUD, storno, export, category behavior                                                                               |
| Users                | Tenant users                   | Create/update/activate/deactivate/set-password, role/cap behavior                                                     |
| Admin Platform       | Admin FE                       | Active clubs/billing screens and placeholder modules                                                                  |
| Platform Billing     | Billing module                 | Plans, subscriptions, invoices, invoice payments, standalone payments placeholder                                     |
| Player FE            | Cleanup items                  | Notifications mock, missing password-reset route, duplicated role guards, legacy files                                |
| Dev Diagnostics      | Dev/system endpoints           | Confirm dev/debug endpoints are not exposed where they should not be                                                  |

---

## Needs Cleanup

| Module                | Feature                             | Reason                                                                                                                  | Next action                                                                       |
| --------------------- | ----------------------------------- | ----------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| Player Portal         | Tenant-side activation              | Backend service queries player by `playerId` without explicit `clubId` filter while using `app.is_admin`                | Add explicit club scoping and retest cross-club access                            |
| Staff                 | Permissions                         | Staff write operations use `ManagePlayers` although `ManageStaff` exists                                                | Standardize Staff permissions to `ManageStaff`                                    |
| Staff                 | DB/DTO consistency                  | DB `staff.jmbg` is `NOT NULL`, while entity/DTO allow nullable                                                          | Decide final rule and align DB/entity/DTO/validators                              |
| Staff                 | List filters                        | `role` and `sort` params are accepted, but service does not visibly apply all of them                                   | Apply or remove unsupported filters                                               |
| Team staff assignment | Error handling                      | Some validation failures may throw `ArgumentException` and result in 500                                                | Convert known validation errors to controlled 400 responses                       |
| Contracts             | FE debug alert                      | Contract form contains raw `alert(JSON.stringify(err.response?.data, null, 2))`                                         | Replace with standard error UI                                                    |
| Documents Engine      | Entity/schema mismatch              | Service allows `Club` entity, schema appears to allow only `Player` and `Staff`                                         | Align schema/service or document scope limitation                                 |
| Players               | Duplicate create flow               | Routed `PlayerCreatePage` and older modal create flow both exist                                                        | Choose primary flow and clean legacy path                                         |
| Players               | JMBG auto-fill                      | Auto-fill exists in older flow, not clearly in primary `PlayerForm`                                                     | Move/standardize behavior in primary Player form                                  |
| Teams                 | Team CRUD validation                | Validators postoje, ali nema jasnog dokaza da se aktivno pozivaju; DB greške mogu izaći kao 500                         | Standardizovati validation/error mapping za create/update                         |
| Teams                 | Duplicate team name                 | DB unique index postoji, ali duplicate name možda izlazi kao DB exception                                               | Mapirati duplicate team name na kontrolisani 409/400                              |
| Teams                 | Edit route guard                    | `/teams/:id/edit` nije jasno zaštićen sa `RequireCap`                                                                   | Dodati FE cap guard za direktan URL                                               |
| Teams                 | Team list sort                      | FE šalje `sort`, backend ga ignoriše                                                                                    | Ili implementirati sort na BE, ili ukloniti/slomiti očekivanje u FE               |
| Team memberships      | Tenant/RLS consistency              | `team_memberships` nema direktni `club_id`; oslanja se na service checks i FKs                                          | Ostaviti kao poznati rizik ili kasnije razmotriti jačanje schema/RLS modela       |
| Staff memberships     | Error handling                      | `ArgumentException` može rezultirati 500 greškom                                                                        | Pretvoriti poznate validation greške u kontrolisani 400                           |
| Staff memberships     | Duplicate service surface           | Starije staff membership metode postoje i u `TeamService`, iako aktivni controller koristi `TeamStaffMembershipService` | Očistiti ili jasno označiti aktivni service                                       |
| Staff detail          | Team assignment placeholder         | Staff detail ima placeholder “assign team”, dok realni flow postoji kroz Team detail                                    | Ukloniti placeholder ili preusmjeriti na Team detail flow                         |
| Events                | Complete endpoint                   | `Complete` endpoint izgleda logički sumnjivo: odbija past-ended događaje i koristi poruku za cancel                     | Provjeriti i ispraviti complete lifecycle pravilo                                 |
| Events                | Attendance lock on cancelled event  | Nema jasnog dokaza da lock attendance blokira cancelled event                                                           | Dodati/provjeriti backend guard za cancelled event                                |
| Events                | Event attendance RLS                | `event_attendance` nema direktan RLS dokaz; zaštita se oslanja na event-scoped service checks                           | Ostaviti kao rizik ili kasnije pojačati schema/RLS model                          |
| Events                | Player Portal attendance visibility | Player portal attendance ne filtrira vidljivo samo locked attendance, za razliku od team stats                          | Donijeti odluku: player vidi draft ili samo locked attendance                     |
| Events                | FE lifecycle UX                     | FE koristi `alert`, `confirm`, `window.prompt` za bitne workflowe                                                       | Kasnije zamijeniti standardnim modalima                                           |
| Events                | Legacy route/file                   | `EventAttendancePage.tsx` postoji, ali nije routan                                                                      | Očistiti ili označiti kao deprecated                                              |
| Lineup / MatchList    | Export                              | Print postoji, export/download nema evidence                                                                            | Ili dodati export ili ukloniti očekivanje iz dokumentacije                        |
| Finance Fees          | Invoice status calculation          | `fee_invoices.status` je stored vrijednost, a dio čitanja status računa iz uplata; postoji rizik drift-a                | Standardizovati source of truth za status                                         |
| Finance Fees          | Direct invoice CRUD                 | Bulk create postoji, ali single create UI/API nije aktivno potvrđen; update/delete API nije izložen u UI                | Odlučiti da li direct CRUD treba biti aktivan feature ili samo backend/admin alat |
| Finance Fees          | Exports                             | CSV export endpointi postoje, ali tenant FE export UI nije pronađen                                                     | Dodati UI ili označiti export kao backend-only                                    |
| Finance Fees          | Payment method                      | FE prikazuje/šalje payment method, ali backend ga ne perzistira jasno pri create                                        | Uskladiti FE polje i backend DTO/model                                            |
| Finance Fees          | `fee_payments` RLS                  | Nema direktnog RLS dokaza za `fee_payments`; zaštita se oslanja na invoice/service scope                                | Ostaviti kao poznati rizik ili pojačati DB-level zaštitu                          |
| General Finance       | Category FE permissions             | `FinanceCategoriesPage` nema vidljiv FE cap guard za write akcije                                                       | Dodati FE capability guard za create/edit/delete                                  |
| General Finance       | Category code behavior              | FE šalje `code`, backend generiše code iz naziva i ignoriše poslani code                                                | Uskladiti UI sa backend pravilom                                                  |
| General Finance       | Transaction storno relation         | Storno je označen kroz description marker, nema eksplicitnog FK odnosa original ↔ reversal                              | Razmotriti strukturirani reversal/original transaction link                       |
| General Finance       | Transaction export                  | Backend export postoji, ali UI nije pronađen                                                                            | Dodati UI ili dokumentovati kao backend-only                                      |
| General Finance       | Summary/report                      | Nema general finance summary endpointa; FE prikazuje samo lokalne totals za učitane podatke                             | Planirati pravi summary/report endpoint ako treba                                 |
| Finance FE            | Legacy placeholder                  | `FinanceTransactionsPage.tsx` je placeholder, aktivna ruta koristi `FinTransactionsPage.tsx`                            | Očistiti ili označiti kao deprecated                                              |
| Finance FE            | Endpoint naming                     | Koegzistiraju `EP.finance`, `EP.fin`, `EP.fees`                                                                         | Kasnije standardizovati naming                                                    |
| Documents Engine      | Club documents support              | Service podržava `Club`, ali DB schema dopušta samo `Player` i `Staff`                                                  | Odlučiti: ukloniti Club iz service-a ili proširiti schema constraint              |
| Documents Engine      | Document type mismatch              | FE koristi `LicenseDocument`, backend/schema očekuju `QualificationDocument`                                            | Uskladiti FE dropdown i backend/schema tipove                                     |
| Documents Engine      | Soft delete metadata                | Soft delete ne popunjava `deleted_at`                                                                                   | Popuniti `deleted_at` ili ukloniti očekivanje iz lifecycle-a                      |
| Documents Engine      | Purge consistency                   | DB se označi kao purged prije fizičkog brisanja fajla; moguć DB/filesystem drift                                        | Promijeniti redoslijed ili dodati recovery/consistency handling                   |
| Documents Engine      | Coarse permissions                  | List/detail/download traže `ManageDocuments`; nema read-only document capability                                        | Odlučiti da li treba `ViewDocuments` ili ostaje samo manage                       |
| Documents Engine      | Staff documents UI                  | Backend/schema podržavaju Staff dokumente, ali FE surface nije pronađen                                                 | Planirati Staff documents tab ili označiti kao backend-only                       |
| Documents Engine      | Club documents UI                   | Nema FE surface-a za Club dokumente                                                                                     | Ne razvijati dok se ne riješi schema/service mismatch                             |
| Documents Engine      | Document history visibility         | Replaced/archived dokumenti nisu jasno vidljivi u Player tab default prikazu                                            | Odlučiti da li history treba biti korisnički vidljiv                              |
| Documents Engine      | Endpoint helpers                    | `api.endpoints.ts` ima samo djelimičan documents helper; aktivni kod koristi raw URL-e                                  | Kasnije standardizovati endpoint helper                                           |
| Dashboard             | Backend capability                  | `GET /api/dashboard` nema backend `ReadOnly` capability, iako FE očekuje `ReadOnly`                                     | Dodati backend cap guard ili svjesno dokumentovati dashboard kao TenantOnly read  |
| Tenant users          | User list permission                | `GET /api/users` nema backend `ManageUsers` capability, iako FE krije page bez `ManageUsers`                            | Dodati backend `ManageUsers` na list endpoint                                     |
| Tenant users          | User detail endpoint                | `GET /api/users/{id}` je placeholder, dok `PUT /api/users/{id}` postoji                                                 | Implementirati detail ili ukloniti/označiti endpoint kao nedovršen                |
| Tenant users          | Deactivation safety                 | Nema vidljive zaštite od self-deactivation ili deaktivacije zadnjeg manager-like korisnika                              | Dodati sigurnosna pravila ili svjesno dokumentovati odluku                        |
| Tenant settings       | Capability mismatch                 | Settings write/delete koriste `ManageUsers`, iako postoji `ManageSettings`                                              | Prebaciti na `ManageSettings` ili dokumentovati privremenu odluku                 |
| Club profile          | Summary placeholders                | `/clubs/me/summary` vraća placeholder/hardcoded vrijednosti                                                             | Popuniti stvarne vrijednosti ili ograničiti prikaz                                |
| Club branding         | Tenant logo management              | Tenant nema upload/delete logo UI/API; admin-side only                                                                  | Odlučiti da li klub smije sam upravljati logom                                    |
| Shell                 | Duplicate tenant context            | `TenantBoot` i `TenantProvider` dupliraju club summary/context loading                                                  | Pojednostaviti tenant context flow                                                |
| Shell                 | UI-only topbar actions              | Search/help/notifications su vidljivi, ali nisu funkcionalni                                                            | Sakriti, disable-ovati ili implementirati                                         |
| Logo                  | Content type                        | Logo endpoint može vratiti `image/jpeg` i za druge formate                                                              | Uskladiti content type sa stvarnim fajlom                                         |
| Admin Platform        | Admin club-user permissions         | `AdminClubsUsersController` ima samo `AdminOnly`, bez eksplicitnog admin capability check-a                             | Dodati odgovarajuće `Admin.Users.*` ili `Admin.Clubs.*` capability guards         |
| Admin Platform        | Feature toggle permissions          | `AdminClubFeaturesController` ima samo `AdminOnly`, bez eksplicitnog feature-toggle capability check-a                  | Dodati admin capability guard za feature toggles                                  |
| Admin Platform        | Admin user create permission        | `POST /api/admin/users` nema vidljiv `Admin.Users.Manage` guard                                                         | Dodati `Admin.Users.Manage` capability                                            |
| Admin Platform        | Admin set-password scope            | Admin set-password radi po raw user id                                                                                  | Provjeriti/dokumentovati pravilo i dodati safety checks ako treba                 |
| Admin Platform        | Club list filters                   | FE šalje `search/status`, backend očekuje `q/isActive`                                                                  | Uskladiti query parametre                                                         |
| Admin Platform        | Club details billing tabs           | Subscription/invoices tabovi su placeholder alerti                                                                      | Povezati sa Platform Billing ili ukloniti dok ne bude spremno                     |
| Admin Platform        | Club users lifecycle                | Nema potpunih update/activate/deactivate endpointa ili FE flowa                                                         | Odlučiti minimalni admin user lifecycle                                           |
| Admin Platform        | Feature toggle validation           | Backend nema whitelist feature key-eva; FE ima hardcoded listu                                                          | Dodati backend allowlist ili centralni endpoint za feature keys                   |
| Admin Platform        | Placeholder pages                   | Dashboard, users, roles, audit, settings, seasons su aktivne nav rute, ali placeholderi                                 | Sakriti iz navigacije ili jasno označiti kao planned                              |
| Admin Platform        | Logo validation                     | Club logo nema magic-byte validation evidence                                                                           | Uskladiti sa strožim file validation standardom ako treba                         |
| Admin Platform        | Legacy/demo files                   | `index copy.css`, `react.svg`, generic `photoCache.ts` prave surface noise                                              | Očistiti nakon prioriteta                                                         |
| Platform Billing      | Payment storno/reversal             | Platform payments imaju edit/delete, ali nemaju storno/reversal model                                                   | Odlučiti: uvesti storno model ili svjesno ograničiti billing kao ne-auditni modul |
| Platform Billing      | Payment delete                      | Payment delete je destruktivan finansijski potez                                                                        | Zamijeniti storno workflowom ili ograničiti na draft/test režim                   |
| Platform Billing      | Billing audit logging               | Billing mutacije nemaju vidljiv audit logging                                                                           | Dodati audit za plan/subscription/invoice/payment mutacije                        |
| Platform Billing      | Invoice status source of truth      | Stored invoice status može driftati od payments/due date/finalizera                                                     | Standardizovati status kao computed ili dosljedno održavan                        |
| Platform Billing      | Plan billing cycle                  | Yearly behavior nije jasno enforced; subscription renewal koristi mjesečnu logiku                                       | Uskladiti billing cycle sa renewal/invoice pravilima                              |
| Platform Billing      | Subscription scheduled change       | Scheduled change-plan eksplicitno nije implementiran                                                                    | Ili implementirati ili ukloniti iz očekivanja/UI teksta                           |
| Platform Billing      | Subscription past_due               | Status `past_due` postoji, ali nema jasnog transition pravila                                                           | Definisati kada i kako subscription prelazi u `past_due`                          |
| Platform Billing      | Invoice create validation           | Zero-amount invoice izgleda dozvoljen                                                                                   | Odlučiti da li je dozvoljeno; ako nije, validirati `amount > 0`                   |
| Platform Billing      | FE capability guards                | Admin FE billing akcije nisu capability-aware                                                                           | Dodati FE cap guards ili se osloniti isključivo na backend uz bolji UX            |
| Platform Billing      | Client-side filtering               | FE često filtrira lokalno nakon prvog page-a                                                                            | Uskladiti FE filtere sa backend paged/filter endpointima                          |
| Platform Billing      | Standalone payments                 | `/payments` ruta je placeholder, nema standalone API                                                                    | Sakriti rutu ili implementirati stvarni modul                                     |
| Platform Billing      | Exports                             | Nema export API/UI za platform billing                                                                                  | Planirati ili ostaviti kao Planned                                                |
| Player Portal App     | Password reset route                | Login vodi na `/password-reset`, ali Player FE nema tu rutu/page                                                        | Dodati route/page ili ukloniti link dok nije spremno                              |
| Player Portal App     | Notifications                       | Notifications page koristi mock podatke, nema backend/API                                                               | Označiti kao planned/mock ili sakriti iz navigacije                               |
| Player Portal App     | Role guards                         | `ProtectedRoute` i `PlayerAuthGuard` imaju duplu i nekonzistentnu role provjeru                                         | Konsolidovati guard logiku                                                        |
| Player Portal App     | Profile photo standard              | Profile photo koristi `usePersonPhoto`, ali ne standardni `PersonThumb` wrapper                                         | Prebaciti na standardni `PersonThumb` obrazac                                     |
| Player Portal App     | Attendance visibility               | Player attendance ne filtrira vidljivo samo locked attendance                                                           | Donijeti product odluku: player vidi draft ili samo zaključanu prisutnost         |
| Player Portal App     | Club name display                   | Sidebar hardcodira `ClubManager`, topbar koristi realni club name                                                       | Uskladiti prikaz naziva kluba                                                     |
| Player Portal App     | Legacy files                        | Stari `fetchSecurePhoto`, `photoCache`, duplicate EventsPage, duplicate sidebar i `PersonThumb copy` ostaju u repo-u    | Očistiti nakon stabilizacije                                                      |
| Player Portal App     | Broad endpoint catalog              | `api.endpoints.ts` sadrži široke tenant/admin endpoint-e koji se ne koriste u player-fe                                 | Očistiti ili ograničiti na player-fe surface                                      |
| Platform / System     | Password reset FE mismatch          | FE koristi `/auth/password-reset/request`, backend ruta je `/auth/password/reset`                                       | Uskladiti endpoint konstante i testirati reset flow                               |
| Platform / System     | Player password reset route         | Player FE link vodi na `/password-reset`, ali ruta/page ne postoji                                                      | Dodati rutu/page ili ukloniti link                                                |
| Platform / System     | Dev diagnostics exposure            | Dio `/api/dev/*` endpointa je routable bez eksplicitnog Development-only wrappera                                       | Ograničiti na Development ili jasno dokumentovati zaštitu                         |
| Platform / System     | Admin impersonation                 | `X-Impersonate-Club` ne traži vidljivo `Admin.Ops.Impersonate`                                                          | Dodati capability check za impersonation                                          |
| Platform / System     | Tenant settings capability          | Tenant settings write/delete koriste `ManageUsers`, iako postoji `ManageSettings`                                       | Prebaciti na `ManageSettings`                                                     |
| Platform / System     | Health/readiness exposure           | `/healthz` i `/readyz` su anonymous i izlažu env/DB readiness detalje                                                   | Definisati šta smije biti javno po okruženju                                      |
| Platform / System     | Default season behavior             | `/api/seasons/default` traži eksplicitni default, dok FE provider fallbacka na latest/empty                             | Uskladiti API i FE očekivanje                                                     |
| Platform / System     | JWT generation                      | `JwtTokenService` postoji, ali login koristi lokalni `BuildJwt`                                                         | Centralizovati JWT generation                                                     |
| Platform / System     | Capability constants                | FE cap konstante ne pokrivaju sve BE capove (`ManageSettings`, `ManageStaff`, `ExportFinance`, player caps)             | Uskladiti FE/BE cap source                                                        |
| Platform / System     | Player auth guards                  | Player FE ima duple i nekonzistentne role guardove                                                                      | Konsolidovati guard logiku                                                        |
| Platform / System     | Auth/API duplication                | Tri FE aplikacije dupliraju AuthContext, JWT parsing, API clients i cap helpers                                         | Planirati kasniju standardizaciju shared obrazaca                                 |
| Platform / System     | Admin FE API clients                | Admin FE ima `api/index.ts` i legacy-looking `lib/axios.ts`                                                             | Očistiti dupli API client                                                         |

---

## Blocked

| Module | Feature | Reason | Next action |
| ------ | ------- | ------ | ----------- |
| -      | -       | -      | -           |

---

## Later

| Module                 | Feature                          | Notes                                                                   |
| ---------------------- | -------------------------------- | ----------------------------------------------------------------------- |
| Notifications          | Player/member notifications      | Capability/UI postoji, ali modul nije prioritet sada                    |
| QR Attendance          | QR-based attendance              | Payload standard definisan: `cm1:player:{clubId}:{playerId}[:checksum]` |
| Registration Assistant | Registration workflow/checklists | Premium modul                                                           |
| Eligibility PRO        | Advanced eligibility/compliance  | Premium modul                                                           |
| Reports                | Advanced reports                 | Planirano nakon stabilizacije osnovnih modula                           |
| Website                | Public website polish            | Nastaviti nakon operativnih prioriteta                                  |

---

## Current working focus

Trenutni fokus:

1. Commitati ažurirani `clubmanager-inventory.md`
2. Ažurirati `module-status.md` sa People backend/API audit nalazima
3. Riješiti najkritičnije People cleanup stavke:

   * Player Portal activation club scoping
   * Staff permission mismatch
   * Staff JMBG nullability mismatch
   * Team staff controlled validation errors
   * Contract FE raw debug alert
4. Nakon cleanup-a pokrenuti People functional checklist
5. Nakon svake provjere ažurirati:

   * `clubmanager-inventory.md`
   * `module-status.md`
   * po potrebi `system-surface-map.md`
   * po potrebi `docs/testing/test-plan.md`

---

## Update rule

Nakon svake veće provjere ili dorade upisati kratak update:

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
- Player Portal activation explicit club scoping
- Staff permission and nullability cleanup
- Team staff assignment controlled validation errors
- Manual functional People checklist
Inventory update:
- People inventory rows updated from FE-only evidence to FE + Backend/API + DB schema evidence
```
