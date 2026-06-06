# ClubManager Product Inventory

Ovaj dokument prati stvarno stanje ClubManager modula i funkcionalnosti.

Inventory se ne potvrđuje iz sjećanja. Svaka stavka se potvrđuje kroz jedan ili više izvora:

- FE ruta / ekran
- API endpoint
- baza / model
- permission / capability
- ručni test u aplikaciji
- DEV/STAGE stanje

Povezani dokument:

```text
docs/product/system-surface-map.md
```

---

## Status legenda

| Status        | Značenje                                                                 |
| ------------- | ------------------------------------------------------------------------ |
| Planned       | Dogovoreno, ali nije implementirano                                      |
| Backend only  | Backend/API postoji, frontend nije završen                               |
| Frontend only | UI postoji, backend nije povezan ili nije potvrđen                       |
| Implemented   | Kod postoji i osnovno radi                                               |
| Verified      | Funkcionalnost je provjerena kroz aplikaciju                             |
| Polished      | Funkcionalnost je testirana, UX sređen i spremna je za normalnu upotrebu |
| Needs cleanup | Radi ili djelimično radi, ali ima tehničkog/UX duga                      |
| Deprecated    | Postojalo je, ali se više ne koristi                                     |

---

## Inventory tabela

| Module               | Feature                          | BE      | FE       | DB      | Tested  | Status          | Notes                                                                                    |
| -------------------- | -------------------------------- | ------- | -------- | ------- | ------- | --------------- | ---------------------------------------------------------------------------------------- |
| Documentation        | Central docs repository          | N/A     | N/A      | N/A     | Yes     | Verified        | `/home/kemo/ClubManager/docs` je poseban Git repo                                        |
| System Map           | System Surface Map               | Yes     | Yes      | N/A     | Partial | Implemented     | API i Tenant FE površina su mapirani                                                     |
| Auth                 | Login                            | Yes     | Yes      | Yes     | Partial | Implemented     | `/api/auth/login`, `/login`                                                              |
| Auth                 | Password reset                   | Yes     | Yes      | Yes     | Partial | Implemented     | `/api/auth/password/reset`, `/password-reset`                                            |
| Account              | Change password                  | Yes     | Yes      | Yes     | Partial | Implemented     | `/api/account/change-password`, `/settings/password`                                     |
| Dashboard            | Tenant dashboard                 | Yes     | Yes      | Yes     | Partial | Implemented     | `/dashboard`, `/api/dashboard`                                                           |
| Clubs                | Current club profile             | Yes     | Partial  | Yes     | Partial | Implemented     | `/api/clubs/me`, summary i logo endpointi                                                |
| Club Branding        | Club logo                        | Yes     | Partial  | Yes     | Partial | Implemented     | Tenant FE i Player FE koriste club logo endpoint-e                                       |
| Photos               | Photo/avatar pipeline            | Yes     | Yes      | Yes     | Yes     | Polished        | Standardizovan `PersonThumb/usePersonPhoto/mediaStore` pipeline                          |
| Players              | Player CRUD                      | Partial | Yes      | Partial | Partial | Implemented     | FE list/create/edit/detail/delete postoje; BE/DB treba formalno provjeriti               |
| Players              | JMBG validation                  | Partial | Yes      | N/A     | Partial | Implemented     | Postoji u `PlayerForm` i starijem modal flow-u                                           |
| Players              | Birth date auto-fill from JMBG   | N/A     | Partial  | N/A     | Partial | Needs cleanup   | Postoji u starijem modal flow-u, ali ne u primarnom `PlayerForm` toku                    |
| Players              | Player detail profile            | Partial | Yes      | Partial | Partial | Implemented     | Tabovi postoje za registracije, ljekarske, ugovore, dokumente, ekipe, članarine i portal |
| Players              | Player photo                     | Yes     | Yes      | Yes     | Yes     | Polished        | Koristi verificirani photo pipeline                                                      |
| Player Portal        | Portal activation from Tenant FE | Yes     | Yes      | Yes     | Yes     | Verified        | Portal lifecycle je testiran                                                             |
| Player Portal        | Player profile endpoint          | Yes     | Yes      | Yes     | Yes     | Verified        | `/api/player/me` provjeren nakon player login-a                                          |
| Player Portal        | Player events                    | Yes     | Yes      | Yes     | Yes     | Verified        | `/api/player/events` provjeren u Player FE                                               |
| Player Portal        | Player attendance                | Yes     | Yes      | Yes     | Yes     | Verified        | `/api/player/attendance` provjeren u Player FE                                           |
| Player Portal        | Player finance                   | Yes     | Yes      | Yes     | Yes     | Verified        | `/api/player/finance` provjeren u Player FE                                              |
| Player Portal        | Player club logo                 | Yes     | Partial  | Yes     | Partial | Implemented     | `/api/player/me/club-logo` postoji; završna UX provjera čeka                             |
| Player Portal        | Player profile photo             | Yes     | Partial  | Yes     | Partial | Implemented     | `/api/player/profile/photo` postoji; završna UX provjera čeka                            |
| Staff                | Staff CRUD                       | Yes     | Yes      | Yes     | Partial | Implemented     | List/detail/edit rute postoje; puna ručna provjera čeka                                  |
| Staff                | Staff photo                      | Yes     | Yes      | Yes     | Partial | Implemented     | Koristi verificirani photo pipeline; puna staff workflow provjera čeka                   |
| Teams                | Team CRUD                        | Yes     | Yes      | Yes     | Partial | Implemented     | Rute i API postoje                                                                       |
| Teams                | Player memberships               | Yes     | Yes      | Yes     | Partial | Implemented     | Team membership endpointi i paneli postoje                                               |
| Teams                | Staff memberships                | Yes     | Yes      | Yes     | Partial | Implemented     | Team staff membership endpointi i paneli postoje                                         |
| Teams                | Team attendance panel            | Yes     | Yes      | Yes     | Partial | Implemented     | Postoji unutar team detail/panela                                                        |
| Events               | Event CRUD                       | Yes     | Yes      | Yes     | Partial | Implemented     | Rute i API postoje                                                                       |
| Events               | Event status lifecycle           | Yes     | Yes      | Yes     | Partial | Needs cleanup   | Cancel/complete/edit/delete pravila treba provjeriti                                     |
| Attendance           | Event attendance                 | Yes     | Yes      | Yes     | Partial | Implemented     | Event attendance API i UI postoje                                                        |
| Attendance           | Attendance lock/unlock           | Yes     | Yes      | Yes     | Partial | Needs cleanup   | Lock/read-only pravila treba provjeriti                                                  |
| Attendance           | Team attendance statistics       | Yes     | Yes      | Yes     | Partial | Needs cleanup   | Statistika treba koristiti samo locked attendance                                        |
| Lineup               | MatchList / lineup               | Yes     | Yes      | Yes     | Partial | Implemented     | Event lineup API i UI postoje                                                            |
| Lineup               | Lineup lock/unlock               | Yes     | Yes      | Yes     | Partial | Needs cleanup   | Lock/unlock workflow treba provjeriti                                                    |
| Documents            | Documents module                 | Yes     | Yes      | Yes     | Partial | Implemented     | Upload/download/replace/restore/purge API postoji                                        |
| Documents            | Player documents tab             | Yes     | Yes      | Yes     | Partial | Implemented     | Postoji unutar player detail-a                                                           |
| Contracts            | Contracts module                 | Yes     | Yes      | Yes     | Partial | Implemented     | API i player detail tab postoje                                                          |
| Contracts            | Contract verification            | Yes     | Partial  | Yes     | No      | Backend only    | `/api/contracts/{id}/verify` postoji                                                     |
| Player Medicals      | Player medical records           | Yes     | Yes      | Yes     | Partial | Implemented     | API i player detail tab postoje                                                          |
| Player Registrations | Player registrations             | Yes     | Yes      | Yes     | Partial | Implemented     | API i player detail tab postoje                                                          |
| Eligibility          | Eligibility Lite                 | Yes     | Yes      | Yes     | Partial | Implemented     | `/api/eligibility/players/{playerId}` postoji                                            |
| Eligibility          | Eligibility PRO                  | No      | No       | No      | No      | Planned         | Premium compliance logika                                                                |
| Finance Fees         | Fee invoices                     | Yes     | Yes      | Yes     | Partial | In progress     | Fees page/API postoji; šira provjera čeka                                                |
| Finance Fees         | Fee payments                     | Yes     | Yes      | Yes     | Partial | In progress     | Payment i storno endpointi postoje                                                       |
| Finance Fees         | Bulk fee operations              | Yes     | Yes      | Yes     | Partial | In progress     | Wizard preview, bulk create i bulk pay postoje                                           |
| Finance Fees         | Fee exports                      | Yes     | Partial  | Yes     | No      | Implemented     | Export endpointi postoje; UX provjera čeka                                               |
| Finance General      | Finance categories               | Yes     | Yes      | Yes     | Partial | Implemented     | `/finance/categories`, `/api/fin/categories`                                             |
| Finance General      | Finance transactions             | Yes     | Yes      | Yes     | Partial | Implemented     | `/finance/transactions`, `/api/fin/transactions`                                         |
| Finance General      | Transaction storno/export        | Yes     | Partial  | Yes     | Partial | Implemented     | API postoji; workflow provjera čeka                                                      |
| Users                | Tenant users management          | Yes     | Yes      | Yes     | Partial | Implemented     | `/users`, activate/deactivate/set-password endpointi                                     |
| Settings             | Tenant settings                  | Yes     | Partial  | Yes     | No      | Implemented     | `/api/settings` postoji                                                                  |
| Lookups              | Lookup values                    | Yes     | Used     | N/A     | Partial | Implemented     | `/api/lookups`, `/api/lookups/{key}`                                                     |
| Config               | Photo config                     | Yes     | Yes      | N/A     | Partial | Implemented     | `/api/config/photo` koristi se za upload/profile config                                  |
| Seasons              | Tenant seasons                   | Yes     | Partial  | Yes     | No      | Implemented     | `/api/seasons`, `/api/seasons/default`                                                   |
| Admin Platform       | Admin clubs                      | Yes     | Admin FE | Yes     | No      | Implemented     | Admin API postoji; Admin FE provjera čeka                                                |
| Admin Platform       | Admin club users                 | Yes     | Admin FE | Yes     | No      | Implemented     | Admin API postoji                                                                        |
| Admin Platform       | Admin users                      | Yes     | Admin FE | Yes     | No      | Implemented     | Admin API postoji                                                                        |
| Admin Platform       | Roles                            | Yes     | Admin FE | Yes     | No      | Implemented     | `/api/admin/roles`                                                                       |
| Admin Platform       | Feature toggles                  | Yes     | Admin FE | Yes     | Partial | Implemented     | `/api/admin/clubs/{clubId}/features`                                                     |
| Admin Platform       | Admin settings                   | Yes     | Admin FE | Yes     | No      | Implemented     | `/api/admin/settings`                                                                    |
| Admin Platform       | Admin audit                      | Yes     | Admin FE | Yes     | No      | Implemented     | `/api/admin/audit`                                                                       |
| Platform Billing     | Plans                            | Yes     | Admin FE | Yes     | No      | Implemented     | Admin API postoji                                                                        |
| Platform Billing     | Subscriptions                    | Yes     | Admin FE | Yes     | No      | Implemented     | Admin API postoji                                                                        |
| Platform Billing     | Admin invoices                   | Yes     | Admin FE | Yes     | No      | Implemented     | Admin API postoji                                                                        |
| Platform Billing     | Admin payments                   | Yes     | Admin FE | Yes     | No      | Implemented     | Admin API postoji                                                                        |
| Reports              | Reports module                   | Partial | Partial  | Partial | No      | Planned/Partial | `ViewReports` cap postoji, ali usage nije jasan                                          |
| Notifications        | Notifications                    | No      | UI-only  | No      | No      | Planned         | Topbar dugme postoji, nema potvrđene akcije                                              |
| Help                 | Help / support UI                | No      | UI-only  | No      | No      | Planned         | Topbar dugme postoji, nema potvrđene akcije                                              |
| Global Search        | Global search                    | No      | UI-only  | No      | No      | Planned         | Topbar input postoji, nema potvrđenog search ponašanja                                   |
| Dev Diagnostics      | Dev/debug endpoints              | Yes     | N/A      | N/A     | No      | Implemented     | Mora ostati dev-only; provjeriti produkcijsku izloženost                                 |
| Meta                 | Health/readiness endpoints       | Yes     | N/A      | N/A     | Partial | Implemented     | `/healthz`, `/readyz`                                                                    |

