# ClubManager System Surface Map

Ovaj dokument mapira stvarnu površinu ClubManager sistema.

Cilj je da inventory ne vodimo samo iz sjećanja, nego iz stvarnog stanja aplikacije:

- Tenant FE rute
- Tenant FE ekrani
- navigacija
- feature folderi
- API endpointi
- permission/capability upotreba
- skriveni ili neizloženi feature-i
- dupli/legacy tokovi
- razlike između stvarnog sistema i product inventory-ja

Ovaj dokument nije isto što i `clubmanager-inventory.md`.

```text
system-surface-map.md = šta stvarno postoji u sistemu
clubmanager-inventory.md = status svakog modula/feature-a
module-status.md = šta je završeno, šta je u toku, šta je sljedeće
```

---

# 1. Izvori provjere

## Tenant FE audit

Izvor:

```text
Codex audit tenant-fe workspace
```

Status:

```text
No files modified
```

Audit je pregledao:

- rute
- stranice
- navigaciju
- feature foldere
- API pozive
- permission/capability usage
- skrivene feature-e
- duple/legacy tokove

## API surface

Izvor:

```text
Swagger / OpenAPI endpoint list
```

Swagger lista je ručno dostavljena i grupisana u ovom dokumentu.

---

# 2. Tenant FE Surface

## 2.1 Public routes

| Route             | Screen          |
| ----------------- | --------------- |
| `/login`          | `Login`         |
| `/password-reset` | `PasswordReset` |

## 2.2 Private shell routes

| Route                    | Screen / Behavior                              |
| ------------------------ | ---------------------------------------------- |
| `/`                      | redirect to `/dashboard`                       |
| `/dashboard`             | `DashboardPage`                                |
| `/players`               | `PlayersPage`                                  |
| `/players/create`        | `PlayerCreatePage`, guarded by `ManagePlayers` |
| `/players/:id`           | `PlayerDetailPage`                             |
| `/players/:id/edit`      | `PlayerEditPage`, guarded by `ManagePlayers`   |
| `/teams`                 | `TeamsPage`                                    |
| `/teams/:id`             | `TeamDetailPage`                               |
| `/teams/:id/edit`        | `TeamEditPage`                                 |
| `/events`                | `EventsPage`                                   |
| `/events/:id`            | `EventDetailPage`                              |
| `/events/:id/attendance` | `EventDetailPage`                              |
| `/events/:id/match-list` | `EventDetailPage`                              |
| `/finance`               | redirect to `/finance/fees`                    |
| `/finance/fees`          | `FeesPage`                                     |
| `/finance/transactions`  | `FinTransactionsPage`                          |
| `/finance/categories`    | `FinanceCategoriesPage`                        |
| `/staff`                 | `StaffPage`                                    |
| `/staff/:id`             | `StaffDetailPage`                              |
| `/staff/:id/edit`        | `StaffEditPage`                                |
| `/users`                 | `UsersPage`                                    |
| `/settings/password`     | `ChangePasswordPage`                           |
| guarded `*`              | inline 404                                     |
| outer `*`                | redirect to `/players`                         |

---

# 3. Tenant FE Pages / Screens

## Routed pages

| Area      | Screens                                        |
| --------- | ---------------------------------------------- |
| Auth      | `Login`, `PasswordReset`                       |
| Dashboard | `DashboardPage`                                |
| Players   | list, create, detail, edit                     |
| Teams     | list, detail, edit                             |
| Events    | list, detail, attendance view, match-list view |
| Finance   | fees, transactions, categories                 |
| Staff     | list, detail, edit                             |
| Users     | users list/manage                              |
| Settings  | password change                                |

## Unrouted page files

Ovi fajlovi postoje, ali trenutno nisu direktno routani:

| File                                           | Note                                                               |
| ---------------------------------------------- | ------------------------------------------------------------------ |
| `EventAttendancePage.tsx`                      | postoji, ali event attendance se otvara kroz `EventDetailPage`     |
| `FinanceTransactionsPage.tsx`                  | postoji, ali `/finance/transactions` koristi `FinTransactionsPage` |
| `DemoEditLayout.tsx`                           | demo/layout file                                                   |
| `__LayoutDemoPage.tsx`                         | demo/layout file                                                   |
| `ClubManager.code-workspace` under `src/pages` | workspace file unutar pages foldera                                |

---

# 4. Tenant FE Navigation

## Sidebar

### Takmičenje

| Label    | Route        |
| -------- | ------------ |
| Početna  | `/dashboard` |
| Ekipe    | `/teams`     |
| Igrači   | `/players`   |
| Događaji | `/events`    |

### Finansije

| Label       | Route                   |
| ----------- | ----------------------- |
| Članarine   | `/finance/fees`         |
| Transakcije | `/finance/transactions` |
| Kategorije  | `/finance/categories`   |

### Organizacija

| Label   | Route    |
| ------- | -------- |
| Osoblje | `/staff` |

### Podešavanja

| Label            | Route                | Visibility               |
| ---------------- | -------------------- | ------------------------ |
| Korisnici        | `/users`             | only with `ManageUsers`  |
| Promjena lozinke | `/settings/password` | visible in settings area |

## Topbar

Topbar prikazuje:

- logo / club branding
- breadcrumbs
- global search input
- Pomoć button
- Obavijesti button
- logout

Napomena:

- `Pomoć`, `Obavijesti` i global search trenutno izgledaju kao UI-only elementi.
- Nije pronađena jasna ruta ili akcija za njih.

---

# 5. Tenant FE Feature Modules

Feature folderi pod `src/features`:

| Feature folder      | Purpose                               |
| ------------------- | ------------------------------------- |
| `common`            | shared photo upload, player picker    |
| `dashboard`         | dashboard cards/widgets               |
| `eligibility`       | eligibility display/checks            |
| `events/attendance` | event attendance UI                   |
| `events/matchList`  | match list / lineup UI                |
| `fees`              | fee invoices/payments                 |
| `finance`           | finance transactions/categories       |
| `player-details`    | player detail tabs                    |
| `players`           | player forms/components               |
| `staff`             | staff forms/components                |
| `teams`             | teams, memberships, attendance panels |
| `users`             | user management                       |

## Major shared components

