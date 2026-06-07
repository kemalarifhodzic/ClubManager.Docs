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

## Audit coverage tracker

| Area              | Domain              | Module                                      | FE surface audit | Backend/API audit | DB schema audit | Manual functional test | Last audit note                                                                                                                                                         |
| ----------------- | ------------------- | ------------------------------------------- | ---------------- | ----------------- | --------------- | ---------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tenant App        | People              | Players                                     | Done             | Done              | Done            | Partial                | BE/API/DB audit završen; functional test pending                                                                                                                        |
| Tenant App        | People              | Staff                                       | Done             | Done              | Done            | Partial                | BE rizici: ManageStaff, JMBG nullability                                                                                                                                |
| Tenant App        | Club                | Users                                       | Pending          | Pending           | Pending         | No                     | Nije još prošao Codex audit                                                                                                                                             |
| Admin App         | Platform Management | Admin Platform                              | Done             | Pending           | Pending         | Partial                | FE surface mapiran; BE/DB audit nije formalno završen                                                                                                                   |
| Platform Billing  | Billing             | Platform Billing                            | Done             | Pending           | Pending         | Partial                | FE surface mapiran; BE/DB audit nije formalno završen                                                                                                                   |
| Player Portal App | Portal Core         | Player Portal                               | Done             | Partial           | Partial         | Yes                    | Core funkcionalno testiran; dodatni BE risk ostaje na activation strani                                                                                                 |
| Platform / System | Auth / Account      | Auth                                        | Pending          | Pending           | Pending         | Partial                | Treba poseban audit                                                                                                                                                     |
| Tenant App        | People              | Players / Staff / People modules            | Done             | Done              | Done            | Partial                | People audit završen; cleanup + functional test pending                                                                                                                 |
| Tenant App        | Teams               | Teams                                       | Done             | Done              | Done            | No                     | Teams audit završen; Team CRUD i Staff memberships imaju cleanup stavke                                                                                                 |
| Tenant App        | Teams               | Memberships                                 | Done             | Done              | Done            | No                     | Player/staff memberships potvrđeni kroz API/FE/DB; ručni test pending                                                                                                   |
| Tenant App        | Teams               | Attendance                                  | Done             | Done              | Done            | No                     | Team attendance panel/statistics potvrđeni kroz API/FE/DB; functional test pending                                                                                      |
| Tenant App        | Events              | Event Core                                  | Done             | Done              | Done            | No                     | CRUD/detail implemented; lifecycle complete behavior needs cleanup                                                                                                      |
| Tenant App        | Events              | Attendance                                  | Done             | Done              | Done            | No                     | Attendance i lock/read-only implementirani; cancelled-event lock i RLS coverage su rizici                                                                               |
| Tenant App        | Events              | Lineup / MatchList                          | Done             | Done              | Done            | No                     | Lineup/lock/print implementirani; export nema evidence; manual workflow test pending                                                                                    |
| Tenant App        | Events              | Cross-surface usage                         | Done             | Done              | Done            | No                     | Dashboard/team usage potvrđen; Player Portal backend usage potvrđen                                                                                                     |
| Tenant App        | Finance             | Fees / Članarine                            | Done             | Done              | Done            | No                     | Fees implemented with list/detail/quick-pay/history/storno/bulk; direct invoice create/edit/delete UI and exports need cleanup/verification                             |
| Tenant App        | Finance             | General Finance                             | Done             | Done              | Done            | No                     | Categories and ledger implemented; category FE caps, export UI, summary/report surface need cleanup/verification                                                        |
| Tenant App        | Documents           | Documents Engine                            | Done             | Done              | Done            | No                     | Global engine implemented for Player/Staff API, Player FE tab active; Needs cleanup for Club entity schema mismatch, FE document type mismatch, lifecycle/storage risks |
| Tenant App        | Club / Operations   | Dashboard                                   | Done             | Done              | Done            | No                     | Dashboard implemented but backend `ReadOnly` cap missing; manual verification pending                                                                                   |
| Tenant App        | Club / Operations   | Current club profile / branding / logo      | Done             | Done              | Done            | No                     | Tenant read/display implemented; summary placeholders and no tenant logo/profile edit                                                                                   |
| Tenant App        | Club / Operations   | Tenant users management                     | Done             | Done              | Done            | No                     | CRUD-ish API exists, FE list/create/status/password active; edit FE absent; backend list cap gap                                                                        |
| Tenant App        | Club / Operations   | Tenant settings / shell                     | Done             | Done              | Done            | No                     | Settings API backend-only; shell active with UI-only search/help/notifications                                                                                          |
| Admin App         | Platform Management | Access                                      | Done             | Done              | Done            | Partial                | Implemented, needs negative access tests                                                                                                                                |
| Admin App         | Platform Management | Dashboard                                   | Done             | Done              | Done            | No                     | Placeholder only                                                                                                                                                        |
| Admin App         | Platform Management | Clubs                                       | Done             | Done              | Done            | Partial                | Implemented, query/placeholder cleanup needed                                                                                                                           |
| Admin App         | Platform Management | Club users                                  | Done             | Done              | Done            | Partial                | Partial lifecycle and missing caps                                                                                                                                      |
| Admin App         | Platform Management | Feature toggles                             | Done             | Done              | Done            | Partial                | Implemented with auth/validation cleanup                                                                                                                                |
| Admin App         | Platform Management | Admin users                                 | Done             | Done              | Done            | No                     | API partial, FE placeholder                                                                                                                                             |
| Admin App         | Platform Management | Roles                                       | Done             | Done              | Done            | No                     | API read-only, FE placeholder                                                                                                                                           |
| Admin App         | Platform Management | Audit                                       | Done             | Done              | Done            | No                     | API exists, FE placeholder                                                                                                                                              |
| Admin App         | Platform Management | Settings                                    | Done             | Done              | Done            | No                     | API exists, FE placeholder                                                                                                                                              |
| Admin App         | Platform Management | Seasons                                     | Done             | Done              | Done            | No                     | Backend exists, FE placeholder                                                                                                                                          |
| Platform Billing  | Billing             | Plans                                       | Done             | Done              | Done            | Partial                | Implemented; billing cycle semantics need verification                                                                                                                  |
| Platform Billing  | Billing             | Subscriptions                               | Done             | Done              | Done            | Partial                | Implemented with scheduled change/past_due gaps                                                                                                                         |
| Platform Billing  | Billing             | Admin invoices                              | Done             | Done              | Done            | Partial                | Implemented with status drift/audit risks                                                                                                                               |
| Platform Billing  | Billing             | Invoice payments                            | Done             | Done              | Done            | Partial                | CRUD active; storno/reversal absent                                                                                                                                     |
| Platform Billing  | Billing             | Standalone payments                         | Done             | Done              | Done            | No                     | FE placeholder; no standalone API                                                                                                                                       |
| Platform Billing  | Billing             | Ops / finalize                              | Done             | Done              | Done            | No                     | Backend only                                                                                                                                                            |
| Platform Billing  | Billing             | Billing exports                             | Done             | Done              | Done            | No                     | No evidence                                                                                                                                                             |
| Platform Billing  | Billing             | Billing dashboard                           | Done             | Done              | Done            | No                     | No dedicated dashboard found                                                                                                                                            |
| Player Portal App | Player Portal       | Login / guard                               | Done             | Done              | Done            | Partial                | Login/core tested; non-player rejection and direct URL behavior still need targeted tests                                                                               |
| Player Portal App | Player Portal       | Dashboard/Profile/Events/Attendance/Finance | Done             | Done              | Done            | Yes                    | Core pages documented as manually tested                                                                                                                                |
| Player Portal App | Player Portal       | Club logo/Profile photo                     | Done             | Done              | Done            | Partial                | Display implemented; profile photo component standard needs cleanup                                                                                                     |
| Player Portal App | Player Portal       | Notifications                               | Done             | No evidence       | No evidence     | No                     | Mock-only page                                                                                                                                                          |
| Player Portal App | Player Portal       | Password reset                              | Partial          | Done              | Done            | No                     | Backend exists; FE route missing                                                                                                                                        |
| Player Portal App | Player Portal       | Cleanup / legacy files                      | Done             | N/A               | N/A             | No                     | Duplicate/legacy files identified                                                                                                                                       |
| Platform / System | System              | Auth / Account                              | Done             | Done              | Done            | Pending                | Login/change password implemented; reset FE mismatch                                                                                                                    |
| Platform / System | System              | Settings / Config                           | Done             | Done              | Done            | Pending                | Tenant/admin APIs backend-only or placeholder                                                                                                                           |
| Platform / System | System              | Lookups                                     | Done             | Done              | N/A             | Pending                | Tenant usage found                                                                                                                                                      |
| Platform / System | System              | Photo config                                | Done             | Done              | Partial         | Pending                | Config hook/API exists; storage via settings/features                                                                                                                   |
| Platform / System | System              | Seasons                                     | Done             | Done              | Done            | Pending                | Admin FE placeholder; default behavior mismatch                                                                                                                         |
| Platform / System | System              | Meta / Health                               | Done             | Done              | N/A             | Pending                | `/healthz`, `/readyz`, admin constants                                                                                                                                  |
| Platform / System | System              | Dev diagnostics                             | Done             | Done              | N/A             | Pending                | Exposure review needed                                                                                                                                                  |
| Platform / System | System              | Permissions / capabilities infrastructure   | Done             | Done              | Done            | Pending                | Cap source/claim/use confirmed; mismatches remain                                                                                                                       |
| Platform / System | System              | System shell/access behavior                | Done             | Partial           | N/A             | Pending                | FE app gates exist; duplicated logic                                                                                                                                    |

