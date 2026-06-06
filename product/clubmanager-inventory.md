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

## Osnovna mapa aplikacije

```text
ClubManager
├── 1. Platform / System
│   ├── Documentation
│   ├── System Map
│   ├── Auth / Account
│   ├── Settings
│   ├── Lookups / Config
│   ├── Meta / Health
│   └── Dev diagnostics
│
├── 2. Tenant App / Club Operations
│   ├── Dashboard
│   ├── Club profile / branding
│   ├── Users
│   ├── People
│   │   ├── Players
│   │   │   ├── Core profile
│   │   │   ├── JMBG / validation
│   │   │   ├── Photo
│   │   │   ├── Registrations
│   │   │   ├── Medicals
│   │   │   ├── Documents
│   │   │   ├── Contracts
│   │   │   ├── Teams
│   │   │   ├── Fees
│   │   │   └── Player Portal activation
│   │   │
│   │   └── Staff
│   │       ├── Core profile
│   │       ├── Photo
│   │       ├── Validation
│   │       └── Team assignments
│   │
│   ├── Teams
│   │   ├── Team CRUD
│   │   ├── Player memberships
│   │   ├── Staff memberships
│   │   └── Team attendance panel
│   │
│   ├── Events
│   │   ├── Event CRUD
│   │   ├── Event lifecycle
│   │   ├── Attendance
│   │   │   ├── Event attendance
│   │   │   ├── Lock / unlock
│   │   │   └── Team attendance statistics
│   │   └── Lineup / MatchList
│   │       ├── MatchList / lineup
│   │       └── Lineup lock / unlock
│   │
│   ├── Finance
│   │   ├── Fees / Članarine
│   │   │   ├── Fee invoices
│   │   │   ├── Fee payments
│   │   │   ├── Bulk operations
│   │   │   ├── Storno
│   │   │   └── Export
│   │   │
│   │   └── General Finance
│   │       ├── Categories
│   │       ├── Transactions
│   │       ├── Storno
│   │       └── Export
│   │
│   ├── Documents Engine
│   ├── Eligibility
│   └── Reports
│
├── 3. Player Portal App
│   ├── Login / player guard
│   ├── Dashboard
│   ├── Profile
│   ├── Events
│   ├── Attendance
│   ├── Finance / članarine
│   ├── Club logo
│   ├── Profile photo
│   ├── Notifications
│   └── Password reset
│
├── 4. Admin App / Platform Management
│   ├── Admin login / role gate
│   ├── Clubs
│   ├── Club details
│   ├── Club logo
│   ├── Club users
│   ├── Feature toggles
│   ├── Admin users
│   ├── Roles
│   ├── Audit
│   ├── Settings
│   └── Seasons
│
├── 5. Platform Billing
│   ├── Plans
│   ├── Subscriptions
│   ├── Admin invoices
│   ├── Invoice payments
│   ├── Standalone payments
│   └── Ops / finalize
│
└── 6. Planned / UI-only / Cleanup
    ├── Notifications
    ├── Help
    ├── Global Search
    ├── Duplicate flows
    ├── Placeholder pages
    ├── Legacy files
    └── Permission/capability gaps
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

| Area                        | Domain            | Module               | Feature                          | BE      | FE          | DB      | Tested  | Status          | Notes                                                                                       |
| --------------------------- | ----------------- | -------------------- | -------------------------------- | ------- | ----------- | ------- | ------- | --------------- | ------------------------------------------------------------------------------------------- |
| Platform / System           | Documentation     | Documentation        | Central docs repository          | N/A     | N/A         | N/A     | Yes     | Verified        | `/home/kemo/ClubManager/docs` je poseban Git repo                                           |
| Platform / System           | Documentation     | System Map           | System Surface Map v1            | Yes     | Yes         | N/A     | Yes     | Verified        | API, Tenant FE, Admin FE i Player FE površina su mapirani; DB surface pending               |
| Platform / System           | Auth / Account    | Auth                 | Login                            | Yes     | Yes         | Yes     | Partial | Implemented     | `/api/auth/login`, `/login`                                                                 |
| Platform / System           | Auth / Account    | Auth                 | Password reset                   | Yes     | Yes         | Yes     | Partial | Implemented     | `/api/auth/password/reset`, `/password-reset`                                               |
| Platform / System           | Auth / Account    | Account              | Change password                  | Yes     | Yes         | Yes     | Partial | Implemented     | `/api/account/change-password`, `/settings/password`                                        |
| Platform / System           | Settings / Config | Settings             | Tenant settings                  | Yes     | Partial     | Yes     | No      | Implemented     | `/api/settings` postoji                                                                     |
| Platform / System           | Settings / Config | Lookups              | Lookup values                    | Yes     | Used        | N/A     | Partial | Implemented     | `/api/lookups`, `/api/lookups/{key}`                                                        |
| Platform / System           | Settings / Config | Config               | Photo config                     | Yes     | Yes         | N/A     | Partial | Implemented     | `/api/config/photo` koristi se za upload/profile config                                     |
| Platform / System           | Seasons           | Seasons              | Tenant seasons                   | Yes     | Partial     | Yes     | No      | Implemented     | `/api/seasons`, `/api/seasons/default`                                                      |
| Platform / System           | Dev / Meta        | Dev Diagnostics      | Dev/debug endpoints              | Yes     | N/A         | N/A     | No      | Implemented     | Mora ostati dev-only; provjeriti produkcijsku izloženost                                    |
| Platform / System           | Dev / Meta        | Meta                 | Health/readiness endpoints       | Yes     | N/A         | N/A     | Partial | Implemented     | `/healthz`, `/readyz`                                                                       |
| Tenant App                  | Club              | Dashboard            | Tenant dashboard                 | Yes     | Yes         | Yes     | Partial | Implemented     | `/dashboard`, `/api/dashboard`                                                              |
| Tenant App                  | Club              | Clubs                | Current club profile             | Yes     | Partial     | Yes     | Partial | Implemented     | `/api/clubs/me`, summary i logo endpointi                                                   |
| Tenant App                  | Club              | Club Branding        | Club logo                        | Yes     | Partial     | Yes     | Partial | Implemented     | Tenant FE i Player FE koriste club logo endpoint-e                                          |
| Tenant App                  | Club              | Users                | Tenant users management          | Yes     | Yes         | Yes     | Partial | Implemented     | `/users`, activate/deactivate/set-password endpointi                                        |
| Tenant App                  | People            | Players              | Player CRUD                      | Partial | Yes         | Partial | Partial | Implemented     | FE list/create/edit/detail/delete postoje; BE/DB treba formalno provjeriti                  |
| Tenant App                  | People            | Players              | JMBG validation                  | Partial | Yes         | N/A     | Partial | Implemented     | Postoji u `PlayerForm` i starijem modal flow-u                                              |
| Tenant App                  | People            | Players              | Birth date auto-fill from JMBG   | N/A     | Partial     | N/A     | Partial | Needs cleanup   | Postoji u starijem modal flow-u, ali ne u primarnom `PlayerForm` toku                       |
| Tenant App                  | People            | Players              | Player detail profile            | Partial | Yes         | Partial | Partial | Implemented     | Tabovi postoje za registracije, ljekarske, ugovore, dokumente, ekipe, članarine i portal    |
| Tenant App                  | People            | Players              | Player photo                     | Yes     | Yes         | Yes     | Yes     | Polished        | Koristi verificirani photo pipeline                                                         |
| Tenant App                  | People / Players  | Player Registrations | Player registrations             | Yes     | Yes         | Yes     | Partial | Implemented     | API i player detail tab postoje                                                             |
| Tenant App                  | People / Players  | Player Medicals      | Player medical records           | Yes     | Yes         | Yes     | Partial | Implemented     | API i player detail tab postoje                                                             |
| Tenant App                  | People / Players  | Documents            | Player documents tab             | Yes     | Yes         | Yes     | Partial | Implemented     | Postoji unutar player detail-a                                                              |
| Tenant App                  | People / Players  | Contracts            | Contracts module                 | Yes     | Yes         | Yes     | Partial | Implemented     | API i player detail tab postoje                                                             |
| Tenant App                  | People / Players  | Contracts            | Contract verification            | Yes     | Partial     | Yes     | No      | Backend only    | `/api/contracts/{id}/verify` postoji                                                        |
| Tenant App                  | People / Players  | Eligibility          | Eligibility Lite                 | Yes     | Yes         | Yes     | Partial | Implemented     | `/api/eligibility/players/{playerId}` postoji                                               |
| Tenant App                  | People / Players  | Eligibility          | Eligibility PRO                  | No      | No          | No      | No      | Planned         | Premium compliance logika                                                                   |
| Tenant App                  | People / Players  | Player Portal        | Portal activation from Tenant FE | Yes     | Yes         | Yes     | Yes     | Verified        | Portal lifecycle je testiran                                                                |
| Tenant App                  | People            | Staff                | Staff CRUD                       | Yes     | Yes         | Yes     | Partial | Needs cleanup   | List/create/edit/detail/delete postoje, ali create/edit tokovi i permisije trebaju provjeru |
| Tenant App                  | People            | Staff                | Staff photo                      | Yes     | Yes         | Yes     | Partial | Implemented     | Koristi verificirani photo pipeline; upload/delete workflow treba ručno provjeriti          |
| Tenant App                  | People            | Staff                | Staff detail profile             | Yes     | Yes         | Yes     | Partial | Implemented     | Detail profil postoji; team assignment sekcija u staff detail-u je placeholder              |
| Tenant App                  | People            | Staff                | Staff form validation            | Yes     | Yes         | N/A     | Partial | Needs cleanup   | Quick create i edit forma imaju različit nivo polja i različit UX validacije                |
| Tenant App                  | Teams             | Teams                | Team CRUD                        | Yes     | Yes         | Yes     | Partial | Implemented     | Rute i API postoje                                                                          |
| Tenant App                  | Teams             | Team Memberships     | Player memberships               | Yes     | Yes         | Yes     | Partial | Implemented     | Team membership endpointi i paneli postoje                                                  |
| Tenant App                  | Teams             | Team Memberships     | Staff memberships                | Yes     | Yes         | Yes     | Partial | Implemented     | Add/edit/remove staff membership flow postoji kroz Team detail                              |
| Tenant App                  | Teams             | Team Attendance      | Team attendance panel            | Yes     | Yes         | Yes     | Partial | Implemented     | Postoji unutar team detail/panela                                                           |
| Tenant App                  | Events            | Event Core           | Event CRUD                       | Yes     | Yes         | Yes     | Partial | Implemented     | Rute i API postoje                                                                          |
| Tenant App                  | Events            | Event Core           | Event status lifecycle           | Yes     | Yes         | Yes     | Partial | Needs cleanup   | Cancel/complete/edit/delete pravila treba provjeriti                                        |
| Tenant App                  | Events            | Attendance           | Event attendance                 | Yes     | Yes         | Yes     | Partial | Implemented     | Event attendance API i UI postoje                                                           |
| Tenant App                  | Events            | Attendance           | Attendance lock/unlock           | Yes     | Yes         | Yes     | Partial | Needs cleanup   | Lock/read-only pravila treba provjeriti                                                     |
| Tenant App                  | Events            | Attendance           | Team attendance statistics       | Yes     | Yes         | Yes     | Partial | Needs cleanup   | Statistika treba koristiti samo locked attendance                                           |
| Tenant App                  | Events            | Lineup / MatchList   | MatchList / lineup               | Yes     | Yes         | Yes     | Partial | Implemented     | Event lineup API i UI postoje                                                               |
| Tenant App                  | Events            | Lineup / MatchList   | Lineup lock/unlock               | Yes     | Yes         | Yes     | Partial | Needs cleanup   | Lock/unlock workflow treba provjeriti                                                       |
| Tenant App                  | Finance           | Fees / Članarine     | Fee invoices                     | Yes     | Yes         | Yes     | Partial | In progress     | Fees page/API postoji; šira provjera čeka                                                   |
| Tenant App                  | Finance           | Fees / Članarine     | Fee payments                     | Yes     | Yes         | Yes     | Partial | In progress     | Payment i storno endpointi postoje                                                          |
| Tenant App                  | Finance           | Fees / Članarine     | Bulk fee operations              | Yes     | Yes         | Yes     | Partial | In progress     | Wizard preview, bulk create i bulk pay postoje                                              |
| Tenant App                  | Finance           | Fees / Članarine     | Fee exports                      | Yes     | Partial     | Yes     | No      | Implemented     | Export endpointi postoje; UX provjera čeka                                                  |
| Tenant App                  | Finance           | General Finance      | Finance categories               | Yes     | Yes         | Yes     | Partial | Implemented     | `/finance/categories`, `/api/fin/categories`                                                |
| Tenant App                  | Finance           | General Finance      | Finance transactions             | Yes     | Yes         | Yes     | Partial | Implemented     | `/finance/transactions`, `/api/fin/transactions`                                            |
| Tenant App                  | Finance           | General Finance      | Transaction storno/export        | Yes     | Partial     | Yes     | Partial | Implemented     | API postoji; workflow provjera čeka                                                         |
| Tenant App                  | Documents         | Documents Engine     | Documents module                 | Yes     | Yes         | Yes     | Partial | Implemented     | Upload/download/replace/restore/purge API postoji                                           |
| Tenant App                  | Reports           | Reports              | Reports module                   | Partial | Partial     | Partial | No      | Planned/Partial | `ViewReports` cap postoji, ali usage nije jasan                                             |
| Tenant App                  | Shared UI         | Photos               | Photo/avatar pipeline            | Yes     | Yes         | Yes     | Yes     | Polished        | Standardizovan `PersonThumb/usePersonPhoto/mediaStore` pipeline                             |
| Player Portal App           | Portal Core       | Player Portal        | Player profile endpoint          | Yes     | Yes         | Yes     | Yes     | Verified        | `/api/player/me` provjeren nakon player login-a                                             |
| Player Portal App           | Portal Core       | Player Portal        | Player events                    | Yes     | Yes         | Yes     | Yes     | Verified        | `/api/player/events` provjeren u Player FE                                                  |
| Player Portal App           | Portal Core       | Player Portal        | Player attendance                | Yes     | Yes         | Yes     | Yes     | Verified        | `/api/player/attendance` provjeren u Player FE                                              |
| Player Portal App           | Portal Core       | Player Portal        | Player finance                   | Yes     | Yes         | Yes     | Yes     | Verified        | `/api/player/finance` provjeren u Player FE                                                 |
| Player Portal App           | Portal Core       | Player Portal        | Player club logo                 | Yes     | Partial     | Yes     | Partial | Implemented     | `/api/player/me/club-logo` postoji; završna UX provjera čeka                                |
| Player Portal App           | Portal Core       | Player Portal        | Player profile photo             | Yes     | Partial     | Yes     | Partial | Implemented     | `/api/player/profile/photo` postoji; završna UX provjera čeka                               |
| Player Portal App           | App Shell         | Player FE            | Player app shell                 | Yes     | Yes         | Yes     | Partial | Implemented     | Protected shell, PlayerAuthGuard, PlayerBoot i PlayerLayout postoje                         |
| Player Portal App           | App Shell         | Player FE            | Player dashboard                 | Yes     | Yes         | Yes     | Yes     | Verified        | Dashboard je ručno provjeren nakon player login-a                                           |
| Player Portal App           | App Shell         | Player FE            | Player profile page              | Yes     | Yes         | Yes     | Yes     | Verified        | Profile page postoji i učitava player podatke                                               |
| Player Portal App           | Events            | Player FE            | Player event detail              | Yes     | Yes         | Yes     | Partial | Implemented     | Ruta `/events/:id` postoji; završna manual detail provjera ostaje                           |
| Player Portal App           | Notifications     | Player FE            | Player notifications             | No      | Mock        | No      | No      | Planned         | Notifications page postoji, ali koristi mock podatke                                        |
| Player Portal App           | Auth / Access     | Player FE            | Password reset route             | Yes     | Missing     | Yes     | No      | Needs cleanup   | Login link vodi na `/password-reset`, ali ruta ne postoji u Player FE                       |
| Player Portal App           | Auth / Access     | Player FE            | Role guard consistency           | Yes     | Yes         | N/A     | Partial | Needs cleanup   | `ProtectedRoute` i `PlayerAuthGuard` imaju duplu/nedosljednu role provjeru                  |
| Player Portal App           | Profile           | Player FE            | Profile photo display            | Yes     | Yes         | Yes     | Partial | Implemented     | Koristi `usePersonPhoto`, ali ne standardni `PersonThumb` wrapper                           |
| Player Portal App           | Cleanup           | Player FE            | Cleanup / legacy files           | N/A     | Yes         | N/A     | No      | Needs cleanup   | Postoje duplicate/legacy fajlovi u player-fe                                                |
| Admin App                   | Access            | Admin Platform       | Admin login / role gate          | Yes     | Yes         | Yes     | Partial | Implemented     | Admin FE ima login i admin-only route protection                                            |
| Admin App                   | Dashboard         | Admin Platform       | Admin dashboard                  | No      | Placeholder | N/A     | No      | Planned         | Ruta postoji, ekran je placeholder                                                          |
| Admin App                   | Clubs             | Admin Platform       | Club management                  | Yes     | Yes         | Yes     | Partial | Implemented     | Clubs list/detail/create/edit su aktivni                                                    |
| Admin App                   | Clubs             | Admin Platform       | Club details                     | Yes     | Yes         | Yes     | Partial | Implemented     | `ClubDetailsPage` postoji                                                                   |
| Admin App                   | Clubs             | Admin Platform       | Club logo management             | Yes     | Yes         | Yes     | Partial | Implemented     | Admin FE koristi club logo upload/delete/display                                            |
| Admin App                   | Clubs             | Admin Platform       | Club users                       | Yes     | Yes         | Yes     | Partial | Implemented     | Club users i set password modal su aktivni                                                  |
| Admin App                   | Clubs             | Admin Platform       | Feature toggles                  | Yes     | Yes         | Yes     | Partial | Implemented     | Club feature toggles su aktivni                                                             |
| Admin App                   | Users / Roles     | Admin Platform       | Admin users page                 | Yes     | Placeholder | Yes     | No      | Planned/Partial | API postoji, FE ruta je placeholder                                                         |
| Admin App                   | Users / Roles     | Admin Platform       | Roles page                       | Yes     | Placeholder | Yes     | No      | Planned/Partial | API postoji, FE ruta je placeholder                                                         |
| Admin App                   | System            | Admin Platform       | Audit page                       | Yes     | Placeholder | Yes     | No      | Planned/Partial | API postoji, FE ruta je placeholder                                                         |
| Admin App                   | System            | Admin Platform       | Settings page                    | Yes     | Placeholder | Yes     | No      | Planned/Partial | API postoji, FE ruta je placeholder                                                         |
| Admin App                   | System            | Admin Platform       | Seasons page                     | Yes     | Placeholder | Yes     | No      | Planned/Partial | API postoji, FE ruta je placeholder                                                         |
| Platform Billing            | Billing           | Platform Billing     | Plans                            | Yes     | Yes         | Yes     | Partial | Implemented     | Plans page je aktivan                                                                       |
| Platform Billing            | Billing           | Platform Billing     | Subscriptions                    | Yes     | Yes         | Yes     | Partial | Implemented     | Subscriptions page je aktivan                                                               |
| Platform Billing            | Billing           | Platform Billing     | Admin invoices                   | Yes     | Yes         | Yes     | Partial | Implemented     | Invoices page je aktivan                                                                    |
| Platform Billing            | Billing           | Platform Billing     | Invoice payments                 | Yes     | Yes         | Yes     | Partial | Implemented     | Payments modal je aktivan unutar invoices                                                   |
| Platform Billing            | Billing           | Platform Billing     | Standalone payments page         | Yes     | Placeholder | Yes     | No      | Planned/Partial | Sidebar ruta postoji, ekran je placeholder                                                  |
| Platform Billing            | Billing           | Platform Billing     | Ops/finalize                     | Yes     | No          | Yes     | No      | Backend only    | API postoji, Admin FE usage nije pronađen                                                   |
| Planned / UI-only / Cleanup | UI-only           | Notifications        | Notifications                    | No      | UI-only     | No      | No      | Planned         | Topbar dugme postoji, nema potvrđene akcije                                                 |
| Planned / UI-only / Cleanup | UI-only           | Help                 | Help / support UI                | No      | UI-only     | No      | No      | Planned         | Topbar dugme postoji, nema potvrđene akcije                                                 |
| Planned / UI-only / Cleanup | UI-only           | Global Search        | Global search                    | No      | UI-only     | No      | No      | Planned         | Topbar input postoji, nema potvrđenog search ponašanja                                      |

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

### Staff — trenutni rezultat surface/UX audita

Status: `Implemented / Needs cleanup`

Potvrđeno iz Tenant FE audita:

- `/staff` ruta postoji.
- `/staff/:id` ruta postoji.
- `/staff/:id/edit` ruta postoji.
- staff lista postoji.
- staff quick create modal postoji.
- staff detail page postoji.
- staff edit page postoji.
- staff delete flow postoji.
- staff photo koristi verificirani photo pipeline.
- team staff assignment postoji kroz Team detail.
- Team staff add/edit/remove flow postoji.
- staff lista ima search, role filter, sorting, pagination, desktop tabelu i mobile kartice.
- staff edit forma ima loading/error state, dirty-state submit disabling i `beforeunload` guard.

Permisije / capability nalaz:

- Staff create/edit/delete koristi `ManagePlayers`.
- Team staff assignment koristi `ManageTeams`.
- `/staff/:id/edit` ruta nije client-side zaštićena sa `RequireCap`.
- Ne postoji poseban `ManageStaff` cap.

Djelimično / nejasno:

- Staff detail dugme/sekcija “Dodijeli ekipi” je placeholder alert.
- Pravi assignment osoblja u ekipu radi kroz Team detail, ne kroz Staff detail.
- Quick create modal prikuplja manje polja nego edit forma.
- Country handling postoji u edit formi, ali ne u quick create modalu.
- Nije pronađen JMBG birth-date auto-fill za Staff.
- `StaffForm mode="create"` postoji, ali nije jasno da li se koristi kroz aktivnu rutu.

UX rizici:

- Role filter može prikazivati kombinovani tekst tipa `Coach Trener`.
- Mobile staff lista nema edit/delete akcije, samo detail navigation i FAB create.
- Create modal nema jasno vidljiv ESC handler.
- Photo upload modal nema jasno vidljiv ESC/click-outside close.
- Staff detail prikazuje placeholder za dodjelu ekipi, iako realan flow postoji u Team detail-u.
- Quick create koristi alert-based validaciju, dok edit forma koristi inline/global errors.

Cleanup kandidati:

- komentarisani legacy `StaffThumb` blok u `StaffPage`
- komentarisani `useStaffPhoto` import u `StaffPage`
- stariji avatar komentari u match-list dijelu
- mogući neiskorišteni `StaffForm mode="create"`
- `EP.teamStaffAvailable` postoji, ali nije pronađen u aktivnom team staff flow-u

Zaključak:

```text
Staff modul je implementiran, ali nije funkcionalno verified. Prije statusa Verified treba ručno testirati CRUD, photo workflow, validacije, permisije i team staff assignment.
```

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

### Admin FE — trenutni rezultat surface audita

Status: `Implemented with gaps`

Potvrđeno iz Admin FE audita:

- Admin login postoji.
- Admin-only route protection postoji.
- Clubs page je aktivan.
- Club details page je aktivan.
- Club logo upload/delete/display postoji.
- Club users postoje.
- Feature toggles postoje.
- Plans page je aktivan.
- Subscriptions page je aktivan.
- Invoices page je aktivan.
- Invoice payments modal je aktivan.

Placeholder / planirano:

- Dashboard je placeholder.
- Users page je placeholder.
- Roles page je placeholder.
- Audit page je placeholder.
- Settings page je placeholder.
- Payments page je placeholder.
- Seasons page je placeholder.

Potrebna provjera / cleanup:

- `CreateClubModal.tsx` vjerovatno je legacy pored aktivnog `ClubFormModal`.
- `AdminContext.tsx` izgleda neiskorišten.
- `src/lib/axios.ts` može biti dupli API client pored `src/api/index.ts`.
- `index copy.css` i `assets/react.svg` izgledaju kao leftover/demo fajlovi.
- Admin logo/photo cache postoji i aktivno se koristi; ne dirati dok se posebno ne provjeri.

Zaključak:

```text
Admin FE ima stvarne core površine za clubs i billing, ali više sidebar stavki su placeholderi.
```

---

### Platform Billing — trenutni rezultat surface audita

Status: `Implemented with gaps`

Potvrđeno:

- Plans page je aktivan.
- Subscriptions page je aktivan.
- Invoices page je aktivan.
- Invoice payments modal je aktivan unutar invoices.
- Admin billing API površina postoji.

Placeholder / nedovršeno:

- Standalone Payments page postoji u sidebaru, ali je placeholder.
- Ops/finalize API postoji, ali Admin FE usage nije pronađen.

Zaključak:

```text
Platform Billing nije isto što i tenant finance. Plans, subscriptions, invoices i invoice payments su aktivni, ali standalone payments i ops/finalize nisu potvrđeni u FE.
```

---

### Player FE — trenutni rezultat surface audita

Status: `Implemented with cleanup needed`

Potvrđeno iz Player FE audita:

- Player login postoji.
- Protected shell postoji.
- `PlayerAuthGuard` postoji.
- `PlayerBoot` učitava `/api/player/me`.
- Dashboard page postoji.
- Events page postoji.
- Event detail page postoji.
- Attendance page postoji.
- Finance page postoji.
- Profile page postoji.
- Club logo se učitava kroz `/api/player/me/club-logo`.
- Player profile photo se učitava kroz `/api/player/profile/photo`.

Ručno verificirano:

- Player dashboard nakon login-a.
- Player profile.
- Player events.
- Player attendance.
- Player finance.

Nedovršeno / cleanup:

- Notifications page postoji, ali koristi mock podatke.
- Login link vodi na `/password-reset`, ali Player FE nema `/password-reset` rutu.
- Role guard logika je duplirana:
  - `ProtectedRoute` provjerava prvu rolu case-insensitive.
  - `PlayerAuthGuard` provjerava `me.roles.includes("player")` case-sensitive.
- Profile photo koristi `usePersonPhoto` direktno sa ručnim `<img>`, ne `PersonThumb`.
- Postoje duplicate/legacy fajlovi:
  - `components/EventsPage.tsx`
  - `hooks/PlayerSidebar.tsx`
  - `components/PersonThumb copy.tsx`
  - `api/fetchSecurePhoto.ts`
  - `utils/photoCache.ts`
  - `src/styles/legacy`

Zaključak:

```text
Player FE core radi i verifikovan je za glavne stranice, ali notifications, password reset ruta, role guards i cleanup ostaju otvoreni.
```

---

### Inventory hygiene / cleanup candidates

Ovo nisu hitne korekcije, ali moraju ostati vidljive.

| Area        | Candidate                                                                 |
| ----------- | ------------------------------------------------------------------------- |
| Players     | duplicate create flow                                                     |
| Players     | JMBG auto-fill missing from primary `PlayerForm`                          |
| Players     | DEV marker / `console.log` in `PlayerCreatePage`                          |
| Staff       | quick create vs edit form mismatch                                        |
| Staff       | missing client-side route guard on `/staff/:id/edit`                      |
| Staff       | staff detail team assignment placeholder                                  |
| Events      | `EventAttendancePage.tsx` exists but is not routed                        |
| Finance     | `FinanceTransactionsPage.tsx` exists but route uses `FinTransactionsPage` |
| Finance     | endpoint naming is split across `finance`, `fin`, and `fees`              |
| Topbar      | `Pomoć`, `Obavijesti`, global search are UI-only                          |
| Permissions | `ViewReports` usage unclear                                               |
| Permissions | `ManageRegistrations` usage unclear                                       |
| Admin FE    | placeholder routes exist in sidebar                                       |
| Player FE   | notifications mock, missing password reset route, duplicate guards        |
| Dev         | dev/debug endpoints should be checked for environment exposure            |

---

## Verification status summary

| Area                           | Module                         | Current status                   |
| ------------------------------ | ------------------------------ | -------------------------------- |
| Platform / System              | Documentation                  | Verified                         |
| Platform / System              | System Surface Map             | Implemented                      |
| Tenant App                     | Photo/avatar pipeline          | Polished                         |
| Tenant App                     | Shared UI / Photos             | Polished                         |
| Tenant App / Player Portal App | Player Portal CORE             | Verified                         |
| Player Portal App              | Player FE core pages           | Verified                         |
| Player Portal App              | Player FE notifications        | Planned/Mock                     |
| Player Portal App              | Player FE password reset route | Needs cleanup                    |
| Player Portal App              | Player FE role guards          | Needs cleanup                    |
| Tenant App                     | Players                        | Implemented                      |
| Tenant App                     | Staff                          | Implemented / Needs cleanup      |
| Tenant App                     | Teams                          | Implemented                      |
| Tenant App                     | Events                         | Implemented / Needs cleanup      |
| Tenant App                     | Attendance                     | Implemented / Needs cleanup      |
| Tenant App                     | Lineup                         | Implemented / Needs cleanup      |
| Tenant App                     | Documents                      | Implemented                      |
| Tenant App                     | Contracts                      | Implemented                      |
| Tenant App                     | Medicals                       | Implemented                      |
| Tenant App                     | Registrations                  | Implemented                      |
| Tenant App                     | Eligibility Lite               | Implemented                      |
| Tenant App                     | Finance Fees                   | In progress                      |
| Tenant App                     | General Finance                | Implemented / needs verification |
| Tenant App                     | Tenant Users                   | Implemented                      |
| Admin App                      | Admin FE core clubs/billing    | Implemented                      |
| Admin App                      | Admin FE placeholders          | Planned/Partial                  |
| Admin App                      | Admin Platform API             | Implemented / needs verification |
| Platform Billing               | Platform Billing               | Implemented / needs verification |
| Tenant App                     | Reports                        | Planned/Partial                  |
| Planned / UI-only / Cleanup    | Notifications                  | Planned                          |
| Planned / UI-only / Cleanup    | Help                           | Planned                          |
| Planned / UI-only / Cleanup    | Global Search                  | Planned                          |

---

## Next verification targets

Preporučeni redoslijed:

| Priority | Area              | Domain            | Module                      |
| -------- | ----------------- | ----------------- | --------------------------- |
| 1        | Tenant App        | People            | Staff                       |
| 2        | Tenant App        | Teams             | Teams                       |
| 3        | Tenant App        | Documents         | Documents Engine            |
| 4        | Tenant App        | People / Players  | Contracts                   |
| 5        | Tenant App        | People / Players  | Player Medicals             |
| 6        | Tenant App        | People / Players  | Player Registrations        |
| 7        | Tenant App        | People / Players  | Eligibility                 |
| 8        | Tenant App        | Events            | Event Core                  |
| 9        | Tenant App        | Events            | Attendance                  |
| 10       | Tenant App        | Events            | Lineup / MatchList          |
| 11       | Tenant App        | Finance           | Fees / Članarine            |
| 12       | Tenant App        | Finance           | General Finance             |
| 13       | Tenant App        | Club              | Users                       |
| 14       | Tenant App        | Club              | Dashboard                   |
| 15       | Platform / System | Settings / Config | Settings / Lookups / Config |
| 16       | Admin App         | Clubs             | Admin Platform              |
| 17       | Platform Billing  | Billing           | Platform Billing            |
| 18       | Player Portal App | Cleanup           | Player FE cleanup           |
| 19       | Platform / System | Dev / Meta        | Dev Diagnostics / Meta      |