| Component           | Purpose                              |
| ------------------- | ------------------------------------ |
| `PersonThumb`       | standard player/staff avatar display |
| `PhotoUploadModal`  | shared photo upload/delete modal     |
| `PlayerPickerModal` | player selection modal               |
| `StatusPill`        | shared status badge                  |
| `CmDatePicker`      | date picker                          |
| `CmMonthPicker`     | month picker                         |
| `CmTimePicker`      | time picker                          |
| `CountrySelect`     | country selection                    |
| `AppPage`           | page layout primitive                |
| `PageCard`          | card layout primitive                |
| `PageActions`       | page action area                     |
| `FormGrid`          | form layout primitive                |
| `Sidebar`           | main shell navigation                |
| `Topbar`            | top shell bar                        |
| `Breadcrumbs`       | breadcrumb navigation                |
| `BuildInfoBadge`    | build/version display                |

---

# 6. Tenant FE Permission / Capability Usage

## Defined tenant capabilities

| Capability            |
| --------------------- |
| `ReadOnly`            |
| `ViewReports`         |
| `ManageUsers`         |
| `ManagePlayers`       |
| `ManageTeams`         |
| `ManageRegistrations` |
| `ManageFinance`       |
| `ManageDocuments`     |
| `ManageEvents`        |

## Used capabilities

| Capability        | Usage                                                                                |
| ----------------- | ------------------------------------------------------------------------------------ |
| `ManagePlayers`   | player create/edit routes, player actions, contracts, quick view, some staff actions |
| `ManageTeams`     | teams pages/panels, staff assignment                                                 |
| `ManageEvents`    | dashboard/events actions                                                             |
| `ManageFinance`   | fees, finance transactions, fee history                                              |
| `ManageDocuments` | player documents                                                                     |
| `ManageUsers`     | users page/sidebar item, player portal activation controls                           |
| `ReadOnly`        | dashboard/fees/transactions read gating                                              |

## Defined but unclear usage

| Capability            | Note                                            |
| --------------------- | ----------------------------------------------- |
| `ViewReports`         | defined, but not clearly used in tenant scan    |
| `ManageRegistrations` | defined, but not found as clear tenant FE check |

---

# 7. Hidden Or Unexposed Tenant Features

Ovi feature-i postoje, ali nisu direktno sidebar moduli:

| Feature                   | Location              |
| ------------------------- | --------------------- |
| Player Portal             | player detail tab     |
| Player documents          | player detail tab     |
| Player contracts          | player detail tab     |
| Player medicals           | player detail tab     |
| Player registrations      | player detail tab     |
| Player teams              | player detail tab     |
| Player fees               | player detail tab     |
| Event attendance          | event detail subroute |
| Event match-list / lineup | event detail subroute |
| Team attendance           | team detail/panels    |
| Team player memberships   | team detail/panels    |
| Team staff memberships    | team detail/panels    |

---

# 8. Duplicate / Legacy / Hygiene Findings

| Area    | Finding                                                                                                                     |
| ------- | --------------------------------------------------------------------------------------------------------------------------- |
| Players | Player create has two flows: routed `PlayerCreatePage` with `PlayerForm`, and older modal create logic inside `PlayersPage` |
| JMBG    | auto-fill exists in older `PlayersPage` modal flow, but not in primary `PlayerForm`                                         |
| Photos  | photo/avatar is standardized, but `PlayersPage`/`StaffPage` still use local thumb wrappers with `usePersonPhoto`            |
| Photos  | commented legacy photo code still exists in some files                                                                      |
| Players | `PlayerCreatePage` has `console.log` and visible DEV marker                                                                 |
| Events  | `EventAttendancePage.tsx` exists but is not routed                                                                          |
| Finance | `FinanceTransactionsPage.tsx` exists, but active route uses `FinTransactionsPage`                                           |
| Finance | endpoint naming appears duplicated: `EP.finance.*`, `EP.fin.*`, `EP.fees.*`                                                 |
| Topbar  | `Pomoć`, `Obavijesti`, global search appear UI-only/static                                                                  |
| Demo    | demo/layout pages exist but are not routed                                                                                  |

---

# 9. API Surface Map

API endpointi su grupisani po poslovnoj/sistemskoj oblasti.

## 9.1 Auth / Account

| Group   | Endpoints                           |
| ------- | ----------------------------------- |
| Account | `POST /api/account/change-password` |
| Auth    | `POST /api/auth/login`              |
| Auth    | `POST /api/auth/password/reset`     |
| Auth    | `POST /api/auth/password/set`       |

## 9.2 Dev / diagnostics

| Group   | Endpoints                   |
| ------- | --------------------------- |
| Dev     | `GET /api/dev/check-cap`    |
| Dev     | `DELETE /api/dev/acl/cache` |
| Dev     | `GET /api/dev/cap-debug`    |
| DevAuth | `GET /api/dev/auth/token`   |
| DevAuth | `GET /api/dev/auth/whoami`  |
| WhoAmI  | `GET /api/dev/whoami`       |

Napomena:

Ovo nisu product feature-i. Treba ih tretirati kao dev/diagnostic površinu i kasnije provjeriti dostupnost po okruženjima.

## 9.3 Meta / health

| Group           | Endpoints                       |
| --------------- | ------------------------------- |
| ClubManager.Api | `GET /`                         |
| Meta            | `GET /healthz`                  |
| Meta            | `GET /readyz`                   |
| Meta            | `GET /api/admin/meta/constants` |

## 9.4 Admin platform

### Clubs

| Method | Endpoint                           |
| ------ | ---------------------------------- |
| GET    | `/api/admin/clubs`                 |
| POST   | `/api/admin/clubs`                 |
| GET    | `/api/admin/clubs/{id}`            |
| PUT    | `/api/admin/clubs/{id}`            |
| GET    | `/api/admin/clubs/{id}/summary`    |
| POST   | `/api/admin/clubs/{id}/activate`   |
| POST   | `/api/admin/clubs/{id}/deactivate` |
| POST   | `/api/admin/clubs/{id}/logo`       |
| DELETE | `/api/admin/clubs/{id}/logo`       |
| GET    | `/api/admin/clubs/{id}/logo`       |

### Admin users / club users / roles

| Group           | Endpoint                                   |
| --------------- | ------------------------------------------ |
| AdminUsers      | `POST /api/admin/users`                    |
| AdminUsers      | `GET /api/admin/users/{id}`                |
| AdminUsers      | `POST /api/admin/users/{id}/set-password`  |
| AdminClubsUsers | `GET /api/admin/clubs/{clubId}/users`      |
| AdminClubsUsers | `POST /api/admin/clubs/{clubId}/users`     |
| AdminClubsUsers | `GET /api/admin/clubs/{clubId}/users/{id}` |
| Roles           | `GET /api/admin/roles`                     |

