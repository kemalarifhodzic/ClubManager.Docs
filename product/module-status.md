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

| Module        | Feature                            | Status | Notes                                                                                                           |
| ------------- | ---------------------------------- | ------ | --------------------------------------------------------------------------------------------------------------- |
| Documentation | Central docs structure             | Done   | Kreiran centralni folder `/home/kemo/ClubManager/docs`                                                          |
| Documentation | OneNote structure                  | Done   | OneNote se koristi kao radna tabla / pregled                                                                    |
| Documentation | Central docs Git repo              | Done   | `/home/kemo/ClubManager/docs` je poseban Git repo i centralna dokumentacija projekta                            |
| Documentation | System Surface Map v1              | Done   | API, Tenant FE, Admin FE i Player FE površina su mapirani                                                       |
| Photos        | Photo/avatar pipeline              | Done   | Standardized `PersonThumb/usePersonPhoto/mediaStore` pipeline; legacy photo cache removed and manually verified |
| Player Portal | Aktivacija, deaktivacija i lozinka | Done   | Aktivacija, deaktivacija, reaktivacija i promjena lozinke su testirane                                          |
| Player Portal | Player FE osnovne stranice         | Done   | Profil, događaji, prisustvo i članarine su provjereni nakon player login-a                                      |

---

## In Progress

| Module        | Feature                       | Status      | Notes                                                                        |
| ------------- | ----------------------------- | ----------- | ---------------------------------------------------------------------------- |
| Documentation | Product Inventory v2.1        | In Progress | Inventory se usklađuje sa API, Tenant FE, Admin FE i Player FE surface mapom |
| Verification  | Module-by-module verification | In Progress | Sljedeće provjere idu redom: Staff, Teams, Documents, Contracts, itd.        |

---

## Next

| Priority | Module                      | Feature                               | Notes                                                                             |
| -------- | --------------------------- | ------------------------------------- | --------------------------------------------------------------------------------- |
| 1        | Staff                       | Verify Staff module                   | CRUD, photo, detail/edit, country/date logic, team staff assignment               |
| 2        | Teams                       | Verify Teams module                   | Team CRUD, player memberships, staff memberships, team attendance panel           |
| 3        | Documents                   | Verify Documents module               | Upload, download, replace, restore, purge, permissions                            |
| 4        | Contracts                   | Verify Contracts module               | Player contracts tab, CRUD, verify endpoint                                       |
| 5        | Player Medicals             | Verify medical records                | API, player detail tab, status/expiry behavior                                    |
| 6        | Player Registrations        | Verify registrations                  | API, player detail tab, permissions and flow                                      |
| 7        | Eligibility                 | Verify Eligibility Lite               | Eligibility endpoint, feature flag behavior, player detail integration            |
| 8        | Events                      | Verify Events lifecycle               | CRUD, cancel/complete, edit/delete rules, direct URL behavior                     |
| 9        | Attendance                  | Verify lock/read-only/statistics      | Lock only after event end; locked attendance read-only; stats from locked events  |
| 10       | Lineup                      | Verify MatchList / Lineup             | Lineup CRUD/display, lock/unlock, event detail subroute                           |
| 11       | Finance Fees                | Verify fee invoices/payments          | Charges, payments, status calculation, bulk ops, storno, export                   |
| 12       | Finance General             | Verify transactions/categories        | Transactions, categories, storno, export                                          |
| 13       | Users                       | Verify tenant users                   | Create/edit/activate/deactivate/set-password, permissions                         |
| 14       | Dashboard                   | Verify tenant dashboard               | Cards, counts, API data, permission behavior                                      |
| 15       | Settings / Lookups / Config | Verify system helper areas            | Tenant settings, lookups, photo config                                            |
| 16       | Admin Platform              | Verify Admin FE core and placeholders | Clubs/billing active; users/roles/audit/settings/seasons placeholders             |
| 17       | Platform Billing            | Verify platform billing               | Plans, subscriptions, invoices, invoice payments, standalone payments placeholder |
| 18       | Player FE cleanup           | Verify cleanup candidates             | Notifications mock, password reset route, role guards, duplicate/legacy files     |
| 19       | Dev Diagnostics / Meta      | Verify environment exposure           | Dev/debug endpoints, healthz, readyz                                              |

---

## Needs Verification

| Module               | Feature                        | What to verify                                                                                                |
| -------------------- | ------------------------------ | ------------------------------------------------------------------------------------------------------------- |
| Players              | Backend/API verification       | Verify backend endpoints, DB model, permissions and delete behavior                                           |
| Players              | Birth date auto-fill from JMBG | Primary `PlayerForm` create/edit flow should be checked; auto-fill currently appears only in older modal flow |
| Staff                | Staff module                   | CRUD, country select, date input, staff photo, team staff assignment                                          |
| Teams                | Team module                    | CRUD, team members, staff assignment, tenant scope                                                            |
| Documents            | Documents module               | Upload, download, replace, restore, purge, permissions                                                        |
| Contracts            | Contracts module               | CRUD, player detail tab, verify endpoint                                                                      |
| Player Medicals      | Medical records                | CRUD, player detail tab, status/expiry behavior                                                               |
| Player Registrations | Registrations                  | CRUD, player detail tab, permissions                                                                          |
| Eligibility          | Eligibility Lite               | Feature flag, endpoint behavior, player detail integration                                                    |
| Events               | Lifecycle rules                | Edit/delete behavior with lineup, draft attendance and locked attendance                                      |
| Attendance           | Lock rules                     | Lock only after event end, locked read-only, statistics from locked attendance                                |
| Lineup               | MatchList / Lineup             | Lineup display, staff candidates, lock/unlock behavior                                                        |
| Finance Fees         | Fee module                     | Charges, payments, status calculation, bulk ops, storno, export                                               |
| Finance General      | Transactions/categories        | CRUD, storno, export, category behavior                                                                       |
| Users                | Tenant users                   | Create/update/activate/deactivate/set-password, role/cap behavior                                             |
| Admin Platform       | Admin FE                       | Active clubs/billing screens and placeholder modules                                                          |
| Platform Billing     | Billing module                 | Plans, subscriptions, invoices, invoice payments, standalone payments placeholder                             |
| Player FE            | Cleanup items                  | Notifications mock, missing password-reset route, duplicated role guards, legacy files                        |
| Dev Diagnostics      | Dev/system endpoints           | Confirm dev/debug endpoints are not exposed where they should not be                                          |

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

1. Završiti i commitati `clubmanager-inventory.md` v2.1
2. Nastaviti module-by-module verification
3. Prvi sljedeći modul za audit: `Staff`
4. Nakon svake provjere ažurirati:
   - `clubmanager-inventory.md`
   - `module-status.md`
   - po potrebi `system-surface-map.md`

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