---

## Inventory tabela

| Area                        | Domain              | Module                                    | Feature                                   | BE          | FE          | DB          | Tested  | Status          | Notes                                                                                                        |
| --------------------------- | ------------------- | ----------------------------------------- | ----------------------------------------- | ----------- | ----------- | ----------- | ------- | --------------- | ------------------------------------------------------------------------------------------------------------ |
| Platform / System           | Documentation       | Documentation                             | Central docs repository                   | N/A         | N/A         | N/A         | Yes     | Verified        | `/home/kemo/ClubManager/docs` je poseban Git repo                                                            |
| Platform / System           | Documentation       | System Map                                | System Surface Map v1                     | Yes         | Yes         | N/A         | Yes     | Verified        | API, Tenant FE, Admin FE i Player FE površina su mapirani; DB surface pending                                |
| Platform / System           | System              | Auth / Account                            | Login                                     | Yes         | Yes         | Yes         | No      | Implemented     | All FE apps login through backend auth                                                                       |
| Platform / System           | System              | Auth / Account                            | JWT generation/claims                     | Yes         | Yes         | Yes         | No      | Needs cleanup   | Claims exist; split token services                                                                           |
| Platform / System           | System              | Permissions / capabilities infrastructure | Role/capability claims                    | Yes         | Partial     | Yes         | No      | Needs cleanup   | Cap consistency issues                                                                                       |
| Platform / System           | System              | Auth / Account                            | Password reset request/set                | Yes         | Partial     | Yes         | No      | Needs cleanup   | FE route/endpoint gaps                                                                                       |
| Platform / System           | System              | Auth / Account                            | Account change password                   | Yes         | Partial     | Yes         | No      | Implemented     | Tenant UI only                                                                                               |
| Platform / System           | System              | Auth / Account                            | Tenant FE auth guard                      | N/A         | Yes         | N/A         | No      | Implemented     | Role `club` gate                                                                                             |
| Platform / System           | System              | Auth / Account                            | Admin FE auth guard                       | N/A         | Yes         | N/A         | No      | Implemented     | Role `admin` gate                                                                                            |
| Platform / System           | System              | Auth / Account                            | Player FE auth guard                      | N/A         | Partial     | N/A         | No      | Needs cleanup   | Duplicate/inconsistent guards                                                                                |
| Platform / System           | System              | Settings / Config                         | Tenant settings API                       | Yes         | No          | Yes         | No      | Backend only    | No settings UI found                                                                                         |
| Platform / System           | System              | Settings / Config                         | Admin/global settings API                 | Yes         | Placeholder | Yes         | No      | Backend only    | Admin route placeholder                                                                                      |
| Platform / System           | System              | Lookups                                   | Lookups API                               | Yes         | Partial     | N/A         | No      | Implemented     | Tenant forms use lookup helpers                                                                              |
| Platform / System           | System              | Photo config                              | Photo config API                          | Yes         | Partial     | Partial     | No      | Implemented     | Hook usage exists                                                                                            |
| Platform / System           | System              | Seasons                                   | Seasons API                               | Yes         | Partial     | Yes         | No      | Implemented     | Tenant default usage; admin placeholder                                                                      |
| Platform / System           | System              | Seasons                                   | Default season behavior                   | Partial     | Partial     | Yes         | No      | Needs cleanup   | Endpoint/provider fallback mismatch                                                                          |
| Platform / System           | System              | Meta / Health                             | Health endpoint                           | Yes         | No          | N/A         | No      | Backend only    | `/healthz` anonymous                                                                                         |
| Platform / System           | System              | Meta / Health                             | Readiness endpoint                        | Yes         | No          | N/A         | No      | Backend only    | `/readyz` anonymous                                                                                          |
| Platform / System           | System              | Meta / Health                             | Meta/version endpoint                     | Partial     | Partial     | N/A         | No      | Backend only    | admin constants yes; version no                                                                              |
| Platform / System           | System              | Dev diagnostics                           | Dev/debug endpoints                       | Partial     | No          | N/A         | No      | Needs cleanup   | Some env-gated, some not                                                                                     |
| Platform / System           | System              | System shell/access behavior              | Duplicate auth/client logic               | N/A         | Partial     | N/A         | No      | Needs cleanup   | Duplicate AuthContext/API clients                                                                            |
| Tenant App                  | Club / Operations   | Dashboard                                 | Tenant dashboard                          | Partial     | Yes         | Yes         | No      | Needs cleanup   | Backend lacks `ReadOnly` cap                                                                                 |
| Tenant App                  | Club / Operations   | Dashboard                                 | Dashboard cards/counts/summaries          | Yes         | Yes         | Yes         | No      | Implemented     | Real source tables used                                                                                      |
| Tenant App                  | Club / Operations   | Dashboard                                 | Dashboard event/team/fee usage            | Yes         | Yes         | Yes         | No      | Implemented     | Active cross-module links/summaries                                                                          |
| Tenant App                  | Club / Operations   | Clubs                                     | Current club profile endpoint/page        | Partial     | Partial     | Yes         | No      | Needs cleanup   | Read endpoints exist; summary placeholders; no edit page                                                     |
| Tenant App                  | Club / Operations   | Branding                                  | Club branding                             | Partial     | Yes         | Yes         | No      | Implemented     | Display active, no tenant editing                                                                            |
| Tenant App                  | Club / Operations   | Club logo                                 | Club logo display                         | Yes         | Yes         | Yes         | No      | Implemented     | Tenant shell displays logo blob                                                                              |
| Tenant App                  | Club / Operations   | Club logo                                 | Club logo upload/delete tenant-side       | No          | No          | Yes         | No      | Planned         | Admin-side only, not tenant-side                                                                             |
| Tenant App                  | Club / Operations   | Users                                     | Tenant users list                         | Partial     | Yes         | Yes         | No      | Needs cleanup   | Backend list lacks `ManageUsers`                                                                             |
| Tenant App                  | Club / Operations   | Users                                     | Tenant user create/invite                 | Yes         | Partial     | Yes         | No      | Implemented     | Create yes; invite no evidence                                                                               |
| Tenant App                  | Club / Operations   | Users                                     | Tenant user activate/deactivate           | Partial     | Yes         | Yes         | No      | Needs cleanup   | Self/last-manager protections not visible                                                                    |
| Tenant App                  | Club / Operations   | Users                                     | Tenant user edit/update                   | Partial     | No          | Yes         | No      | Backend only    | API update exists; FE edit absent; detail placeholder                                                        |
| Tenant App                  | Club / Operations   | Users                                     | Tenant user set password                  | Yes         | Yes         | Yes         | No      | Implemented     | Active modal + endpoint                                                                                      |
| Tenant App                  | Club / Operations   | Users                                     | Roles/capabilities display                | Partial     | Partial     | Yes         | No      | Implemented     | Roles shown; caps matrix not exposed                                                                         |
| Tenant App                  | Club / Operations   | Users                                     | Permission/capability enforcement         | Partial     | Partial     | Yes         | No      | Needs cleanup   | Mutation caps good; read/list gaps                                                                           |
| Tenant App                  | Club / Operations   | Shell                                     | Tenant shell/sidebar/topbar club context  | Partial     | Yes         | Yes         | No      | Needs cleanup   | Active shell; duplicated context + placeholder actions                                                       |
| Tenant App                  | Club / Operations   | Settings                                  | Tenant settings endpoint/page             | Yes         | No          | Yes         | No      | Backend only    | `/api/settings` exists; no FE page                                                                           |
| Tenant App                  | Club / Operations   | Settings                                  | Account change password                   | Yes         | Yes         | Yes         | No      | Implemented     | `/settings/password` active                                                                                  |
| Tenant App                  | Club / Operations   | Shell                                     | UI-only topbar actions                    | No evidence | Placeholder | No evidence | No      | Needs cleanup   | Search/help/notifications not backed                                                                         |
| Tenant App                  | People              | Players                                   | Player CRUD                               | Yes         | Yes         | Yes         | Partial | Implemented     | Backend/API audit potvrdio controller/service/entity/schema; FE CRUD postoji; duplicate create flow ostaje   |
| Tenant App                  | People              | Players                                   | JMBG validation                           | Partial     | Yes         | Partial     | Partial | Needs cleanup   | Backend potvrđuje 13-digit format i unique `(club_id,jmbg)`; nema checksum/date consistency validacije       |
| Tenant App                  | People              | Players                                   | Birth date handling                       | Yes         | Partial     | Yes         | Partial | Implemented     | Backend validira i čuva `birthDate`; FE auto-fill iz JMBG-a nije potvrđen u primarnom `PlayerForm` toku      |
| Tenant App                  | People              | Players                                   | Player detail profile                     | Yes         | Yes         | Yes         | Partial | Implemented     | Detail profil i tabovi postoje; backend player detail source/schema potvrđeni; potrebna ručna verifikacija   |
| Tenant App                  | People              | Players                                   | Player photo                              | Yes         | Yes         | Yes         | Yes     | Polished        | Koristi verificirani photo pipeline; ranije ručno potvrđeno kroz player/staff upload/delete/list/detail test |
| Tenant App                  | People              | Players                                   | Player registrations                      | Yes         | Yes         | Yes         | Partial | Implemented     | Backend CRUD, validacija, unique active conflict i DB schema potvrđeni; treba ručni workflow test            |
| Tenant App                  | People              | Players                                   | Player medical records                    | Yes         | Yes         | Yes         | Partial | Implemented     | Backend CRUD, validacija i DB schema potvrđeni; testirati unos/izmjenu i uticaj na eligibility               |
| Tenant App                  | People              | Players                                   | Player documents tab                      | Yes         | Yes         | Yes         | Partial | Implemented     | Documents engine potvrđuje Player dokumente; testirati upload/replace/delete/restore/purge                   |
| Tenant App                  | People              | Players                                   | Contracts module                          | Yes         | Yes         | Yes         | Partial | Needs cleanup   | Backend jak; FE audit našao raw debug `alert(JSON.stringify(...))` u contracts formi                         |
| Tenant App                  | People              | Players                                   | Contract verification                     | Yes         | Yes         | Yes         | Partial | Implemented     | Verify endpoint i DB polja postoje; treba ručno testirati verified lock ponašanje                            |
| Tenant App                  | People              | Players                                   | Eligibility Lite                          | Yes         | Yes         | Yes         | Partial | Implemented     | Computed iz registracija, ljekarskog, settings/features; treba test valid/invalid scenarija                  |
| Tenant App                  | People              | Players                                   | Eligibility PRO                           | No evidence | No          | No evidence | No      | Planned         | Nema vidljive premium compliance logike                                                                      |
| Tenant App                  | People              | Players                                   | Portal activation from Tenant FE          | Partial     | Yes         | Yes         | Yes     | Needs cleanup   | Funkcionalno testirano, ali backend audit našao cross-club rizik u PlayerPortalAdminService                  |
| Tenant App                  | People              | Staff                                     | Staff CRUD                                | Partial     | Yes         | Yes         | Partial | Needs cleanup   | CRUD i schema postoje, ali BE koristi `ManagePlayers` umjesto `ManageStaff`; role/sort filter gap            |
| Tenant App                  | People              | Staff                                     | Staff photo                               | Yes         | Yes         | Yes         | Yes     | Polished        | Staff photo backend i standardni photo pipeline su potvrđeni kroz ručni player/staff photo test              |
| Tenant App                  | People              | Staff                                     | Staff detail profile                      | Partial     | Yes         | Yes         | Partial | Implemented     | Backend Staff CRUD/schema postoje; profil postoji; team assignment sekcija u Staff detail-u je placeholder   |
| Tenant App                  | People              | Staff                                     | Staff form validation                     | Partial     | Yes         | Partial     | Partial | Needs cleanup   | Validacija postoji, ali JMBG nije semantički; DB `staff.jmbg` NOT NULL dok DTO/entity dopuštaju nullable     |
| Tenant App                  | People              | Staff                                     | Team staff assignment                     | Partial     | Yes         | Yes         | Partial | Needs cleanup   | Realni flow radi kroz Team detail; backend/schema postoje, ali validacija/error handling imaju gapove        |
| Tenant App                  | Teams               | Teams                                     | Team CRUD                                 | Partial     | Yes         | Yes         | No      | Needs cleanup   | CRUD postoji; backend validation/error mapping i FE edit route guard trebaju cleanup                         |
| Tenant App                  | Teams               | Teams                                     | Team detail                               | Yes         | Yes         | Yes         | No      | Implemented     | Detail page i API postoje; prikazuje osnovne podatke, članove, staff i attendance panel                      |
| Tenant App                  | Teams               | Memberships                               | Player memberships                        | Yes         | Yes         | Yes         | No      | Implemented     | Team-side i player-side membership surface postoje; provjeriti tenant isolation i membership konflikte       |
| Tenant App                  | Teams               | Memberships                               | Staff memberships                         | Partial     | Yes         | Yes         | No      | Needs cleanup   | Realan flow postoji; validacija/error handling i dupli service surface trebaju cleanup                       |
| Tenant App                  | Teams               | Attendance                                | Team attendance panel/statistics          | Yes         | Yes         | Yes         | No      | Implemented     | Stats/detail API i FE panel postoje; koristi event attendance podatke                                        |
| Tenant App                  | Teams               | Dashboard                                 | Team dashboard/list usage                 | Yes         | Yes         | Yes         | No      | Implemented     | Dashboard team summary i Events team filter/list usage su aktivni                                            |
| Tenant App                  | Events              | Event Core                                | Event CRUD                                | Yes         | Yes         | Yes         | No      | Implemented     | CRUD endpoints, list/detail UI, create/edit/delete modal/actions postoje; manual test pending                |
| Tenant App                  | Events              | Event Core                                | Event detail                              | Yes         | Yes         | Yes         | No      | Implemented     | Detail route/page postoji sa attendance i match-list tabovima                                                |
| Tenant App                  | Events              | Event Lifecycle                           | Event status lifecycle                    | Partial     | Partial     | Yes         | No      | Needs cleanup   | Cancel postoji; complete endpoint postoji, ali ponašanje izgleda sumnjivo i nije surfacovan u FE             |
| Tenant App                  | Events              | Attendance                                | Event attendance                          | Yes         | Yes         | Yes         | No      | Implemented     | CRUD/bulk-upsert, roster, summary i aktivni UI postoje                                                       |
| Tenant App                  | Events              | Attendance                                | Attendance lock/unlock                    | Partial     | Yes         | Yes         | No      | Needs cleanup   | Lock/read-only postoji; cancelled-event lock behavior i prompt UX trebaju cleanup                            |
| Tenant App                  | Events              | Attendance                                | Locked attendance read-only               | Yes         | Yes         | Yes         | No      | Implemented     | Backend blokira mutacije i FE onemogućava editovanje                                                         |
| Tenant App                  | Events              | Attendance                                | Team attendance statistics                | Yes         | Yes         | Yes         | No      | Implemented     | Statistika koristi samo locked event attendance                                                              |
| Tenant App                  | Events              | Lineup / MatchList                        | MatchList / lineup                        | Yes         | Yes         | Yes         | No      | Implemented     | Display, edit, candidates i print postoje; nema dokaza za export                                             |
| Tenant App                  | Events              | Lineup / MatchList                        | Lineup lock/unlock                        | Yes         | Yes         | Yes         | No      | Needs cleanup   | Lock/unlock implementiran sa eligibility provjerama i DB trigger podrškom; manual workflow test pending      |
| Tenant App                  | Events              | Cross-surface                             | Player Portal event usage                 | Yes         | No evidence | Yes         | No      | Backend only    | Player API postoji; player-fe nije bio u ovom audit path-u                                                   |
| Tenant App                  | Events              | Cross-surface                             | Dashboard/team event usage                | Yes         | Yes         | Yes         | No      | Implemented     | Dashboard events i team attendance panel su aktivni                                                          |
| Tenant App                  | Finance             | Fees / Članarine                          | Fee invoices                              | Yes         | Yes         | Yes         | No      | Implemented     | List/detail/update/delete/export API; active list/detail UI; create is through bulk ops                      |
| Tenant App                  | Finance             | Fees / Članarine                          | Fee invoice list/detail                   | Yes         | Yes         | Yes         | No      | Implemented     | Active Fees page and Player detail tab use invoice list/detail                                               |
| Tenant App                  | Finance             | Fees / Članarine                          | Fee invoice create/update/delete          | Partial     | Partial     | Yes         | No      | Needs cleanup   | Bulk create exists; direct single create not found; update/delete not exposed in UI                          |
| Tenant App                  | Finance             | Fees / Članarine                          | Fee invoice status calculation            | Partial     | Yes         | Yes         | No      | Needs cleanup   | Computed in reads, but stored status can drift                                                               |
| Tenant App                  | Finance             | Fees / Članarine                          | Fee payments                              | Yes         | Yes         | Yes         | No      | Implemented     | Quick pay, history, auto-posting and storno exist                                                            |
| Tenant App                  | Finance             | Fees / Članarine                          | Payment add/edit/delete                   | Partial     | Partial     | Yes         | No      | Implemented     | Add active; edit/delete backend exists but posted payments are immutable                                     |
| Tenant App                  | Finance             | Fees / Članarine                          | Payment storno / reversal                 | Yes         | Yes         | Yes         | No      | Implemented     | Storno creates reversal transaction and keeps audit trail                                                    |
| Tenant App                  | Finance             | Fees / Članarine                          | Bulk fee invoice creation                 | Yes         | Yes         | Yes         | No      | Implemented     | Wizard preview and dry-run/apply active                                                                      |
| Tenant App                  | Finance             | Fees / Članarine                          | Bulk payment operations                   | Yes         | Yes         | Yes         | No      | Implemented     | Bulk pay active for selected invoices                                                                        |
| Tenant App                  | Finance             | Fees / Članarine                          | Fee exports                               | Yes         | No          | Yes         | No      | Backend only    | CSV endpoints exist; tenant FE controls not found                                                            |
| Tenant App                  | Finance             | Fees / Članarine                          | Player fee summary / player finance usage | Yes         | Yes         | Yes         | Partial | Implemented     | Player detail tab active; player portal finance documented verified separately                               |
| Tenant App                  | Finance             | Fees / Članarine                          | Fee dashboard/summary usage               | Yes         | Yes         | Yes         | No      | Implemented     | Dashboard and FeesPage summaries active                                                                      |
| Tenant App                  | Finance             | General Finance                           | Finance categories                        | Yes         | Partial     | Yes         | No      | Needs cleanup   | CRUD works, but FE write buttons lack visible cap guard and code field mismatch                              |
| Tenant App                  | Finance             | General Finance                           | Finance transactions                      | Yes         | Yes         | Yes         | No      | Implemented     | Ledger list/create/safe edit/storno active                                                                   |
| Tenant App                  | Finance             | General Finance                           | Transaction create/update/delete          | Yes         | Yes         | Yes         | No      | Implemented     | Delete intentionally disabled; immutable fields require storno                                               |
| Tenant App                  | Finance             | General Finance                           | Transaction storno / reversal             | Yes         | Yes         | Partial     | No      | Implemented     | Storno active; DB lacks explicit reversal relationship                                                       |
| Tenant App                  | Finance             | General Finance                           | Transaction export                        | Yes         | No          | Yes         | No      | Backend only    | CSV endpoint exists; UI not found                                                                            |
| Tenant App                  | Finance             | General Finance                           | Finance summaries/reports                 | No evidence | Partial     | Partial     | No      | Planned         | No general finance summary endpoint found; FE shows local loaded-page totals                                 |
| Tenant App                  | Finance             | General Finance                           | Category usage in transactions            | Yes         | Yes         | Yes         | No      | Implemented     | Category FK, filters and modal picker active                                                                 |
| Tenant App                  | Finance             | General Finance                           | Tenant finance dashboard usage            | No evidence | No          | Partial     | No      | Planned         | Dashboard shows fees, not general ledger                                                                     |
| Tenant App                  | Documents           | Documents Engine                          | Documents list/search/filter              | Yes         | Partial     | Yes         | No      | Implemented     | Backend supports global filters; FE only Player tab                                                          |
| Tenant App                  | Documents           | Documents Engine                          | Document detail                           | Yes         | No          | Yes         | No      | Backend only    | Endpoint exists, no detail UI found                                                                          |
| Tenant App                  | Documents           | Documents Engine                          | Document upload                           | Partial     | Partial     | Partial     | No      | Needs cleanup   | Player/Staff supported; Club mismatch; FE type mismatch                                                      |
| Tenant App                  | Documents           | Documents Engine                          | Document download/view                    | Yes         | Partial     | Yes         | No      | Implemented     | Player tab uses preview/download                                                                             |
| Tenant App                  | Documents           | Documents Engine                          | Document replace                          | Yes         | Partial     | Yes         | No      | Implemented     | New row + old row archived/replaced                                                                          |
| Tenant App                  | Documents           | Documents Engine                          | Document soft delete                      | Partial     | Partial     | Yes         | No      | Needs cleanup   | Does not set `deleted_at`                                                                                    |
| Tenant App                  | Documents           | Documents Engine                          | Document restore                          | Yes         | Partial     | Yes         | No      | Implemented     | Player tab supports restore                                                                                  |
| Tenant App                  | Documents           | Documents Engine                          | Document purge                            | Partial     | Partial     | Yes         | No      | Needs cleanup   | DB/filesystem drift risk                                                                                     |
| Tenant App                  | Documents           | Documents Engine                          | Document lifecycle/status                 | Partial     | Partial     | Yes         | No      | Needs cleanup   | Status exists, lifecycle metadata has gaps                                                                   |
| Tenant App                  | Documents           | Documents Engine                          | Document type handling                    | Partial     | Partial     | Yes         | No      | Needs cleanup   | `LicenseDocument` vs `QualificationDocument` mismatch                                                        |
| Tenant App                  | Documents           | Documents Engine                          | Document title handling                   | Yes         | Partial     | Yes         | No      | Implemented     | Upload/replace only                                                                                          |
| Tenant App                  | Documents           | Documents Engine                          | File validation                           | Yes         | Partial     | Yes         | No      | Implemented     | Strong backend validation                                                                                    |
| Tenant App                  | Documents           | Documents Engine                          | Storage path strategy                     | Partial     | N/A         | Yes         | No      | Needs cleanup   | Local FS, non-transactional DB/file operations                                                               |
| Tenant App                  | Documents           | Documents Engine                          | Player documents usage                    | Yes         | Yes         | Yes         | Partial | Implemented     | Active Player Documents tab                                                                                  |
| Tenant App                  | Documents           | Documents Engine                          | Staff documents usage                     | Yes         | No          | Yes         | No      | Backend only    | API/schema support, no UI found                                                                              |
| Tenant App                  | Documents           | Documents Engine                          | Club documents usage                      | Partial     | No          | No          | No      | Needs cleanup   | Service supports, schema rejects                                                                             |
| Tenant App                  | Documents           | Documents Engine                          | Document permissions/capabilities         | Partial     | Partial     | Yes         | No      | Needs cleanup   | Protected but too coarse-grained                                                                             |
| Tenant App                  | Documents           | Documents Engine                          | Document tenant/club scoping              | Yes         | Yes         | Yes         | No      | Implemented     | Strong club filtering/RLS for Player/Staff                                                                   |
| Tenant App                  | Documents           | Documents Engine                          | Document audit logging                    | Yes         | No          | Yes         | No      | Backend only    | Lifecycle audit writes exist                                                                                 |
| Tenant App                  | Documents           | Documents Engine                          | Documents dashboard/report usage          | No evidence | No evidence | No evidence | No      | Planned         | No surface found                                                                                             |  | Tenant App | Reports | Reports | Reports module | Partial | Partial | Partial | No | Planned/Partial | `ViewReports` cap postoji, ali usage nije jasan |
| Tenant App                  | Shared UI           | Photos                                    | Photo/avatar pipeline                     | Yes         | Yes         | Yes         | Yes     | Polished        | Standardizovan `PersonThumb/usePersonPhoto/mediaStore` pipeline                                              |
| Player Portal App           | Player Portal       | Login / player guard                      | Player login                              | Yes         | Yes         | Yes         | Yes     | Verified        | Manual docs confirm dashboard after login                                                                    |
| Player Portal App           | Player Portal       | Login / player guard                      | Player-only route guard                   | Yes         | Partial     | Yes         | Partial | Needs cleanup   | Duplicate/inconsistent guard logic                                                                           |
| Player Portal App           | Player Portal       | Login / player guard                      | Token storage/auth boot                   | Yes         | Yes         | Yes         | Yes     | Implemented     | Works through JWT + `/player/me` boot                                                                        |
| Player Portal App           | Player Portal       | App shell / dashboard                     | Dashboard                                 | Yes         | Yes         | Yes         | Yes     | Verified        | Core flow manually documented                                                                                |
| Player Portal App           | Player Portal       | Profile                                   | Profile page                              | Yes         | Yes         | Yes         | Yes     | Verified        | Core flow manually documented                                                                                |
| Player Portal App           | Player Portal       | Profile                                   | Player profile endpoint usage             | Yes         | No          | Yes         | No      | Backend only    | FE uses `/player/me`, not `/player/profile`                                                                  |
| Player Portal App           | Player Portal       | Events                                    | Events list                               | Yes         | Yes         | Yes         | Yes     | Verified        | Core flow manually documented                                                                                |
| Player Portal App           | Player Portal       | Events                                    | Event detail                              | Yes         | Yes         | Yes         | Partial | Implemented     | Detail route/source exists; explicit manual detail evidence not found                                        |
| Player Portal App           | Player Portal       | Attendance                                | Attendance summary/list                   | Yes         | Yes         | Yes         | Yes     | Verified        | Manual docs confirm attendance; locked-only rule remains open                                                |
| Player Portal App           | Player Portal       | Finance / članarine                       | Finance summary/list                      | Yes         | Yes         | Yes         | Yes     | Verified        | Manual docs confirm finance                                                                                  |
| Player Portal App           | Player Portal       | Club logo                                 | Club logo display                         | Yes         | Yes         | Yes         | Partial | Implemented     | API/FE/DB confirmed; manual logo-specific test not explicit                                                  |
| Player Portal App           | Player Portal       | Profile photo                             | Profile photo display                     | Yes         | Partial     | Yes         | Partial | Needs cleanup   | Uses `usePersonPhoto` but manual `<img>`, not `PersonThumb`                                                  |
| Player Portal App           | Player Portal       | Notifications                             | Notifications page/mock/API               | No evidence | Placeholder | No evidence | No      | Planned         | Mock-only UI                                                                                                 |
| Player Portal App           | Player Portal       | Password reset                            | Password reset route/link                 | Yes         | Partial     | Yes         | No      | Needs cleanup   | Backend exists; FE route missing                                                                             |
| Player Portal App           | Player Portal       | Role guards / access control              | Role guard consistency                    | Yes         | Partial     | Yes         | Partial | Needs cleanup   | Consolidate guard behavior                                                                                   |
| Player Portal App           | Player Portal       | Cleanup / legacy files                    | Legacy/duplicate player-fe files          | No evidence | Partial     | No evidence | No      | Needs cleanup   | Unused old files remain                                                                                      |
| Admin App                   | Platform Management | Access                                    | Admin login / role gate                   | Yes         | Yes         | Yes         | Partial | Implemented     | Login and admin route gate exist; manual negative tests still needed                                         |
| Admin App                   | Platform Management | Dashboard                                 | Admin dashboard                           | No evidence | Placeholder | No evidence | No      | Planned         | Active route/nav, no real page/API                                                                           |
| Admin App                   | Platform Management | Clubs                                     | Club list/search/filter                   | Yes         | Partial     | Yes         | Partial | Needs cleanup   | Query parameter mismatch risk                                                                                |
| Admin App                   | Platform Management | Clubs                                     | Club create/update/deactivate             | Yes         | Yes         | Yes         | Partial | Implemented     | No hard delete evidence                                                                                      |
| Admin App                   | Platform Management | Club details                              | Club details                              | Yes         | Partial     | Yes         | Partial | Needs cleanup   | Detail works; billing tabs placeholder                                                                       |
| Admin App                   | Platform Management | Club logo                                 | Club logo display/upload/delete           | Yes         | Yes         | Yes         | Partial | Implemented     | No magic-byte validation found                                                                               |
| Admin App                   | Platform Management | Club users                                | Club users list/bootstrap/set password    | Partial     | Partial     | Yes         | Partial | Needs cleanup   | Missing lifecycle endpoints/caps; stub detail                                                                |
| Admin App                   | Platform Management | Feature toggles                           | Club feature toggles                      | Partial     | Yes         | Yes         | Partial | Needs cleanup   | Missing explicit cap/allowlist                                                                               |
| Admin App                   | Platform Management | Admin users                               | Admin users page/API                      | Partial     | Placeholder | Yes         | No      | Planned/Partial | Create/set-password partial; no real page/list                                                               |
| Admin App                   | Platform Management | Roles                                     | Roles page/API                            | Partial     | Placeholder | Yes         | No      | Planned/Partial | Read-only API only                                                                                           |
| Admin App                   | Platform Management | Audit                                     | Audit logs page/API                       | Yes         | Placeholder | Yes         | No      | Planned/Partial | API exists, FE placeholder                                                                                   |
| Admin App                   | Platform Management | Settings                                  | Admin settings page/API                   | Yes         | Placeholder | Yes         | No      | Planned/Partial | API exists, FE placeholder                                                                                   |
| Admin App                   | Platform Management | Seasons                                   | Admin seasons page/API                    | Yes         | Placeholder | Yes         | No      | Planned/Partial | Backend CRUD exists, FE placeholder                                                                          |
| Platform Billing            | Billing             | Plans                                     | Plan list                                 | Yes         | Yes         | Yes         | Partial | Implemented     | Active list API/page                                                                                         |
| Platform Billing            | Billing             | Plans                                     | Plan create/update/activate/deactivate    | Yes         | Yes         | Yes         | Partial | Implemented     | No hard delete found                                                                                         |
| Platform Billing            | Billing             | Plans                                     | Plan pricing/billing cycle                | Partial     | Yes         | Yes         | Partial | Needs cleanup   | Yearly behavior not clearly enforced                                                                         |
| Platform Billing            | Billing             | Subscriptions                             | Subscription list                         | Yes         | Yes         | Yes         | Partial | Implemented     | Active API/page                                                                                              |
| Platform Billing            | Billing             | Subscriptions                             | Subscription create/change/cancel         | Partial     | Yes         | Yes         | Partial | Needs cleanup   | Scheduled change not implemented                                                                             |
| Platform Billing            | Billing             | Subscriptions                             | Subscription status behavior              | Partial     | Partial     | Yes         | Partial | Needs cleanup   | Trial/cancel yes; past_due unclear                                                                           |
| Platform Billing            | Billing             | Admin invoices                            | Invoice list/detail                       | Yes         | Partial     | Yes         | Partial | Implemented     | API detail exists; FE list only                                                                              |
| Platform Billing            | Billing             | Admin invoices                            | Invoice create/void/mark-paid             | Partial     | Yes         | Yes         | Partial | Needs cleanup   | No update/delete; zero amount allowed                                                                        |
| Platform Billing            | Billing             | Admin invoices                            | Invoice finalize                          | Yes         | No          | Yes         | No      | Backend only    | Backend endpoint exists                                                                                      |
| Platform Billing            | Billing             | Admin invoices                            | Invoice status calculation                | Partial     | Partial     | Yes         | Partial | Needs cleanup   | Stored/computed status drift risk                                                                            |
| Platform Billing            | Billing             | Invoice payments                          | Payment add/edit/delete                   | Yes         | Yes         | Yes         | Partial | Implemented     | Nested payments modal active                                                                                 |
| Platform Billing            | Billing             | Invoice payments                          | Payment storno/reversal                   | No          | No          | No          | No      | Planned         | No platform storno evidence                                                                                  |
| Platform Billing            | Billing             | Standalone payments                       | Standalone payments page/API              | No evidence | Placeholder | Partial     | No      | Planned/Partial | `/payments` placeholder; payments are invoice-bound                                                          |
| Platform Billing            | Billing             | Ops / finalize                            | Ops/finalize workflow                     | Yes         | No          | Yes         | No      | Backend only    | API/background runner exist                                                                                  |
| Platform Billing            | Billing             | Exports                                   | Billing exports                           | No evidence | No evidence | No evidence | No      | Planned         | No platform billing export evidence                                                                          |
| Platform Billing            | Billing             | Dashboard                                 | Billing dashboard/summary                 | No evidence | No evidence | Partial     | No      | Planned         | No dedicated platform billing dashboard                                                                      |
| Platform Billing            | Billing             | Security/Audit                            | Billing permissions/audit                 | Partial     | Partial     | Yes         | No      | Needs cleanup   | Caps exist; FE caps/audit logging incomplete                                                                 |
| Planned / UI-only / Cleanup | UI-only             | Notifications                             | Notifications                             | No          | UI-only     | No          | No      | Planned         | Topbar dugme postoji, nema potvrđene akcije                                                                  |
| Planned / UI-only / Cleanup | UI-only             | Help                                      | Help / support UI                         | No          | UI-only     | No          | No      | Planned         | Topbar dugme postoji, nema potvrđene akcije                                                                  |
| Planned / UI-only / Cleanup | UI-only             | Global Search                             | Global search                             | No          | UI-only     | No          | No      | Planned         | Topbar input postoji, nema potvrđenog search ponašanja                                                       |