### Admin settings / audit / features

| Group             | Endpoint                                              |
| ----------------- | ----------------------------------------------------- |
| AdminAudit        | `GET /api/admin/audit`                                |
| AdminSettings     | `GET /api/admin/settings`                             |
| AdminSettings     | `PUT /api/admin/settings`                             |
| AdminSettings     | `DELETE /api/admin/settings/{key}`                    |
| AdminClubFeatures | `GET /api/admin/clubs/{clubId}/features`              |
| AdminClubFeatures | `PUT /api/admin/clubs/{clubId}/features/{featureKey}` |

## 9.5 Platform billing

### Plans

| Method | Endpoint                           |
| ------ | ---------------------------------- |
| GET    | `/api/admin/plans`                 |
| POST   | `/api/admin/plans`                 |
| GET    | `/api/admin/plans/{id}`            |
| PUT    | `/api/admin/plans/{id}`            |
| GET    | `/api/admin/plans/ids`             |
| POST   | `/api/admin/plans/{id}/activate`   |
| POST   | `/api/admin/plans/{id}/deactivate` |

### Subscriptions

| Method | Endpoint                                            |
| ------ | --------------------------------------------------- |
| GET    | `/api/admin/subscriptions`                          |
| POST   | `/api/admin/subscriptions`                          |
| GET    | `/api/admin/subscriptions/{id}`                     |
| GET    | `/api/admin/subscriptions/by-club/{clubId}/current` |
| POST   | `/api/admin/subscriptions/by-club/{clubId}`         |
| POST   | `/api/admin/subscriptions/{id}/change-plan`         |
| POST   | `/api/admin/subscriptions/{id}/cancel`              |
| POST   | `/api/admin/subscriptions/ops/finalize`             |

### Admin invoices and payments

| Group    | Endpoint                                               |
| -------- | ------------------------------------------------------ |
| Invoices | `GET /api/admin/invoices`                              |
| Invoices | `GET /api/admin/invoices/{id}`                         |
| Invoices | `POST /api/admin/invoices/by-club/{clubId}`            |
| Invoices | `POST /api/admin/invoices/{id}/mark-paid`              |
| Invoices | `POST /api/admin/invoices/{id}/void`                   |
| Invoices | `POST /api/admin/invoices/ops/finalize`                |
| Payments | `GET /api/admin/invoices/{invoiceId}/payments`         |
| Payments | `POST /api/admin/invoices/{invoiceId}/payments`        |
| Payments | `GET /api/admin/invoices/{invoiceId}/payments/{id}`    |
| Payments | `PUT /api/admin/invoices/{invoiceId}/payments/{id}`    |
| Payments | `DELETE /api/admin/invoices/{invoiceId}/payments/{id}` |
| Ops      | `POST /api/admin/ops/finalize`                         |

## 9.6 Tenant club

| Group     | Endpoint                     |
| --------- | ---------------------------- |
| ClubsMe   | `GET /api/clubs/me`          |
| ClubsMe   | `GET /api/clubs/me/summary`  |
| ClubsMe   | `GET /api/clubs/me/logo`     |
| Dashboard | `GET /api/dashboard`         |
| Settings  | `GET /api/settings`          |
| Settings  | `PUT /api/settings`          |
| Settings  | `DELETE /api/settings/{key}` |
| Lookups   | `GET /api/lookups`           |
| Lookups   | `GET /api/lookups/{key}`     |
| Config    | `GET /api/config/photo`      |

## 9.7 Players

| Method | Endpoint                                   |
| ------ | ------------------------------------------ |
| GET    | `/api/players`                             |
| POST   | `/api/players`                             |
| GET    | `/api/players/{id}`                        |
| PUT    | `/api/players/{id}`                        |
| DELETE | `/api/players/{id}`                        |
| POST   | `/api/players/{id}/photo`                  |
| DELETE | `/api/players/{id}/photo`                  |
| GET    | `/api/players/{id}/photo`                  |
| GET    | `/api/players/{id}/portal`                 |
| POST   | `/api/players/{id}/portal/activate`        |
| POST   | `/api/players/{id}/portal/deactivate`      |
| GET    | `/api/players/{playerId}/team-memberships` |
| GET    | `/api/players/{playerId}/fees/summary`     |

## 9.8 Player registrations / medicals / eligibility

| Group               | Endpoint                                  |
| ------------------- | ----------------------------------------- |
| PlayerRegistrations | `GET /api/player-registrations`           |
| PlayerRegistrations | `POST /api/player-registrations`          |
| PlayerRegistrations | `GET /api/player-registrations/{id}`      |
| PlayerRegistrations | `PUT /api/player-registrations/{id}`      |
| PlayerRegistrations | `DELETE /api/player-registrations/{id}`   |
| PlayerMedicals      | `GET /api/player-medicals`                |
| PlayerMedicals      | `POST /api/player-medicals`               |
| PlayerMedicals      | `GET /api/player-medicals/{id}`           |
| PlayerMedicals      | `PUT /api/player-medicals/{id}`           |
| PlayerMedicals      | `DELETE /api/player-medicals/{id}`        |
| Eligibility         | `GET /api/eligibility/players/{playerId}` |

## 9.9 Staff

| Method | Endpoint                |
| ------ | ----------------------- |
| GET    | `/api/staff`            |
| POST   | `/api/staff`            |
| GET    | `/api/staff/{id}`       |
| PUT    | `/api/staff/{id}`       |
| DELETE | `/api/staff/{id}`       |
| POST   | `/api/staff/{id}/photo` |
| DELETE | `/api/staff/{id}/photo` |
| GET    | `/api/staff/{id}/photo` |

## 9.10 Teams

| Method | Endpoint          |
| ------ | ----------------- |
| GET    | `/api/teams`      |
| POST   | `/api/teams`      |
| GET    | `/api/teams/{id}` |
| PUT    | `/api/teams/{id}` |
| DELETE | `/api/teams/{id}` |

### Team memberships