---

## Module notes

### Photos — Photo/avatar pipeline

Status: `Polished`

Trenutni standard:

```text
PersonThumb
usePersonPhoto
mediaStore
secure API endpoint
```

Potvrđeno:

- `PersonThumb` je standardna avatar komponenta.
- `usePersonPhoto` je standardni hook za učitavanje fotografija.
- `mediaStore` je centralni cache/load/invalidation helper.
- `PhotoUploadModal` je zajednički upload/delete UI za players i staff.
- `PlayerDetailPage` i `StaffDetailPage` koriste `PersonThumb`.
- `PlayerEditPage` i `StaffEditPage` direct delete pozivaju `invalidatePersonPhoto`.
- `person-photo-updated` event se dispatchuje nakon brisanja fotografije.
- legacy `fetchSecurePhoto.ts` je uklonjen.
- legacy `photoCache.ts` je uklonjen.
- TypeScript check prolazi.
- Ručni test player/staff list-detail-edit upload/delete je prošao.

Preostalo:

- komentarisani legacy photo blokovi mogu se kasnije očistiti ako budu smetali pretrazi.

---

### Player Portal — CORE flow

Status: `Verified`

Potvrđeno:

- korisnik kluba može aktivirati Player Portal za igrača.
- aktivacija kreira povezani korisnički račun ako on ne postoji.
- aktivacija reaktivira postojeći povezani korisnički račun ako već postoji.
- deaktivacija postavlja korisnički račun kao neaktivan.
- deaktivacija ne briše korisnika.
- deaktivacija ne uklanja Player rolu.
- deaktivacija ne briše `players.user_id`.
- promjena lozinke radi.
- igrač se može prijaviti na Player FE.
- Player FE dashboard se učitava nakon prijave.
- Player profil, događaji, prisustvo i članarine su provjereni.