---

## Module notes

## Backend/API Audit Evidence — Tenant App / People

Audit source:

```text
Backend/API source:
 /mnt/c/Users/kemo/source/repos/WEB/ClubManager/src

Database schema dump:
 /home/kemo/ClubManager/docs/database/shema.sql
```

Potvrđeno vidljivo u auditu:

- controllers
- services
- DTOs
- entities/models
- DbContext
- migrations/configurations
- database schema dump
- Swagger/OpenAPI konfiguracija

Zaključak audita:

- Backend/API evidence za većinu `Tenant App → People` funkcionalnosti je sada potvrđen.
- Prethodni `BE = Partial / No evidence` nalazi iz FE-only audita više nisu važeći kao konačan zaključak za backend.
- `BE = Yes` je opravdan za Player CRUD, player photo, registracije, ljekarske, dokumente, ugovore, contract verification i Eligibility Lite.
- `DB = Yes` je opravdan za većinu People funkcionalnosti jer schema dump potvrđuje realne tabele/kolone/relacije.
- `Partial` ostaje tamo gdje je audit našao stvarni backend/security/validation rizik, a ne zato što source nije bio vidljiv.

Rizici iz backend/API audita:

| Priority  | Area                  | Nalaz                                                                            | Inventory impact                                           |
| --------- | --------------------- | -------------------------------------------------------------------------------- | ---------------------------------------------------------- |
| Critical  | Player Portal         | `PlayerPortalAdminService` nema eksplicitan club filter i koristi `app.is_admin` | `BE = Partial`, `Status = Needs cleanup`                   |
| Important | Staff                 | Staff write permisije koriste `ManagePlayers` umjesto `ManageStaff`              | `BE = Partial`, `Status = Needs cleanup`                   |
| Important | Staff                 | `staff.jmbg` je u DB `NOT NULL`, dok DTO/entity dopuštaju nullable               | `DB/validation = Partial`                                  |
| Important | Documents             | Service podržava `Club` dokumente, schema dopušta `Player/Staff`                 | Documents Engine cleanup, nije blocker za Player documents |
| Important | Team staff assignment | `ArgumentException` može izaći kao 500 umjesto kontrolisanog 400                 | `BE = Partial`, `Status = Needs cleanup`                   |
| Minor     | Players/Staff         | JMBG validacija je format + uniqueness, bez checksum/date consistency            | JMBG validation ostaje `Partial`                           |

