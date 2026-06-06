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