Backend ponašanje:

- `players.user_id` povezuje igrača sa portal korisničkim računom.
- `users.email` je email za prijavu na Player Portal.
- `players.email` je kontakt email igrača.
- ova dva emaila su namjerno odvojena i ne moraju biti ista.
- reaktivacija koristi isti activate endpoint.
- reaktivacija postavlja `users.is_active = true`.
- reaktivacija može ažurirati portal login email i lozinku.

Potrebna API dorada:

- kod reaktivacije, ako se mijenja portal email, backend treba provjeriti da novi email već ne koristi drugi korisnik.
- nova aktivacija već provjerava jedinstvenost emaila, ali reaktivacija treba imati istu zaštitu za `users.email`.

---

### Players — trenutni rezultat verifikacije

Status: `Implemented`

Potvrđeno iz Tenant FE audita:

- player list route postoji.
- player create route postoji.
- player edit route postoji.
- player detail route postoji.
- delete flow postoji u FE.
- JMBG validacija postoji.
- player detail tabovi postoje.
- player photo koristi verificirani photo pipeline.

Potrebna provjera / cleanup:

- backend source nije provjeren u ovom auditu.
- DB model nije provjeren u ovom auditu.
- postoje dva create flow-a: routed `PlayerCreatePage` i stariji modal create u `PlayersPage`.
- birth date auto-fill iz JMBG-a postoji u starijem modal create flow-u, ali ne u primarnom `PlayerForm`.
- `PlayerCreatePage` još sadrži DEV marker / `console.log`.
- `PlayersPage` lista koristi lokalni thumb wrapper sa `usePersonPhoto`; ponašanje je standardno, ali wrapper nije `PersonThumb`.