---

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

Status: `Verified functional flow / Needs backend cleanup`

Potvrđeno funkcionalno:

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

Backend/API audit nalaz:

- Tenant-side portal endpointi postoje:
  - `POST /api/players/{id}/portal/activate`
  - `POST /api/players/{id}/portal/deactivate`
  - `GET /api/players/{id}/portal`
- DB evidence postoji kroz `players.user_id`, `users`, `roles` i `user_roles`.
- Controller traži `ManageUsers`.
- `PlayerPortalAdminService` nema eksplicitan club filter na player lookup-u i koristi `SET LOCAL app.is_admin='1'`.

Potrebna API dorada:

- kod reaktivacije, ako se mijenja portal email, backend treba provjeriti da novi email već ne koristi drugi korisnik.
- nova aktivacija već provjerava jedinstvenost emaila, ali reaktivacija treba imati istu zaštitu za `users.email`.
- `PlayerPortalAdminService` mora eksplicitno filtrirati igrača po `playerId + clubId` prije bilo kakve aktivacije/deaktivacije/status operacije.
- zbog cross-club rizika, inventory status za tenant-side portal activation ostaje `Needs cleanup`, iako je funkcionalni flow ručno testiran.

Zaključak:

```text
Player Portal CORE flow je funkcionalno provjeren, ali tenant-side activation API ne treba označiti kao potpuno Verified/Polished dok se ne zatvori cross-club rizik u backend servisu.
```