| Group                | Endpoint                                                    |
| -------------------- | ----------------------------------------------------------- |
| TeamMemberships      | `GET /api/teams/{teamId}/memberships`                       |
| TeamMemberships      | `POST /api/teams/{teamId}/memberships`                      |
| TeamMemberships      | `GET /api/teams/{teamId}/memberships/{id}`                  |
| TeamMemberships      | `PUT /api/teams/{teamId}/memberships/{id}`                  |
| TeamMemberships      | `DELETE /api/teams/{teamId}/memberships/{id}`               |
| TeamMemberships      | `GET /api/teams/{teamId}/memberships/available-players`     |
| TeamStaffMemberships | `GET /api/teams/{teamId}/staff-memberships`                 |
| TeamStaffMemberships | `POST /api/teams/{teamId}/staff-memberships`                |
| TeamStaffMemberships | `GET /api/teams/{teamId}/staff-memberships/{id}`            |
| TeamStaffMemberships | `PUT /api/teams/{teamId}/staff-memberships/{id}`            |
| TeamStaffMemberships | `DELETE /api/teams/{teamId}/staff-memberships/{id}`         |
| TeamStaffMemberships | `GET /api/teams/{teamId}/staff-memberships/available-staff` |

## 9.11 Events / Attendance / Lineup

### Events

| Method | Endpoint                             |
| ------ | ------------------------------------ |
| GET    | `/api/events`                        |
| POST   | `/api/events`                        |
| GET    | `/api/events/{id}`                   |
| PUT    | `/api/events/{id}`                   |
| DELETE | `/api/events/{id}`                   |
| POST   | `/api/events/{id}/cancel`            |
| POST   | `/api/events/{id}/complete`          |
| POST   | `/api/events/{id}/attendance/lock`   |
| POST   | `/api/events/{id}/attendance/unlock` |

### Event attendance

| Method | Endpoint                                            |
| ------ | --------------------------------------------------- |
| GET    | `/api/events/{eventId}/attendance`                  |
| POST   | `/api/events/{eventId}/attendance`                  |
| GET    | `/api/events/{eventId}/attendance/{id}`             |
| PUT    | `/api/events/{eventId}/attendance/{id}`             |
| DELETE | `/api/events/{eventId}/attendance/{id}`             |
| GET    | `/api/events/{eventId}/attendance/people`           |
| GET    | `/api/events/{eventId}/attendance/summary`          |
| POST   | `/api/events/{eventId}/attendance/bulk-upsert`      |
| GET    | `/api/teams/{teamId}/attendance/stats`              |
| GET    | `/api/teams/{teamId}/attendance/players/{playerId}` |

### Event lineup

| Method | Endpoint                                        |
| ------ | ----------------------------------------------- |
| GET    | `/api/events/{eventId}/lineup`                  |
| PUT    | `/api/events/{eventId}/lineup`                  |
| GET    | `/api/events/{eventId}/lineup/staff-candidates` |
| POST   | `/api/events/{eventId}/lineup/lock`             |
| POST   | `/api/events/{eventId}/lineup/unlock`           |

## 9.12 Documents

| Method | Endpoint                       |
| ------ | ------------------------------ |
| GET    | `/api/documents`               |
| POST   | `/api/documents`               |
| GET    | `/api/documents/{id}`          |
| DELETE | `/api/documents/{id}`          |
| GET    | `/api/documents/{id}/download` |
| PUT    | `/api/documents/{id}/replace`  |
| PUT    | `/api/documents/{id}/restore`  |
| PUT    | `/api/documents/{id}/purge`    |

## 9.13 Contracts

| Method | Endpoint                     |
| ------ | ---------------------------- |
| GET    | `/api/contracts/person`      |
| GET    | `/api/contracts/{id}`        |
| PUT    | `/api/contracts/{id}`        |
| DELETE | `/api/contracts/{id}`        |
| POST   | `/api/contracts`             |
| POST   | `/api/contracts/{id}/verify` |

## 9.14 Tenant finance

### Fee invoices

| Method | Endpoint                    |
| ------ | --------------------------- |
| GET    | `/api/fee-invoices`         |
| GET    | `/api/fee-invoices/{id}`    |
| PUT    | `/api/fee-invoices/{id}`    |
| DELETE | `/api/fee-invoices/{id}`    |
| GET    | `/api/fee-invoices/summary` |
| GET    | `/api/fee-invoices/export`  |

### Fee invoice operations

| Method | Endpoint                                  |
| ------ | ----------------------------------------- |
| GET    | `/api/fee-invoices/ops/wizard-preview`    |
| POST   | `/api/fee-invoices/ops/bulk-create`       |
| POST   | `/api/fee-invoices/ops/bulk-create-range` |
| POST   | `/api/fee-invoices/ops/bulk-pay`          |

### Fee payments

| Method | Endpoint                                             |
| ------ | ---------------------------------------------------- |
| GET    | `/api/fee-invoices/{invoiceId}/payments`             |
| POST   | `/api/fee-invoices/{invoiceId}/payments`             |
| GET    | `/api/fee-invoices/{invoiceId}/payments/{id}`        |
| PUT    | `/api/fee-invoices/{invoiceId}/payments/{id}`        |
| DELETE | `/api/fee-invoices/{invoiceId}/payments/{id}`        |
| POST   | `/api/fee-invoices/{invoiceId}/payments/{id}/storno` |
| GET    | `/api/fee-payments/export`                           |
| GET    | `/api/fees/summary`                                  |

### General finance

| Method | Endpoint                            |
| ------ | ----------------------------------- |
| GET    | `/api/fin/categories`               |
| POST   | `/api/fin/categories`               |
| PUT    | `/api/fin/categories/{id}`          |
| DELETE | `/api/fin/categories/{id}`          |
| GET    | `/api/fin/transactions`             |
| POST   | `/api/fin/transactions`             |
| GET    | `/api/fin/transactions/{id}`        |
| PUT    | `/api/fin/transactions/{id}`        |
| DELETE | `/api/fin/transactions/{id}`        |
| POST   | `/api/fin/transactions/{id}/storno` |
| GET    | `/api/fin/transactions/export`      |

## 9.15 Player Portal API

| Group            | Endpoint                        |
| ---------------- | ------------------------------- |
| PlayerMe         | `GET /api/player/me`            |
| PlayerMe         | `GET /api/player/me/club-logo`  |
| PlayerProfile    | `GET /api/player/profile`       |
| PlayerProfile    | `GET /api/player/profile/photo` |
| PlayerEvents     | `GET /api/player/events`        |
| PlayerEvents     | `GET /api/player/events/{id}`   |
| PlayerAttendance | `GET /api/player/attendance`    |
| PlayerFinance    | `GET /api/player/finance`       |

## 9.16 Seasons

