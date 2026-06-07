# ClubManager Cleanup Backlog

Ovaj dokument prati prioritetne cleanup stavke nakon završenog FE surface, Backend/API i DB schema audita.

Cilj ovog dokumenta je da razdvoji:

```text
šta blokira produkcijsku Tenant App verziju
šta može čekati Player Portal fazu
šta pripada kasnijem Admin Platform / Platform Billing razvoju
```

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
Stabilna Tenant App aplikacija za svakodnevno vođenje kluba:
- players
- staff
- teams
- events
- attendance
- lineup / matchlist
- documents
- registrations
- medicals
- contracts
- eligibility lite
- tenant fees / članarine
- tenant users minimalno
- dashboard minimalno
```

Deferred for later releases:

```text
Release 1.5 — Player Portal rollout
Release 2 — Admin Platform polish
Release 3 — Platform Billing
Later — Notifications, advanced reporting, standalone payments, advanced admin tools
```

Važno:

```text
Player Portal CORE postoji i već ima manual evidence, ali nije fokus prvog produkcijskog puštanja.
Prvo stabilizujemo Tenant App i svakodnevni rad sekretara/vlasnika kluba.
```

---

## Status legenda

| Status      | Značenje                      |
| ----------- | ----------------------------- |
| Open        | Stavka je otvorena            |
| In Progress | Aktivno se radi               |
| Fixed       | Popravljeno, čeka retest      |
| Retested    | Ponovno testirano i potvrđeno |
| Deferred    | Svjesno odloženo              |
| Won’t fix   | Svjesno se neće popravljati   |

---

## Release oznake

| Release             | Značenje                                                                             |
| ------------------- | ------------------------------------------------------------------------------------ |
| R1 Tenant MVP       | Mora biti riješeno ili svjesno prihvaćeno prije prve produkcijske Tenant App verzije |
| R1.5 Player Portal  | Rješava se prije aktivnog rollout-a Player Portala                                   |
| R2 Admin Platform   | Rješava se u fazi ozbiljnog Admin App razvoja                                        |
| R3 Platform Billing | Rješava se u fazi Platform Billing razvoja                                           |
| Later               | Kasnije poboljšanje, cleanup ili product odluka                                      |

---

## Prioriteti

| Priority | Značenje                                                                |
| -------- | ----------------------------------------------------------------------- |
| P0       | Blokira Release 1 ili nosi ozbiljan sigurnosni/data rizik za Tenant App |
| P1       | Važno za stabilnost i Verified status Tenant App modula                 |
| P2       | UX cleanup, legacy, placeholder ili standardizacija za Tenant App       |
| Deferred | Važno, ali pripada kasnijoj release fazi                                |

---

# P0 — Release 1 critical cleanup

Ove stavke treba riješiti prije ozbiljnog functional verification ciklusa za Tenant App.

| ID         | Release       | Area                  | Module                             | Issue                                                                                 | Reason                                                                                        | Next action                                                       | Owner       | Status |
| ---------- | ------------- | --------------------- | ---------------------------------- | ------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- | ----------------------------------------------------------------- | ----------- | ------ |
| CLN-P0-001 | R1 Tenant MVP | Tenant App            | Tenant users                       | `GET /api/users` lacks backend `ManageUsers` capability                               | FE hides users page, but backend endpoint can be called directly by tenant-authenticated user | Add backend `ManageUsers` guard on list endpoint                  | Dev         | Open   |
| CLN-P0-002 | R1 Tenant MVP | Staff                 | Permissions                        | Staff write operations use `ManagePlayers` although `ManageStaff` exists              | Capability mismatch in active Tenant App module                                               | Standardize Staff permissions to `ManageStaff`                    | Dev         | Open   |
| CLN-P0-003 | R1 Tenant MVP | Tenant settings       | Capability mismatch                | Settings write/delete use `ManageUsers`, although `ManageSettings` exists             | Capability mismatch in system-level tenant settings                                           | Switch to `ManageSettings` or explicitly document temporary rule  | Dev         | Open   |
| CLN-P0-004 | R1 Tenant MVP | Documents Engine      | Document type mismatch             | FE uses `LicenseDocument`, backend/schema expect `QualificationDocument`              | Upload can fail in active Player Documents flow                                               | Align FE dropdown and backend/schema document types               | Dev         | Open   |
| CLN-P0-005 | R1 Tenant MVP | Documents Engine      | Club documents support             | Service supports `Club`, but DB schema allows only `Player` and `Staff`               | Service/schema mismatch can create failed persistence path                                    | Remove Club support from active scope or extend schema constraint | Dev/Product | Open   |
| CLN-P0-006 | R1 Tenant MVP | Events                | Complete endpoint                  | `Complete` endpoint appears logically suspicious and uses cancel-like message         | Event lifecycle rule can behave incorrectly                                                   | Review and fix complete lifecycle rule                            | Dev         | Open   |
| CLN-P0-007 | R1 Tenant MVP | Events                | Attendance lock on cancelled event | No clear evidence that cancelled events block attendance lock                         | Invalid workflow risk in active attendance module                                             | Add/verify backend guard for cancelled events                     | Dev         | Open   |
| CLN-P0-008 | R1 Tenant MVP | Finance Fees          | Invoice status calculation         | `fee_invoices.status` is stored, while some reads calculate status from payments      | Status drift risk in active tenant finance module                                             | Standardize source of truth for fee invoice status                | Dev/Product | Open   |
| CLN-P0-009 | R1 Tenant MVP | Finance Fees          | Payment method                     | FE shows/sends payment method, but backend persistence is unclear                     | UI/data mismatch in active payment flow                                                       | Align FE field with backend DTO/model                             | Dev         | Open   |
| CLN-P0-010 | R1 Tenant MVP | Team staff assignment | Error handling                     | Validation failures may throw `ArgumentException` and result in 500                   | User should receive controlled validation message                                             | Convert known validation errors to controlled 400 responses       | Dev         | Open   |
| CLN-P0-011 | R1 Tenant MVP | Staff memberships     | Error handling                     | `ArgumentException` can result in 500                                                 | Same practical issue in team/staff workflow                                                   | Convert known validation errors to controlled 400                 | Dev         | Open   |
| CLN-P0-012 | R1 Tenant MVP | Platform / System     | Default season behavior            | `/api/seasons/default` requires explicit default, while FE fallback uses latest/empty | Season behavior can differ by access path                                                     | Align API and FE expectation                                      | Dev/Product | Open   |
| CLN-P0-013 | R1 Tenant MVP | Platform / System     | Dev diagnostics exposure           | Some `/api/dev/*` endpoints are routable without explicit Development-only wrapper    | Potential security/environment exposure before production                                     | Restrict to Development or strongly protect/document              | Dev/Ops     | Open   |

---

# P1 — Release 1 important cleanup

Ove stavke ne moraju sve blokirati početak testiranja, ali blokiraju čist `Verified` status ako ostanu neriješene.

| ID         | Release       | Area              | Module                      | Issue                                                                                  | Reason                                      | Next action                                                    | Owner       | Status |
| ---------- | ------------- | ----------------- | --------------------------- | -------------------------------------------------------------------------------------- | ------------------------------------------- | -------------------------------------------------------------- | ----------- | ------ |
| CLN-P1-001 | R1 Tenant MVP | Staff             | DB/DTO consistency          | DB `staff.jmbg` is `NOT NULL`, while entity/DTO allow nullable                         | Data rule mismatch                          | Decide final rule and align DB/entity/DTO/validators           | Dev/Product | Open   |
| CLN-P1-002 | R1 Tenant MVP | Staff             | List filters                | `role` and `sort` params are accepted, but service does not visibly apply all of them  | UI/API expectation mismatch                 | Apply filters or remove unsupported inputs                     | Dev         | Open   |
| CLN-P1-003 | R1 Tenant MVP | Teams             | Team CRUD validation        | Validators exist, but active invocation is unclear; DB errors may become 500           | Bad validation UX and unstable API behavior | Standardize validation/error mapping for create/update         | Dev         | Open   |
| CLN-P1-004 | R1 Tenant MVP | Teams             | Duplicate team name         | DB unique index exists, but duplicate may surface as DB exception                      | Should be controlled conflict message       | Map duplicate team name to controlled 409/400                  | Dev         | Open   |
| CLN-P1-005 | R1 Tenant MVP | Teams             | Team list sort              | FE sends `sort`, backend ignores it                                                    | User expectation mismatch                   | Implement sort on BE or remove sort expectation from FE        | Dev         | Open   |
| CLN-P1-006 | R1 Tenant MVP | Team memberships  | Tenant/RLS consistency      | `team_memberships` lacks direct `club_id`; relies on service checks and FKs            | DB-level defense is weaker                  | Keep as known risk or later strengthen schema/RLS              | Dev/DB      | Open   |
| CLN-P1-007 | R1 Tenant MVP | Events            | Event attendance RLS        | `event_attendance` lacks direct RLS evidence; service scope is main protection         | DB-level defense weaker than events table   | Keep as known risk or later strengthen schema/RLS              | Dev/DB      | Open   |
| CLN-P1-008 | R1 Tenant MVP | General Finance   | Category FE permissions     | `FinanceCategoriesPage` lacks visible FE cap guard for write actions                   | Permission UX mismatch                      | Add FE capability guards for create/edit/delete                | Dev         | Open   |
| CLN-P1-009 | R1 Tenant MVP | General Finance   | Category code behavior      | FE sends `code`, backend generates code from name and ignores sent code                | UI/backend rule mismatch                    | Align UI with backend behavior                                 | Dev         | Open   |
| CLN-P1-010 | R1 Tenant MVP | General Finance   | Transaction storno relation | Storno is represented by description marker, no explicit original ↔ reversal FK        | Weak financial traceability                 | Consider structured reversal/original transaction link         | Dev/Product | Open   |
| CLN-P1-011 | R1 Tenant MVP | Documents Engine  | Soft delete metadata        | Soft delete does not populate `deleted_at`                                             | Lifecycle metadata gap                      | Populate `deleted_at` or remove expectation                    | Dev         | Open   |
| CLN-P1-012 | R1 Tenant MVP | Documents Engine  | Purge consistency           | DB is marked purged before physical file delete                                        | DB/filesystem drift risk                    | Change operation order or add recovery/consistency handling    | Dev         | Open   |
| CLN-P1-013 | R1 Tenant MVP | Documents Engine  | Coarse permissions          | List/detail/download require `ManageDocuments`; no read-only document capability       | Read permission may be too strict/coarse    | Decide whether `ViewDocuments` is needed                       | Product/Dev | Open   |
| CLN-P1-014 | R1 Tenant MVP | Dashboard         | Backend capability          | `GET /api/dashboard` lacks backend `ReadOnly` capability, while FE expects it          | FE/backend permission mismatch              | Add backend cap guard or document dashboard as TenantOnly read | Dev/Product | Open   |
| CLN-P1-015 | R1 Tenant MVP | Tenant users      | User detail endpoint        | `GET /api/users/{id}` is placeholder, while `PUT /api/users/{id}` exists               | Incomplete API surface                      | Implement detail or remove/mark endpoint incomplete            | Dev         | Open   |
| CLN-P1-016 | R1 Tenant MVP | Tenant users      | Deactivation safety         | No visible protection against self-deactivation or deactivating last manager-like user | Account lockout risk                        | Add safety rule or document decision                           | Dev/Product | Open   |
| CLN-P1-017 | R1 Tenant MVP | Club profile      | Summary placeholders        | `/clubs/me/summary` returns placeholder/hardcoded values                               | Shell/profile data may be misleading        | Fill real values or restrict display                           | Dev         | Open   |
| CLN-P1-018 | R1 Tenant MVP | Club branding     | Tenant logo management      | Tenant has no upload/delete logo UI/API; admin-side only                               | Product decision unclear                    | Decide whether club can manage its own logo                    | Product     | Open   |
| CLN-P1-019 | R1 Tenant MVP | Platform / System | Password reset FE mismatch  | FE uses `/auth/password-reset/request`, backend route is `/auth/password/reset`        | Reset flow broken if enabled                | Align endpoint constants or hide reset feature from R1         | Dev         | Open   |
| CLN-P1-020 | R1 Tenant MVP | Platform / System | Health/readiness exposure   | `/healthz` and `/readyz` are anonymous and expose env/DB readiness details             | Environment leakage risk                    | Define what is public per environment                          | Dev/Ops     | Open   |
| CLN-P1-021 | R1 Tenant MVP | Platform / System | Capability constants        | FE cap constants do not cover all BE caps                                              | Capability drift                            | Align FE/BE capability source                                  | Dev         | Open   |

---

# P2 — Release 1 polish / cleanup

Ove stavke ne blokiraju prvi test ciklus, ali ih treba držati vidljivim.

| ID         | Release       | Area               | Module                      | Issue                                                                                     | Reason                             | Next action                                                   | Owner       | Status |
| ---------- | ------------- | ------------------ | --------------------------- | ----------------------------------------------------------------------------------------- | ---------------------------------- | ------------------------------------------------------------- | ----------- | ------ |
| CLN-P2-001 | R1 Tenant MVP | Players            | Duplicate create flow       | Routed `PlayerCreatePage` and old modal create flow both exist                            | UX/maintenance confusion           | Choose primary flow and clean legacy path                     | Dev         | Open   |
| CLN-P2-002 | R1 Tenant MVP | Players            | JMBG auto-fill              | Auto-fill exists in older flow, not clearly in primary `PlayerForm`                       | Inconsistent UX                    | Move/standardize behavior in primary PlayerForm               | Dev         | Open   |
| CLN-P2-003 | R1 Tenant MVP | Contracts          | FE debug alert              | Contract form contains raw debug `alert(JSON.stringify(...))`                             | Unpolished error UX                | Replace with standard error UI                                | Dev         | Open   |
| CLN-P2-004 | R1 Tenant MVP | Teams              | Edit route guard            | `/teams/:id/edit` is not clearly protected with `RequireCap`                              | Direct URL UX/security consistency | Add FE cap guard for direct URL                               | Dev         | Open   |
| CLN-P2-005 | R1 Tenant MVP | Staff detail       | Team assignment placeholder | Staff detail has placeholder “assign team”, real flow is in Team detail                   | Confusing UI                       | Remove placeholder or redirect to Team detail flow            | Dev         | Open   |
| CLN-P2-006 | R1 Tenant MVP | Events             | FE lifecycle UX             | FE uses `alert`, `confirm`, `window.prompt` for important workflows                       | Weak UX                            | Replace with standard modals later                            | Dev         | Open   |
| CLN-P2-007 | R1 Tenant MVP | Events             | Legacy route/file           | `EventAttendancePage.tsx` exists but is not routed                                        | Legacy noise                       | Clean or mark deprecated                                      | Dev         | Open   |
| CLN-P2-008 | R1 Tenant MVP | Lineup / MatchList | Export                      | Print exists, export/download has no evidence                                             | Feature expectation mismatch       | Add export or remove expectation from documentation           | Product/Dev | Open   |
| CLN-P2-009 | R1 Tenant MVP | Finance Fees       | Direct invoice CRUD         | Bulk create exists, single create UI/API not active; update/delete not exposed in UI      | Scope unclear                      | Decide if direct CRUD is active feature or backend/admin tool | Product/Dev | Open   |
| CLN-P2-010 | R1 Tenant MVP | Finance Fees       | Exports                     | CSV export endpoints exist, but tenant FE export UI not found                             | Backend-only feature               | Add UI or mark as backend-only                                | Product/Dev | Open   |
| CLN-P2-011 | R1 Tenant MVP | General Finance    | Transaction export          | Backend export exists, but UI not found                                                   | Backend-only feature               | Add UI or document as backend-only                            | Product/Dev | Open   |
| CLN-P2-012 | R1 Tenant MVP | General Finance    | Summary/report              | No general finance summary endpoint; FE shows local totals only                           | Reporting gap                      | Plan real summary/report endpoint if needed                   | Product     | Open   |
| CLN-P2-013 | R1 Tenant MVP | Finance FE         | Legacy placeholder          | `FinanceTransactionsPage.tsx` is placeholder; active route uses `FinTransactionsPage.tsx` | Surface noise                      | Clean or mark deprecated                                      | Dev         | Open   |
| CLN-P2-014 | R1 Tenant MVP | Finance FE         | Endpoint naming             | `EP.finance`, `EP.fin`, and `EP.fees` coexist                                             | Naming inconsistency               | Standardize later                                             | Dev         | Open   |
| CLN-P2-015 | R1 Tenant MVP | Documents Engine   | Staff documents UI          | Backend/schema support Staff documents, but no FE surface found                           | Partial feature                    | Plan Staff documents tab or mark backend-only                 | Product/Dev | Open   |
| CLN-P2-016 | R1 Tenant MVP | Documents Engine   | Document history visibility | Replaced/archived documents not clearly visible in Player tab default view                | Lifecycle transparency gap         | Decide whether history should be user-visible                 | Product/Dev | Open   |
| CLN-P2-017 | R1 Tenant MVP | Documents Engine   | Endpoint helpers            | `api.endpoints.ts` has partial document helper; active code uses raw URLs                 | API naming drift                   | Standardize endpoint helper later                             | Dev         | Open   |
| CLN-P2-018 | R1 Tenant MVP | Shell              | Duplicate tenant context    | `TenantBoot` and `TenantProvider` duplicate club summary/context loading                  | Unnecessary complexity             | Simplify tenant context flow                                  | Dev         | Open   |
| CLN-P2-019 | R1 Tenant MVP | Shell              | UI-only topbar actions      | Search/help/notifications are visible but not functional                                  | User confusion                     | Hide, disable or implement                                    | Product/Dev | Open   |
| CLN-P2-020 | R1 Tenant MVP | Logo               | Content type                | Logo endpoint may return `image/jpeg` for other formats                                   | Technical correctness gap          | Align content type with actual file                           | Dev         | Open   |
| CLN-P2-021 | R1 Tenant MVP | Platform / System  | JWT generation              | `JwtTokenService` exists, but login uses local `BuildJwt`                                 | Auth logic duplication             | Centralize JWT generation                                     | Dev         | Open   |
| CLN-P2-022 | R1 Tenant MVP | Platform / System  | Auth/API duplication        | Three FE apps duplicate AuthContext, JWT parsing, API clients and cap helpers             | Maintenance risk                   | Plan later shared standardization                             | Dev         | Open   |

---

# Deferred — Release 1.5 Player Portal

Player Portal CORE postoji, ali nije dio prvog produkcijskog fokusa. Ove stavke se rješavaju prije aktivnog rollout-a Player Portala.

| ID          | Release            | Area              | Module                   | Issue                                                                                                       | Reason                                                          | Next action                                                    | Owner       | Status   |
| ----------- | ------------------ | ----------------- | ------------------------ | ----------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------- | -------------------------------------------------------------- | ----------- | -------- |
| CLN-R15-001 | R1.5 Player Portal | Tenant App        | Player Portal activation | Missing explicit club scoping                                                                               | Backend queries player by `playerId` while using `app.is_admin` | Add explicit `clubId` scoping and retest cross-club access     | Dev         | Deferred |
| CLN-R15-002 | R1.5 Player Portal | Player Portal App | Password reset route     | Login leads to `/password-reset`, but Player FE has no route/page                                           | Broken user-facing link                                         | Add route/page or remove link until ready                      | Dev         | Deferred |
| CLN-R15-003 | R1.5 Player Portal | Player Portal App | Notifications            | Notifications page uses mock data and has no backend/API                                                    | Mock-only feature                                               | Mark planned/mock or hide from navigation                      | Product/Dev | Deferred |
| CLN-R15-004 | R1.5 Player Portal | Player Portal App | Role guards              | `ProtectedRoute` and `PlayerAuthGuard` have duplicate/inconsistent role checks                              | Access behavior drift risk                                      | Consolidate guard logic                                        | Dev         | Deferred |
| CLN-R15-005 | R1.5 Player Portal | Player Portal App | Profile photo standard   | Profile photo uses `usePersonPhoto`, but not standard `PersonThumb` wrapper                                 | Photo pipeline inconsistency                                    | Switch to standard `PersonThumb` pattern                       | Dev         | Deferred |
| CLN-R15-006 | R1.5 Player Portal | Player Portal App | Attendance visibility    | Player attendance may include draft/unlocked attendance                                                     | Product rule unclear                                            | Decide: player sees draft attendance or only locked attendance | Product/Dev | Deferred |
| CLN-R15-007 | R1.5 Player Portal | Player Portal App | Club name display        | Sidebar hardcodes `ClubManager`, topbar uses real club name                                                 | Inconsistent branding                                           | Use real club name consistently                                | Dev         | Deferred |
| CLN-R15-008 | R1.5 Player Portal | Player Portal App | Legacy files             | Old `fetchSecurePhoto`, `photoCache`, duplicate EventsPage, duplicate sidebar and `PersonThumb copy` remain | Repo hygiene                                                    | Clean after stabilization                                      | Dev         | Deferred |
| CLN-R15-009 | R1.5 Player Portal | Player Portal App | Broad endpoint catalog   | `api.endpoints.ts` contains broad tenant/admin endpoints not used in player-fe                              | Surface noise                                                   | Limit to player-fe surface or clean later                      | Dev         | Deferred |

---

# Deferred — Release 2 Admin Platform

Admin Platform ostaje minimalan za setup i tehničku administraciju. Full polish ide kasnije.

| ID         | Release           | Area              | Module                       | Issue                                                                                    | Reason                                         | Next action                                            | Owner       | Status   |
| ---------- | ----------------- | ----------------- | ---------------------------- | ---------------------------------------------------------------------------------------- | ---------------------------------------------- | ------------------------------------------------------ | ----------- | -------- |
| CLN-R2-001 | R2 Admin Platform | Admin Platform    | Admin club-user permissions  | Admin club-user endpoints lack explicit capability checks                                | Important for full admin security model        | Add proper `Admin.Users.*` or `Admin.Clubs.*` guards   | Dev         | Deferred |
| CLN-R2-002 | R2 Admin Platform | Admin Platform    | Feature toggle permissions   | Feature toggle endpoints lack explicit capability check                                  | Important for full admin security model        | Add admin capability guard for feature toggles         | Dev         | Deferred |
| CLN-R2-003 | R2 Admin Platform | Admin Platform    | Admin user create permission | `POST /api/admin/users` lacks visible `Admin.Users.Manage` guard                         | Important for full admin security model        | Add `Admin.Users.Manage` guard                         | Dev         | Deferred |
| CLN-R2-004 | R2 Admin Platform | Admin Platform    | Admin set-password scope     | Admin set-password works by raw user id                                                  | Scope/safety rule should be explicit           | Verify/document rule and add safety checks if needed   | Dev/Product | Deferred |
| CLN-R2-005 | R2 Admin Platform | Admin Platform    | Club list filters            | FE sends `search/status`, backend expects `q/isActive`                                   | Search/filter may behave incorrectly           | Align query params                                     | Dev         | Deferred |
| CLN-R2-006 | R2 Admin Platform | Admin Platform    | Club details billing tabs    | Subscription/invoices tabs are placeholder alerts                                        | UI confusion                                   | Connect to Platform Billing or remove until ready      | Dev/Product | Deferred |
| CLN-R2-007 | R2 Admin Platform | Admin Platform    | Club users lifecycle         | No complete update/activate/deactivate endpoint or FE flow                               | Incomplete admin user lifecycle                | Decide minimal admin club-user lifecycle               | Product/Dev | Deferred |
| CLN-R2-008 | R2 Admin Platform | Admin Platform    | Feature toggle validation    | Backend lacks feature-key allowlist; FE has hardcoded list                               | Invalid keys can be persisted                  | Add backend allowlist or central feature keys endpoint | Dev         | Deferred |
| CLN-R2-009 | R2 Admin Platform | Admin Platform    | Placeholder pages            | Dashboard, users, roles, audit, settings, seasons are active nav routes but placeholders | User confusion                                 | Hide from navigation or clearly mark planned           | Product/Dev | Deferred |
| CLN-R2-010 | R2 Admin Platform | Admin Platform    | Logo validation              | Club logo lacks magic-byte validation evidence                                           | Validation weaker than document/photo standard | Align with stricter file validation if needed          | Dev         | Deferred |
| CLN-R2-011 | R2 Admin Platform | Admin Platform    | Legacy/demo files            | `index copy.css`, `react.svg`, generic `photoCache.ts` create noise                      | Repo hygiene                                   | Clean after priorities                                 | Dev         | Deferred |
| CLN-R2-012 | R2 Admin Platform | Platform / System | Admin FE API clients         | Admin FE has `api/index.ts` and legacy-looking `lib/axios.ts`                            | Duplicate API client                           | Clean duplicate API client                             | Dev         | Deferred |

---

# Deferred — Release 3 Platform Billing

Platform Billing nije dio prvog produkcijskog fokusa. Core postoji, ali full financial discipline ide u kasnijoj fazi.

| ID         | Release             | Area             | Module                         | Issue                                                               | Reason                                         | Next action                                               | Owner       | Status   |
| ---------- | ------------------- | ---------------- | ------------------------------ | ------------------------------------------------------------------- | ---------------------------------------------- | --------------------------------------------------------- | ----------- | -------- |
| CLN-R3-001 | R3 Platform Billing | Platform Billing | Payment storno/reversal        | Platform payments have edit/delete, but no storno/reversal model    | Needed for accounting-grade billing            | Decide and implement storno/reversal model                | Product/Dev | Deferred |
| CLN-R3-002 | R3 Platform Billing | Platform Billing | Payment delete                 | Payment delete is destructive financial action                      | Should not be default for billing-grade system | Replace with storno workflow or restrict to safe mode     | Dev/Product | Deferred |
| CLN-R3-003 | R3 Platform Billing | Platform Billing | Billing audit logging          | Billing mutations do not show visible audit logging                 | Financial audit trail missing                  | Add audit for plan/subscription/invoice/payment mutations | Dev         | Deferred |
| CLN-R3-004 | R3 Platform Billing | Platform Billing | Invoice status source of truth | Stored invoice status can drift from payments/due date/finalizer    | Billing status can become unreliable           | Standardize status as computed or consistently maintained | Dev/Product | Deferred |
| CLN-R3-005 | R3 Platform Billing | Platform Billing | Plan billing cycle             | Yearly behavior is not clearly enforced; renewal uses monthly logic | Billing cycle mismatch                         | Align billing cycle with renewal/invoice rules            | Dev/Product | Deferred |
| CLN-R3-006 | R3 Platform Billing | Platform Billing | Subscription scheduled change  | Scheduled change-plan is explicitly not implemented                 | Feature expectation mismatch                   | Implement or remove from expectations/UI text             | Product/Dev | Deferred |
| CLN-R3-007 | R3 Platform Billing | Platform Billing | Subscription past_due          | `past_due` status exists, but no clear transition rule              | Status semantics incomplete                    | Define when/how subscription becomes `past_due`           | Product/Dev | Deferred |
| CLN-R3-008 | R3 Platform Billing | Platform Billing | Invoice create validation      | Zero-amount invoice appears allowed                                 | Billing rule unclear                           | Decide if allowed; if not, validate `amount > 0`          | Product/Dev | Deferred |
| CLN-R3-009 | R3 Platform Billing | Platform Billing | FE capability guards           | Admin FE billing actions are not capability-aware                   | Poor UX for admins without caps                | Add FE cap guards or improve backend rejection UX         | Dev         | Deferred |
| CLN-R3-010 | R3 Platform Billing | Platform Billing | Client-side filtering          | FE often filters locally after first page                           | Paged data may be misleading                   | Align FE filters with backend paged/filter endpoints      | Dev         | Deferred |
| CLN-R3-011 | R3 Platform Billing | Platform Billing | Standalone payments            | `/payments` route is placeholder; no standalone API                 | UI-only route                                  | Hide route or implement actual module                     | Product/Dev | Deferred |
| CLN-R3-012 | R3 Platform Billing | Platform Billing | Exports                        | No export API/UI for platform billing                               | Planned feature                                | Plan or leave as Planned                                  | Product     | Deferred |

---

# Product decisions

Ove odluke treba donijeti prije odgovarajuće release faze.

| ID      | Release             | Area               | Decision                                                         | Why it matters                                                | Proposed owner | Status   |
| ------- | ------------------- | ------------------ | ---------------------------------------------------------------- | ------------------------------------------------------------- | -------------- | -------- |
| DEC-001 | R1 Tenant MVP       | Documents Engine   | Should Club documents exist in Tenant App?                       | Service and schema disagree; UI does not exist                | Product/Dev    | Open     |
| DEC-002 | R1 Tenant MVP       | Documents Engine   | Should replaced document history be visible?                     | Affects digital dossier transparency                          | Product        | Open     |
| DEC-003 | R1 Tenant MVP       | Documents Engine   | Should there be `ViewDocuments` separate from `ManageDocuments`? | Affects read-only roles                                       | Product/Dev    | Open     |
| DEC-004 | R1 Tenant MVP       | Club branding      | Can tenant manage own logo?                                      | Currently admin-side only                                     | Product        | Open     |
| DEC-005 | R1 Tenant MVP       | Lineup / MatchList | Is export required or is print enough?                           | Print exists, export does not                                 | Product        | Open     |
| DEC-006 | R1 Tenant MVP       | Finance Fees       | Should direct invoice CRUD exist outside bulk workflow?          | Bulk workflow exists; direct UI not active                    | Product        | Open     |
| DEC-007 | R1.5 Player Portal  | Player Portal App  | Should player see draft attendance or only locked attendance?    | Affects trust and communication with players                  | Product/Dev    | Deferred |
| DEC-008 | R3 Platform Billing | Platform Billing   | Is Platform Billing accounting-grade or operational only?        | Determines whether storno/audit is mandatory                  | Product/Dev    | Deferred |
| DEC-009 | R3 Platform Billing | Platform Billing   | Should standalone payments exist?                                | Route exists as placeholder, no API                           | Product        | Deferred |
| DEC-010 | R1 Tenant MVP       | Platform / System  | What health/readiness data may be public?                        | `/healthz` and `/readyz` expose environment/readiness details | Product/Ops    | Open     |

---

# Current work split

## Dev focus for Release 1

1. Fix P0 Tenant App blockers.
2. Fix enough P1 items to allow functional verification.
3. Mark fixed items as `Fixed`.
4. Send only fixed or stable flows to targeted retest.

## Tester focus for Release 1

Tester can start with stable Tenant App flows:

1. People basic flow.
2. Teams basic flow.
3. Events basic flow.
4. Attendance basic flow.
5. Documents player flow.
6. Finance fees basic flow.
7. Dashboard basic flow.

Player Portal testing is useful, but not Release 1 priority.

## Not ready for Release 1 final verification

Do not mark these as `Verified` for Release 1:

* Player Portal rollout.
* Admin Platform polish.
* Platform Billing.
* Notifications.
* Password reset.
* Club documents.
* Dev diagnostics.
* Admin user-management edge cases.
* Platform/System security edge cases not needed for tenant daily operation.

---

# Update rule

When a cleanup item is fixed, update the row:

```text
Status: Fixed
```

After retest:

```text
Status: Retested
```

If intentionally postponed:

```text
Status: Deferred
```

If intentionally not fixed:

```text
Status: Won’t fix
```

For every `Fixed` or `Retested` item, add a short note in:

```text
docs/product/module-status.md
```

or in the relevant checklist.
