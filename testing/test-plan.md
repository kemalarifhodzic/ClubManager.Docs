# ClubManager Test Plan

Ovaj dokument definiše test strategiju za ClubManager nakon završenog FE surface, Backend/API i DB schema audita.

Primarni cilj trenutno nije testiranje kompletne platforme, nego priprema prve produkcijske verzije za klubove.

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

Release 1 obuhvata:

* Dashboard
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
* Tenant finance / članarine
* Tenant users minimalno
* Basic permissions behavior

---

## Deferred for later releases

Ove oblasti nisu dio prvog produkcijskog test fokusa:

| Release             | Scope                                                                      |
| ------------------- | -------------------------------------------------------------------------- |
| R1.5 Player Portal  | Player Portal rollout nakon stabilizacije Tenant App-a                     |
| R2 Admin Platform   | Admin dashboard, roles, audit, settings, seasons, admin polish             |
| R3 Platform Billing | Plans, subscriptions, platform invoices, platform payments, billing audit  |
| Later               | Notifications, advanced reports, standalone payments, advanced admin tools |

Player Portal CORE postoji i ima ranije manual evidence, ali nije prioritet za prvo produkcijsko puštanje. Prvo se stabilizuje Tenant App za sekretara i vlasnika kluba.

---

## Test approach

Testiranje se dijeli na dva paralelna toka:

| Tok                     | Radi    | Svrha                                                     |
| ----------------------- | ------- | --------------------------------------------------------- |
| Functional verification | Tester  | Provjerava stabilne korisničke tokove u Tenant App-u      |
| Cleanup / fixes         | Dev tim | Rješava poznate P0/P1 probleme prije finalne verifikacije |

Tester ne treba dokazivati bugove koje već znamo. Ako je problem već u cleanup backlogu, test ga označava kao `Blocked` ili se preskače dok se ne popravi.

---

## Test status legenda

| Status       | Značenje                                               |
| ------------ | ------------------------------------------------------ |
| Not tested   | Test još nije izvršen                                  |
| Passed       | Test je prošao                                         |
| Failed       | Test nije prošao                                       |
| Blocked      | Test se ne može izvršiti zbog poznatog problema        |
| Needs retest | Test je ranije pao ili je kod mijenjan; treba ponoviti |
| Deferred     | Svjesno odloženo                                       |

---

## Pravilo za Verified status

Feature može preći u `Verified` samo ako:

1. FE/API/DB surface postoji.
2. Nema otvoren P0 blocker za taj feature.
3. P1 blocker je riješen ili svjesno odložen.
4. Tester ili dev ručno prođe stvarni korisnički tok.
5. Rezultat je upisan u checklistu.

Surface audit sam po sebi ne znači `Verified`.

---

## Šta tester može testirati odmah

| Test package            | Status              | Notes                                                                 |
| ----------------------- | ------------------- | --------------------------------------------------------------------- |
| Tenant MVP basic flow   | Ready with warnings | Glavni paket za Release 1                                             |
| People basic flow       | Ready with warnings | Ne tretirati JMBG semantic edge-case kao blocker ako nije finalizovan |
| Teams basic flow        | Ready with warnings | Osnovni flow može; edge-case validacije poslije cleanup-a             |
| Events basic flow       | Ready with warnings | Osnovni flow može; lifecycle/complete edge-case poslije cleanup-a     |
| Documents player flow   | Ready with warnings | Ne testirati Club documents kao R1 feature                            |
| Finance fees basic flow | Ready with warnings | Testirati članarine, ne Platform Billing                              |
| Dashboard basic flow    | Ready with warnings | Testirati osnovni prikaz i navigaciju                                 |

---

## Šta ne testirati kao final verification za Release 1

| Area                                | Reason                            |
| ----------------------------------- | --------------------------------- |
| Player Portal rollout               | Odloženo za R1.5                  |
| Admin Platform full verification    | Odloženo za R2                    |
| Platform Billing                    | Odloženo za R3                    |
| Notifications                       | Mock/planned                      |
| Password reset                      | Poznat FE/backend mismatch        |
| Club documents                      | Service/schema mismatch           |
| Dev diagnostics                     | Security cleanup pending          |
| Platform/System security edge cases | Rješavati ciljano nakon cleanup-a |
| Admin placeholder pages             | Nisu R1 fokus                     |

---

## Tester reporting format

Za svaki `Failed` ili `Blocked` test navesti:

```text
Test ID:
Status:
Environment:
User / role:
URL:
Steps:
Expected result:
Actual result:
Screenshot:
Notes:
```

---

## Test environment

| Field         | Value |
| ------------- | ----- |
| Environment   | DEV   |
| API           |       |
| Tenant FE URL |       |
| Browser       |       |
| Tester        |       |
| Test date     |       |
| Club          |       |
| Club user     |       |
| Notes         |       |

---

## Current priority

1. Tenant MVP basic checklist
2. Retest nakon P0/P1 cleanup-a
3. Finance Fees targeted verification
4. Documents targeted verification
5. Permission/security targeted verification
6. Player Portal R1.5 checklist kasnije

---

## Release 1 exit criteria

Release 1 može ići prema produkciji kada:

* Tenant login radi stabilno.
* Dashboard se učitava bez greške.
* Players/Staff osnovni CRUD radi.
* Teams i memberships osnovno rade.
* Events i attendance osnovno rade.
* Documents za Player rade za osnovni upload/download/replace/delete flow.
* Finance Fees osnovni tok radi: bulk invoice, quick pay, storno, refresh.
* Tenant users minimalni flow radi ili je jasno ograničen.
* Nema otvorenih P0 cleanup stavki koje direktno ugrožavaju Tenant App.
* Kritični P1 problemi su riješeni ili svjesno odloženi.
* Inventory i module-status su ažurirani prema rezultatima testiranja.