| Group         | Endpoint                                   |
| ------------- | ------------------------------------------ |
| Seasons       | `GET /api/admin/seasons`                   |
| Seasons       | `POST /api/admin/seasons`                  |
| Seasons       | `GET /api/admin/seasons/{id}`              |
| Seasons       | `PUT /api/admin/seasons/{id}`              |
| Seasons       | `DELETE /api/admin/seasons/{id}`           |
| Seasons       | `POST /api/admin/seasons/{id}/set-default` |
| SeasonsTenant | `GET /api/seasons`                         |
| SeasonsTenant | `GET /api/seasons/default`                 |

## 9.17 Users

| Method | Endpoint                       |
| ------ | ------------------------------ |
| POST   | `/api/users`                   |
| GET    | `/api/users`                   |
| GET    | `/api/users/{id}`              |
| PUT    | `/api/users/{id}`              |
| POST   | `/api/users/{id}/set-password` |
| POST   | `/api/users/{id}/activate`     |
| POST   | `/api/users/{id}/deactivate`   |

---

# 10. Inventory Gaps Found

Na osnovu Tenant FE i API surface mape, početni inventory treba proširiti ili precizirati.

## 10.1 Dodati ili razdvojiti module

| Gap                              | Explanation                                                                       |
| -------------------------------- | --------------------------------------------------------------------------------- |
| Dashboard                        | Postoji kao aktivna Tenant FE ruta i API endpoint                                 |
| Auth / Account                   | Login, password reset i change password su stvarna površina                       |
| Platform Billing                 | Plans, subscriptions, admin invoices and payments su poseban admin/platform modul |
| Tenant Settings                  | `/api/settings` postoji odvojeno od admin settings                                |
| Admin Settings                   | `/api/admin/settings` postoji                                                     |
| Lookups / Config                 | `/api/lookups` i `/api/config/photo` postoje kao sistemski helperi                |
| Dev Diagnostics                  | dev endpointi postoje i treba ih označiti kao non-product/dev-only                |
| Player Portal profile/photo/logo | postoje dodatni player endpoints izvan osnovnog me/events/attendance/finance seta |
| Finance transactions/categories  | Finance nije samo članarina; postoji širi `fin` sloj                              |
| Contracts                        | postoji kao stvarni API modul, ne samo plan                                       |
| Seasons                          | admin i tenant seasons postoje                                                    |
| Users                            | tenant users management postoji                                                   |
| Club branding/logo               | club logo endpointi postoje                                                       |

## 10.2 Feature-i koji postoje, ali nisu sidebar moduli

| Feature              | Location              |
| -------------------- | --------------------- |
| Player Portal        | Player detail tab     |
| Player documents     | Player detail tab     |
| Player contracts     | Player detail tab     |
| Player medicals      | Player detail tab     |
| Player registrations | Player detail tab     |
| Player fees          | Player detail tab     |
| Team attendance      | Team detail/panels    |
| Event attendance     | Event detail subroute |
| Event match-list     | Event detail subroute |

## 10.3 Legacy / cleanup candidates

| Candidate                              | Reason                                             |
| -------------------------------------- | -------------------------------------------------- |
| Duplicate player create flow           | routed create page + older modal create            |
| JMBG auto-fill mismatch                | exists in old modal flow, not primary `PlayerForm` |
| Unrouted `EventAttendancePage.tsx`     | exists but not routed                              |
| Unrouted `FinanceTransactionsPage.tsx` | exists but not active route                        |
| Demo layout pages                      | not product routes                                 |
| Topbar help/notifications/search       | visible but apparently UI-only                     |
| `ViewReports` cap                      | defined but unclear tenant FE usage                |
| `ManageRegistrations` cap              | defined but unclear tenant FE usage                |
| finance endpoint naming duplication    | `finance`, `fin`, `fees` all exist                 |

---

# 11. Suggested Inventory Modules To Verify

Recommended verification order:

| Priority | Module                                   |
| -------- | ---------------------------------------- |
| 1        | Players                                  |
| 2        | Staff                                    |
| 3        | Teams                                    |
| 4        | Documents                                |
| 5        | Contracts                                |
| 6        | Player medicals                          |
| 7        | Player registrations                     |
| 8        | Eligibility                              |
| 9        | Events                                   |
| 10       | Attendance                               |
| 11       | MatchList / Lineup                       |
| 12       | Tenant Finance — fees                    |
| 13       | Tenant Finance — transactions/categories |
| 14       | Users                                    |
| 15       | Dashboard                                |
| 16       | Settings / lookups / config              |
| 17       | Admin Platform                           |
| 18       | Platform Billing                         |
| 19       | Dev/system endpoints                     |

Already verified:

| Module                | Status     |
| --------------------- | ---------- |
| Photo/avatar pipeline | `Polished` |
| Player Portal CORE    | `Verified` |

---

# 12. Current Conclusion

Početni inventory je koristan kao nacrt, ali nije kompletna slika sistema.

System Surface Map pokazuje da ClubManager ima širu površinu nego što je prvi inventory obuhvatio.

Glavne razlike:

- Finance treba razdvojiti na članarine i šire finansijske transakcije.
- Platform billing je poseban admin modul.
- Player detail tabovi su stvarni feature-i, iako nisu sidebar moduli.
- Dev/diagnostic endpointi postoje i treba ih posebno označiti.
- Neki capovi postoje, ali nisu jasno korišteni.
- Postoje dupli/legacy tokovi koje treba evidentirati, ali ne popravljati dok se inventory ne završi.

Pravilo za nastavak:

```text
Prvo kompletna mapa sistema.
Zatim verifikacija modula.
Tek onda korekcije i polish.
```

---

# 13. Admin FE Surface

Ova sekcija mapira stvarnu površinu `admin-fe` aplikacije.

Izvor:

```text
Codex audit admin-fe workspace
```

Status audita:

```text
No files modified
```

---

## 13.1 Admin FE routes

| Route            | Screen / Behavior    |
| ---------------- | -------------------- |
| `/login`         | `LoginPage`          |
| `/`              | redirect to `/clubs` |
| `/dashboard`     | placeholder          |
| `/clubs`         | `ClubsPage`          |
| `/clubs/:id`     | `ClubDetailsPage`    |
| `/users`         | placeholder          |
| `/roles`         | placeholder          |
| `/audit`         | placeholder          |
| `/settings`      | placeholder          |
| `/subscriptions` | `SubscriptionsPage`  |
| `/plans`         | `PlansPage`          |
| `/invoices`      | `InvoicesPage`       |
| `/payments`      | placeholder          |
| `/seasons`       | placeholder          |
| `*`              | redirect to `/`      |

---

## 13.2 Admin FE active pages