---

### Finance — trenutno razdvajanje

Finance treba tretirati kao najmanje dvije različite proizvodne oblasti.

#### Finance Fees

Pokriva:

- fee invoices
- fee payments
- bulk create
- bulk pay
- payment storno
- fee summary
- fee export
- player fee summary

#### General Finance

Pokriva:

- finance categories
- finance transactions
- transaction storno
- transaction export

Trenutni status:

```text
In progress / needs structured verification
```

---

### Admin / Platform Billing

Admin API surface pokazuje da ClubManager ima stvaran platform billing sloj.

Uključuje:

- plans
- subscriptions
- admin invoices
- admin payments
- ops/finalize

Ovo se ne smije miješati sa tenant finance modulom.

Trenutni status:

```text
Implemented at API surface level; Admin FE verification pending
```

---

### Inventory hygiene / cleanup candidates

Ovo nisu hitne korekcije, ali moraju ostati vidljive.

| Area        | Candidate                                                                 |
| ----------- | ------------------------------------------------------------------------- |
| Players     | duplicate create flow                                                     |
| Players     | JMBG auto-fill missing from primary `PlayerForm`                          |
| Players     | DEV marker / `console.log` in `PlayerCreatePage`                          |
| Events      | `EventAttendancePage.tsx` exists but is not routed                        |
| Finance     | `FinanceTransactionsPage.tsx` exists but route uses `FinTransactionsPage` |
| Finance     | endpoint naming is split across `finance`, `fin`, and `fees`              |
| Topbar      | `Pomoć`, `Obavijesti`, global search are UI-only                          |
| Permissions | `ViewReports` usage unclear                                               |
| Permissions | `ManageRegistrations` usage unclear                                       |
| Dev         | dev/debug endpoints should be checked for environment exposure            |