---

### Players — trenutni rezultat verifikacije

Status: `Implemented`

Potvrđeno iz Backend/API audita:

- `PlayersController` potvrđuje `/api/players` CRUD endpoint-e.
- `PlayerService`, `Player` entity i `players` tabela su vidljivi.
- `players` schema potvrđuje `club_id`, `jmbg`, `birth_date`, `photo_url` i RLS podršku.
- Player CRUD je club-scoped kroz servis.
- Create/update validacija postoji.
- Duplicate JMBG check postoji unutar kluba.
- Player photo endpointi su potvrđeni:
  - `POST /api/players/{id}/photo`
  - `GET /api/players/{id}/photo`
  - `DELETE /api/players/{id}/photo`
- Player registrations, medicals, documents, contracts i Eligibility Lite imaju potvrđen backend/API i DB evidence.

Potvrđeno iz Tenant FE audita:

- player list route postoji.
- player create route postoji.
- player edit route postoji.
- player detail route postoji.
- delete flow postoji u FE.
- player detail tabovi postoje.
- player photo koristi verificirani photo pipeline.

JMBG nalaz:

- Backend potvrđuje format i uniqueness po klubu.
- Nije pronađena puna semantička validacija:
  - checksum
  - datum izveden iz JMBG-a
  - birthDate consistency
  - gender consistency