| Page                    | Status |
| ----------------------- | ------ |
| `LoginPage.tsx`         | active |
| `ClubsPage.tsx`         | active |
| `ClubDetailsPage.tsx`   | active |
| `PlansPage.tsx`         | active |
| `SubscriptionsPage.tsx` | active |
| `InvoicesPage.tsx`      | active |

---

## 13.3 Admin FE placeholder pages

Ove rute postoje, ali vode na placeholder ekrane:

| Area      | Status      |
| --------- | ----------- |
| Dashboard | placeholder |
| Users     | placeholder |
| Roles     | placeholder |
| Audit     | placeholder |
| Settings  | placeholder |
| Payments  | placeholder |
| Seasons   | placeholder |

Zaključak:

Admin FE navigacija je šira od stvarno implementirane admin površine.

---

## 13.4 Admin FE navigation

Sidebar sekcije:

### Platform

| Label     | Route        |
| --------- | ------------ |
| Dashboard | `/dashboard` |
| Clubs     | `/clubs`     |
| Users     | `/users`     |
| Roles     | `/roles`     |
| Audit     | `/audit`     |
| Settings  | `/settings`  |

### Billing

| Label         | Route            |
| ------------- | ---------------- |
| Plans         | `/plans`         |
| Subscriptions | `/subscriptions` |
| Invoices      | `/invoices`      |
| Payments      | `/payments`      |

### System

| Label   | Route      |
| ------- | ---------- |
| Seasons | `/seasons` |

Sidebar takođe ima logout i mobile user chip.

---

## 13.5 Admin FE feature modules

Feature folderi pod `admin-fe/src/features`:

| Feature folder  | Purpose                                                                    |
| --------------- | -------------------------------------------------------------------------- |
| `clubs`         | club form, club summary, club users, feature toggles, bootstrap club owner |
| `common`        | shared photo upload                                                        |
| `invoices`      | create invoice, invoice payments modal                                     |
| `subscriptions` | create subscription, change plan, cancel subscription                      |
| `users`         | set password modal                                                         |

---

## 13.6 Admin FE shared components

| Component / Area        | Purpose                               |
| ----------------------- | ------------------------------------- |
| `AdminLayout`           | main admin shell                      |
| `AdminSidebar`          | admin navigation                      |
| `AdminTopbar`           | admin topbar                          |
| `StatusPill`            | shared status display                 |
| `CountrySelect`         | country select                        |
| `PhotoUploadModal`      | logo/photo upload                     |
| `useClubLogo`           | club logo display                     |
| `usePhotoProfileConfig` | photo config                          |
| `AuthContext`           | auth state                            |
| `ProtectedRoute`        | admin route protection                |
| `src/api/index.ts`      | API client                            |
| `src/lib/axios.ts`      | possible duplicate API client pattern |

---

## 13.7 Admin FE API usage

### Auth

| Method | Endpoint      |
| ------ | ------------- |
| POST   | `/auth/login` |

### Clubs

| Method | Endpoint                      |
| ------ | ----------------------------- |
| GET    | `/admin/clubs`                |
| POST   | `/admin/clubs`                |
| GET    | `/admin/clubs/:id`            |
| PUT    | `/admin/clubs/:id`            |
| POST   | `/admin/clubs/:id/activate`   |
| POST   | `/admin/clubs/:id/deactivate` |

### Club logo

| Method | Endpoint                           |
| ------ | ---------------------------------- |
| GET    | `/admin/clubs/:id/logo?size=thumb` |
| POST   | `/admin/clubs/:id/logo`            |
| DELETE | `/admin/clubs/:id/logo`            |

### Club users

| Method | Endpoint                     |
| ------ | ---------------------------- |
| GET    | `/admin/clubs/:clubId/users` |
| POST   | `/admin/clubs/:clubId/users` |

### Admin users

| Method | Endpoint                            |
| ------ | ----------------------------------- |
| POST   | `/admin/users/:userId/set-password` |

### Feature toggles

| Method | Endpoint                                    |
| ------ | ------------------------------------------- |
| GET    | `/admin/clubs/:clubId/features`             |
| PUT    | `/admin/clubs/:clubId/features/:featureKey` |

### Plans

| Method | Endpoint                      |
| ------ | ----------------------------- |
| GET    | `/admin/plans`                |
| POST   | `/admin/plans`                |
| GET    | `/admin/plans/:id`            |
| PUT    | `/admin/plans/:id`            |
| POST   | `/admin/plans/:id/activate`   |
| POST   | `/admin/plans/:id/deactivate` |

### Subscriptions

| Method | Endpoint                                       |
| ------ | ---------------------------------------------- |
| GET    | `/admin/subscriptions`                         |
| POST   | `/admin/subscriptions/by-club/:clubId`         |
| GET    | `/admin/subscriptions/by-club/:clubId/current` |
| POST   | `/admin/subscriptions/:id/change-plan`         |
| POST   | `/admin/subscriptions/:id/cancel`              |

### Invoices

| Method | Endpoint                          |
| ------ | --------------------------------- |
| GET    | `/admin/invoices`                 |
| POST   | `/admin/invoices/by-club/:clubId` |
| POST   | `/admin/invoices/:id/mark-paid`   |
| POST   | `/admin/invoices/:id/void`        |

### Invoice payments

| Method | Endpoint                                         |
| ------ | ------------------------------------------------ |
| GET    | `/admin/invoices/:invoiceId/payments`            |
| GET    | `/admin/invoices/:invoiceId/payments/:id`        |
| POST   | `/admin/invoices/:invoiceId/payments`            |
| PUT    | `/admin/invoices/:invoiceId/payments/:paymentId` |
| DELETE | `/admin/invoices/:invoiceId/payments/:paymentId` |

### Config

| Method | Endpoint        |
| ------ | --------------- |
| GET    | `/config/photo` |

---

## 13.8 Admin API areas actually used

| Admin API area  | Admin FE usage                                      |
| --------------- | --------------------------------------------------- |
| Clubs           | yes                                                 |
| Club users      | yes                                                 |
| Users           | partial, only set password modal                    |
| Roles           | no implemented API usage; placeholder route only    |
| Feature toggles | yes                                                 |
| Settings        | no admin settings API usage; placeholder route only |
| Audit           | no; placeholder route only                          |
| Plans           | yes                                                 |
| Subscriptions   | yes                                                 |
| Invoices        | yes                                                 |
| Payments        | yes, but only nested invoice payments               |
| Ops/finalize    | no usage found                                      |
| Seasons         | no usage found; placeholder route only              |