---

## Verification status summary

| Module                | Current status                   |
| --------------------- | -------------------------------- |
| Documentation         | Verified                         |
| System Surface Map    | Implemented                      |
| Photo/avatar pipeline | Polished                         |
| Player Portal CORE    | Verified                         |
| Players               | Implemented                      |
| Staff                 | Implemented                      |
| Teams                 | Implemented                      |
| Events                | Implemented / Needs cleanup      |
| Attendance            | Implemented / Needs cleanup      |
| Lineup                | Implemented / Needs cleanup      |
| Documents             | Implemented                      |
| Contracts             | Implemented                      |
| Medicals              | Implemented                      |
| Registrations         | Implemented                      |
| Eligibility Lite      | Implemented                      |
| Finance Fees          | In progress                      |
| General Finance       | Implemented / needs verification |
| Tenant Users          | Implemented                      |
| Admin Platform        | Implemented / needs verification |
| Platform Billing      | Implemented / needs verification |
| Reports               | Planned/Partial                  |
| Notifications         | Planned                          |
| Help                  | Planned                          |
| Global Search         | Planned                          |

---

## Next verification targets

Preporučeni redoslijed:

| Priority | Module                      |
| -------- | --------------------------- |
| 1        | Staff                       |
| 2        | Teams                       |
| 3        | Documents                   |
| 4        | Contracts                   |
| 5        | Player medicals             |
| 6        | Player registrations        |
| 7        | Eligibility                 |
| 8        | Events                      |
| 9        | Attendance                  |
| 10       | MatchList / Lineup          |
| 11       | Finance Fees                |
| 12       | General Finance             |
| 13       | Users                       |
| 14       | Dashboard                   |
| 15       | Settings / lookups / config |
| 16       | Admin Platform              |
| 17       | Platform Billing            |
| 18       | Dev/system endpoints        |