Potrebna provjera / cleanup:

- postoje dva create flow-a: routed `PlayerCreatePage` i stariji modal create u `PlayersPage`.
- birth date auto-fill iz JMBG-a postoji u starijem modal create flow-u, ali nije potvrđen u primarnom `PlayerForm`.
- `PlayerCreatePage` još sadrži DEV marker / `console.log`.
- `PlayersPage` lista koristi lokalni thumb wrapper sa `usePersonPhoto`; ponašanje je standardno, ali wrapper nije `PersonThumb`.

Zaključak:

```text
Players backend/API i DB su sada potvrđeni kao Implemented. JMBG validation ostaje Partial jer validira format i unikatnost, ali ne punu semantiku JMBG-a. Functional verification kroz aplikaciju i dalje je potrebna prije statusa Verified.
```

---

### Staff — trenutni rezultat surface/UX audita

Status: `Implemented / Needs cleanup`

Potvrđeno iz Backend/API audita:

- `StaffController` potvrđuje `/api/staff` CRUD endpoint-e.
- `StaffService`, `Staff` entity i `staff` tabela su vidljivi.
- `staff` schema potvrđuje `club_id`, `jmbg`, `photo_url` i RLS podršku.
- Staff CRUD je club-scoped kroz servis.
- Staff photo endpointi su potvrđeni:
  - `POST /api/staff/{id}/photo`
  - `GET /api/staff/{id}/photo`
  - `DELETE /api/staff/{id}/photo`