---

## 13.9 Admin FE role / permission usage

Admin FE uses a role gate:

```text
Authenticated user must have role = admin
```

Observed behavior:

- `ProtectedRoute` checks authentication.
- Admin role check is based on `me.roles[0].toLowerCase() === "admin"`.
- `AuthContext` parses JWT roles and caps.
- `can(cap)` exists.
- No active page/nav capability checks were found beyond the admin role gate.

Current conclusion:

```text
Admin FE access control is role-based at shell level.
Granular admin capabilities are not clearly used in active pages.
```

---

## 13.10 Admin FE hidden / unexposed features

| Feature                      | Note                                                             |
| ---------------------------- | ---------------------------------------------------------------- |
| ClubDetails subscription tab | local placeholder-style section                                  |
| ClubDetails invoices tab     | local placeholder-style section                                  |
| `UserSetPasswordModal`       | reachable through club users, while `/users` page is placeholder |
| `PaymentsModal`              | active inside invoices, while `/payments` route is placeholder   |
| `AdminContext.tsx`           | appears unused                                                   |
| `CreateClubModal.tsx`        | likely duplicate/legacy beside active `ClubFormModal`            |
| `index copy.css`             | leftover/demo artifact                                           |
| `assets/react.svg`           | leftover/demo artifact                                           |
| `src/lib/axios.ts`           | possible duplicate API client pattern beside `src/api/index.ts`  |

---

## 13.11 Admin FE duplicate / legacy findings

| Area           | Finding                                                                                      |
| -------------- | -------------------------------------------------------------------------------------------- |
| Clubs          | two create implementations likely exist: active `ClubFormModal` and legacy `CreateClubModal` |
| API client     | two client patterns: `src/api/index.ts` and `src/lib/axios.ts`                               |
| Styles         | admin has copied tenant/domain styles, including player/team/fee selectors                   |
| Logo/photo     | admin has its own `utils/photoCache.ts`, actively used by `PhotoUploadModal`                 |
| Demo artifacts | `index copy.css` and `assets/react.svg` look like leftovers                                  |

Napomena:

Admin logo/photo cache ne treba dirati dok se posebno ne provjeri admin logo pipeline.

---

## 13.12 Admin FE inventory impact

Admin FE status nije jednako širok kao Admin API status.

### Implemented admin surfaces

| Module                       | Status      |
| ---------------------------- | ----------- |
| Admin auth / admin role gate | Implemented |
| Club management              | Implemented |
| Club details                 | Implemented |
| Club logo management         | Implemented |
| Club users                   | Implemented |
| Club feature toggles         | Implemented |
| Plans                        | Implemented |
| Subscriptions                | Implemented |
| Invoices                     | Implemented |
| Invoice payments             | Implemented |

### Placeholder / planned admin surfaces

| Module                   | Status      |
| ------------------------ | ----------- |
| Admin dashboard          | Placeholder |
| Admin users page         | Placeholder |
| Roles page               | Placeholder |
| Audit page               | Placeholder |
| Settings page            | Placeholder |
| Standalone payments page | Placeholder |
| Seasons page             | Placeholder |

Current conclusion:

```text
Admin FE = implemented with gaps.
Core clubs and billing surfaces exist.
Several navigation items are placeholders.
```

---

# 14. Player FE Surface

Ova sekcija mapira stvarnu površinu `player-fe` aplikacije.

Izvor:

```text
Codex audit player-fe workspace
```

Status audita:

```text
No files modified
```

---

## 14.1 Player FE routes

| Route            | Screen / Behavior                                                       |
| ---------------- | ----------------------------------------------------------------------- |
| `/login`         | `Login`                                                                 |
| protected shell  | `ProtectedRoute` -> `PlayerAuthGuard` -> `PlayerBoot` -> `PlayerLayout` |
| `/`              | redirect to `/dashboard`                                                |
| `/dashboard`     | `DashboardPage`                                                         |
| `/events`        | `EventsPage`                                                            |
| `/events/:id`    | `EventDetailPage`                                                       |
| `/attendance`    | `AttendancePage`                                                        |
| `/finance`       | `FinancePage`                                                           |
| `/notifications` | `NotificationsPage`                                                     |
| `/profile`       | `ProfilePage`                                                           |
| protected `*`    | inline 404                                                              |
| outer `*`        | redirect to `/dashboard`                                                |

---

## 14.2 Player FE active pages

| Page                    | Status                |
| ----------------------- | --------------------- |
| `Login.tsx`             | active                |
| `DashboardPage.tsx`     | active                |
| `EventsPage.tsx`        | active                |
| `EventDetailPage.tsx`   | active                |
| `AttendancePage.tsx`    | active                |
| `FinancePage.tsx`       | active                |
| `NotificationsPage.tsx` | active, but mock data |
| `ProfilePage.tsx`       | active                |

---

## 14.3 Player FE navigation

Sidebar items:

| Label      | Route            |
| ---------- | ---------------- |
| Početna    | `/`              |
| Događaji   | `/events`        |
| Prisustvo  | `/attendance`    |
| Članarine  | `/finance`       |
| Obavijesti | `/notifications` |
| Profil     | `/profile`       |
| Logout     | action           |

Topbar:

- logout
- club logo
- user chip
- Obavijesti button

Napomena:

Topbar `Obavijesti` button does not navigate.

---

## 14.4 Player FE feature organization

`player-fe` nema `src/features` folder.

Feature kod je organizovan uglavnom kroz:

- routed pages
- shared components
- hooks
- player context/bootstrap

Major functional areas:

| Area                         | Status          |
| ---------------------------- | --------------- |
| Player dashboard             | implemented     |
| Events list/detail           | implemented     |
| Attendance overview          | implemented     |
| Finance/member fees overview | implemented     |
| Notifications page           | mock/incomplete |
| Profile page                 | implemented     |
| Player context/bootstrap     | implemented     |
| Club logo display            | implemented     |
| Player profile photo display | implemented     |

---

## 14.5 Player FE API usage

Default API base:

```text
VITE_API_BASE_URL || "/api"
```

Therefore paths like `/player/me` resolve as:

```text
/api/player/me
```

### Actually used endpoints