- Team staff assignment backend postoji kroz `TeamStaffMembershipsController` i `TeamStaffMembershipService`.
- `team_staff_memberships` tabela postoji u schema dump-u.

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

- Backend Staff create/edit/delete koristi `ManagePlayers`, iako postoji `ManageStaff`.
- Team staff assignment koristi `ManageTeams`.
- `/staff/:id/edit` ruta nije client-side zaštićena sa `RequireCap`.
- Staff permisije treba uskladiti prije statusa `Verified`.

Djelimično / nejasno:

- Staff detail dugme/sekcija “Dodijeli ekipi” je placeholder alert.
- Pravi assignment osoblja u ekipu radi kroz Team detail, ne kroz Staff detail.
- Quick create modal prikuplja manje polja nego edit forma.
- Country handling postoji u edit formi, ali ne u quick create modalu.
- Nije pronađen JMBG birth-date auto-fill za Staff.
- `StaffForm mode="create"` postoji, ali nije jasno da li se koristi kroz aktivnu rutu.
- Staff list prima `role`/`sort`, ali backend audit nije potvrdio da se oba potpuno primjenjuju u servisu.

Validation / DB rizici:

- Staff JMBG validacija postoji, ali nije semantička.
- `staff.jmbg` je u bazi `NOT NULL`, dok DTO/entity tretiraju JMBG kao nullable.
- Quick create i edit forma imaju različit UX validacije.
- Team staff assignment ima realan backend, ali error handling može vratiti 500 umjesto kontrolisanog 400.

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
Staff modul ima backend/API i DB osnovu, ali ostaje Needs cleanup zbog permisija, validation/schema mismatch-a, placeholdera i neujednačenog UX-a. Prije statusa Verified treba ručno testirati CRUD, photo workflow, validacije, permisije i team staff assignment.
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

| Area          | Candidate                                                                 |
| ------------- | ------------------------------------------------------------------------- |
| Players       | duplicate create flow                                                     |
| Players       | JMBG auto-fill missing from primary `PlayerForm`                          |
| Players       | DEV marker / `console.log` in `PlayerCreatePage`                          |
| Player Portal | tenant-side activation cross-club backend risk                            |
| Staff         | backend uses `ManagePlayers` instead of `ManageStaff`                     |
| Staff         | `staff.jmbg` DB/DTO nullability mismatch                                  |
| Documents     | service supports Club documents while schema allows Player/Staff          |
| Team Staff    | backend error handling can return 500 instead of controlled 400           |
| Staff         | quick create vs edit form mismatch                                        |
| Staff         | missing client-side route guard on `/staff/:id/edit`                      |
| Staff         | staff detail team assignment placeholder                                  |
| Events        | `EventAttendancePage.tsx` exists but is not routed                        |
| Finance       | `FinanceTransactionsPage.tsx` exists but route uses `FinTransactionsPage` |
| Finance       | endpoint naming is split across `finance`, `fin`, and `fees`              |
| Topbar        | `Pomoć`, `Obavijesti`, global search are UI-only                          |
| Permissions   | `ViewReports` usage unclear                                               |
| Permissions   | `ManageRegistrations` usage unclear                                       |
| Admin FE      | placeholder routes exist in sidebar                                       |
| Player FE     | notifications mock, missing password reset route, duplicate guards        |
| Dev           | dev/debug endpoints should be checked for environment exposure            |

---

## Verification status summary

| Area                           | Module                         | Current status                                   |
| ------------------------------ | ------------------------------ | ------------------------------------------------ |
| Platform / System              | Documentation                  | Verified                                         |
| Platform / System              | System Surface Map             | Implemented                                      |
| Tenant App                     | Photo/avatar pipeline          | Polished                                         |
| Tenant App                     | Shared UI / Photos             | Polished                                         |
| Tenant App / Player Portal App | Player Portal CORE             | Verified functional flow / needs backend cleanup |
| Player Portal App              | Player FE core pages           | Verified                                         |
| Player Portal App              | Player FE notifications        | Planned/Mock                                     |
| Player Portal App              | Player FE password reset route | Needs cleanup                                    |
| Player Portal App              | Player FE role guards          | Needs cleanup                                    |
| Tenant App                     | Players                        | Implemented / backend confirmed                  |
| Tenant App                     | Staff                          | Implemented / Needs cleanup                      |
| Tenant App                     | Teams                          | Implemented                                      |
| Tenant App                     | Events                         | Implemented / Needs cleanup                      |
| Tenant App                     | Attendance                     | Implemented / Needs cleanup                      |
| Tenant App                     | Lineup                         | Implemented / Needs cleanup                      |
| Tenant App                     | Documents                      | Implemented                                      |
| Tenant App                     | Contracts                      | Implemented                                      |
| Tenant App                     | Medicals                       | Implemented                                      |
| Tenant App                     | Registrations                  | Implemented                                      |
| Tenant App                     | Eligibility Lite               | Implemented                                      |
| Tenant App                     | Finance Fees                   | In progress                                      |
| Tenant App                     | General Finance                | Implemented / needs verification                 |
| Tenant App                     | Tenant Users                   | Implemented                                      |
| Admin App                      | Admin FE core clubs/billing    | Implemented                                      |
| Admin App                      | Admin FE placeholders          | Planned/Partial                                  |
| Admin App                      | Admin Platform API             | Implemented / needs verification                 |
| Platform Billing               | Platform Billing               | Implemented / needs verification                 |
| Tenant App                     | Reports                        | Planned/Partial                                  |
| Planned / UI-only / Cleanup    | Notifications                  | Planned                                          |
| Planned / UI-only / Cleanup    | Help                           | Planned                                          |
| Planned / UI-only / Cleanup    | Global Search                  | Planned                                          |

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