| Area                 | Endpoint                                         |
| -------------------- | ------------------------------------------------ |
| Auth                 | `POST /api/auth/login`                           |
| Player bootstrap     | `GET /api/player/me`                             |
| Club logo            | `GET /api/player/me/club-logo?size=thumb`        |
| Player profile photo | `GET /api/player/profile/photo?size=thumb`       |
| Player profile photo | `GET /api/player/profile/photo?size=full`        |
| Events               | `GET /api/player/events`                         |
| Event detail         | `GET /api/player/events/:id`                     |
| Attendance           | `GET /api/player/attendance?membershipScope=all` |
| Finance              | `GET /api/player/finance`                        |

### Requested API area status

| API area                    | Used in Player FE        |
| --------------------------- | ------------------------ |
| `/api/player/me`            | yes                      |
| `/api/player/me/club-logo`  | yes                      |
| `/api/player/profile`       | no active API call found |
| `/api/player/profile/photo` | yes                      |
| `/api/player/events`        | yes                      |
| `/api/player/events/{id}`   | yes                      |
| `/api/player/attendance`    | yes                      |
| `/api/player/finance`       | yes                      |

---

## 14.6 Player FE role / access guards

Access flow:

```text
ProtectedRoute
PlayerAuthGuard
PlayerBoot
PlayerLayout
```

Observed behavior:

- `ProtectedRoute` requires authentication.
- `ProtectedRoute` checks first role lowercased equals `player`.
- `PlayerAuthGuard` also requires authentication.
- `PlayerAuthGuard` checks `me.roles.includes("player")`.
- `PlayerBoot` hydrates `PlayerContext` through `/player/me`.
- `RequireCap` and `CapKeys` exist, but routed player pages do not appear to use capability checks.

Risk:

```text
Role checks are duplicated and not fully consistent.
ProtectedRoute is case-insensitive for first role.
PlayerAuthGuard is case-sensitive and checks all roles.
```

---

## 14.7 Player FE hidden / unexposed findings

| Finding                 | Note                                                                                 |
| ----------------------- | ------------------------------------------------------------------------------------ |
| Notifications page      | routed and in navigation, but uses mock data                                         |
| Password reset link     | login links to `/password-reset`, but no `/password-reset` route exists              |
| Profile photo rendering | uses `usePersonPhoto` directly with manual `<img>`, not `PersonThumb`                |
| `api.endpoints.ts`      | broad tenant/admin endpoint catalog exists but appears unused by active player pages |
| generated contracts     | include many tenant/admin DTOs not specific to player portal                         |

---

## 14.8 Player FE duplicate / legacy findings

| Area        | Finding                                                                                                             |
| ----------- | ------------------------------------------------------------------------------------------------------------------- |
| Events      | `components/EventsPage.tsx` duplicates routed `pages/EventsPage.tsx`                                                |
| Sidebar     | `hooks/PlayerSidebar.tsx` duplicates `components/PlayerSidebar.tsx`                                                 |
| PersonThumb | `components/PersonThumb copy.tsx` exists                                                                            |
| Photo cache | `api/fetchSecurePhoto.ts` imports old `utils/photoCache.ts`, but active display uses `usePersonPhoto -> mediaStore` |
| Styles      | legacy styles exist under `src/styles/legacy`                                                                       |
| CSS         | copied CSS names suggest carried-over tenant styling                                                                |

---

## 14.9 Player FE inventory impact

### Implemented / verified core surfaces

| Module                   | Status                                                                     |
| ------------------------ | -------------------------------------------------------------------------- |
| Player authentication    | Implemented                                                                |
| Player-only access guard | Implemented / needs cleanup                                                |
| Player dashboard         | Verified through manual test                                               |
| Player profile           | Verified / implemented                                                     |
| Player events list       | Verified                                                                   |
| Player event detail      | Implemented, needs final manual detail verification if not already clicked |
| Player attendance        | Verified                                                                   |
| Player finance           | Verified                                                                   |
| Club logo                | Implemented                                                                |
| Player profile photo     | Implemented                                                                |

### Incomplete / cleanup surfaces

| Module                          | Status                                                |
| ------------------------------- | ----------------------------------------------------- |
| Notifications                   | Mock / Planned                                        |
| Password reset route            | Needs cleanup                                         |
| Role guard consistency          | Needs cleanup                                         |
| Player photo rendering standard | Needs cleanup / verify against `PersonThumb` standard |
| Duplicate/legacy files          | Needs cleanup                                         |
| Unused endpoint catalog         | Needs cleanup                                         |

Current conclusion:

```text
Player FE = implemented with cleanup needed.
Core portal pages and API integrations exist.
Notifications are mock.
Password reset link is broken/unrouted.
Role guards are duplicated.
Several legacy/duplicate files remain.
```

---

# 15. Updated Inventory Impact After Admin FE and Player FE Audits

Na osnovu Admin FE i Player FE audita, inventory treba precizirati u sljedećem krugu.

## 15.1 Admin inventory corrections

| Area             | Correction                                                     |
| ---------------- | -------------------------------------------------------------- |
| Admin Platform   | ne označavati cijeli Admin FE kao potpuno implementiran        |
| Admin Dashboard  | placeholder                                                    |
| Admin Users      | API exists, full FE page placeholder                           |
| Roles            | API exists, FE page placeholder                                |
| Audit            | API exists, FE page placeholder                                |
| Settings         | API exists, FE page placeholder                                |
| Seasons          | API exists, FE page placeholder                                |
| Platform Billing | plans/subscriptions/invoices/payments are active core surfaces |
| Payments         | invoice payments active; standalone payments route placeholder |

## 15.2 Player inventory corrections

| Area                  | Correction                                                 |
| --------------------- | ---------------------------------------------------------- |
| Player Portal CORE    | remains `Verified`                                         |
| Player Events         | list verified; detail page exists                          |
| Player Attendance     | verified                                                   |
| Player Finance        | verified                                                   |
| Player Notifications  | mock/planned                                               |
| Player Password Reset | link exists, route missing                                 |
| Player Access Guard   | implemented but needs cleanup                              |
| Player Profile Photo  | implemented, but uses manual `<img>` with `usePersonPhoto` |
| Player FE Cleanup     | duplicate/legacy files should be tracked                   |

---

# 16. Current System Surface Coverage

| Surface                          | Status           |
| -------------------------------- | ---------------- |
| API Surface                      | mapped           |
| Tenant FE Surface                | mapped           |
| Admin FE Surface                 | mapped           |
| Player FE Surface                | mapped           |
| Database Surface                 | not mapped       |
| Permissions/Capabilities Surface | partially mapped |
| Manual verification              | partial          |

Current conclusion:

```text
System Surface Map v1 is complete enough to drive Inventory v2.1.
It is not final until database and permissions/capabilities are fully mapped.
```
