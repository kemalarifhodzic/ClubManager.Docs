# Test Order 002 — Player Basic Flow

## Basic info

| Field           | Value                                                     |
| --------------- | --------------------------------------------------------- |
| Assignment ID   | TA-2026-0002                                              |
| Test order file | `docs/testing/orders/test-order-002-player-basic-flow.md` |
| Release         | R1 Tenant Production                                      |
| Area            | Tenant App                                                |
| Domain          | People                                                    |
| Module          | Players                                                   |
| Test type       | Functional basic flow                                     |
| Tester          | Kemo                                                      |
| Environment     | DEV                                                       |
| Status          | Ready                                                     |
| Overall result  | Not tested                                                |

---

## Source

This test order is issued from:

```text
docs/product/module-status.md → Ready for Testing
```

The tested items are linked to Inventory IDs from:

```text
docs/product/clubmanager-inventory.md
```

---

## Covered Inventory IDs

Each Inventory ID below must also have exactly one corresponding row in:

```text
docs/product/module-status.md → Ready for Testing
```

| Inventory ID | Feature               | Verification target                                                                                    | Expected verification level                                       |
| ------------ | --------------------- | ------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------- |
| INV-0040     | Player CRUD           | Osnovni tok: lista, pretraga, kreiranje, izmjena, refresh i brisanje ili kontrolisana zabrana brisanja | Full for basic CRUD                                               |
| INV-0041     | JMBG validation       | Trenutna R1 pravila: format i dupli JMBG u istom klubu                                                 | Partial if semantic checksum/date validation remains out of scope |
| INV-0042     | Birth date handling   | Čuvanje, prikaz, izmjena i ponovno učitavanje datuma rođenja                                           | Full                                                              |
| INV-0043     | Player detail profile | Otvaranje player detail profila i prikaz tačnih osnovnih podataka                                      | Full for basic profile view                                       |

---

## Goal

Potvrditi da sekretar ili menadžer kluba može završiti osnovni tok rada sa igračima u Tenant App-u:

* otvoriti listu igrača
* pretražiti/filtrirati igrače
* kreirati novog testnog igrača
* potvrditi ponašanje JMBG validacije
* potvrditi čuvanje i prikaz datuma rođenja
* otvoriti player detail profil
* izmijeniti osnovne podatke igrača
* obrisati testnog igrača ili dobiti kontrolisanu poruku ako je brisanje blokirano

Ovaj test order ne verifikuje dokumente, registracije, ljekarske preglede, ugovore, eligibility ili fotografiju igrača.

---

## Do not test

Ne testirati ove tokove u ovom assignmentu:

* upload/delete fotografije igrača
* dokumenti igrača
* registracije igrača
* ljekarski pregledi
* ugovori
* contract verification
* eligibility
* staff
* teams
* events
* attendance
* finance
* Player Portal
* Admin App
* Platform Billing

Ti tokovi imaju posebne Inventory ID-jeve i verifikuju se kroz posebne Ready for Testing redove i posebne test ordere.

---

## Test data

Koristiti jasno označenog testnog igrača.

| Field      | Suggested value                                                     |
| ---------- | ------------------------------------------------------------------- |
| First name | Test                                                                |
| Last name  | PlayerBasic                                                         |
| Gender     | M ili F, prema dostupnim opcijama u formi                           |
| Birth date | Važeći datum koji forma prihvata                                    |
| JMBG       | Važeći 13-cifreni testni JMBG koji već ne postoji u klubu           |
| Email      | [test.playerbasic@example.com](mailto:test.playerbasic@example.com) |
| Phone      | 061000111                                                           |
| Position   | Test position                                                       |
| Notes      | Created by TA-2026-0002                                             |

Ako testno okruženje već ima dogovorenu konvenciju za fake/test JMBG, koristiti tu konvenciju.

---

## Context steps

Context steps služe samo da tester dođe do funkcionalnosti koja se testira.
Oni ne verifikuju druge Inventory ID-jeve.

| Step ID | Context action                                            | Expected result              | Result     | Notes                                                      |
| ------- | --------------------------------------------------------- | ---------------------------- | ---------- | ---------------------------------------------------------- |
| CTX-001 | Prijaviti se u Tenant App kao validan club korisnik.      | Korisnik ulazi u Tenant App. | Not tested | Context only.                                              |
| CTX-002 | Otvoriti navigaciju/sidebar i kliknuti na Players/Igrači. | Otvara se Players stranica.  | Not tested | Context only unless TPL-001 confirms player list behavior. |

---

# INV-0040 — Player CRUD

## Scope

Ova sekcija verifikuje osnovni Player CRUD tok.

Ne verifikuje dokumente, registracije, ljekarske preglede, ugovore, eligibility ili fotografiju.

| Step ID | Inventory ID | Scenario                                                                                     | Expected result                                                                          | Result     | Actual result / Notes |
| ------- | ------------ | -------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- | ---------- | --------------------- |
| TPL-001 | INV-0040     | Otvoriti Players/Igrači stranicu.                                                            | Lista igrača se učitava bez fatalne greške.                                              | Not tested |                       |
| TPL-002 | INV-0040     | Pretražiti/filtrirati igrače po imenu, prezimenu ili JMBG-u.                                 | Prikazuju se odgovarajući rezultati ili jasan empty state bez greške.                    | Not tested |                       |
| TPL-003 | INV-0040     | Kliknuti Add/Create Player i otvoriti formu za igrača.                                       | Forma se otvara bez starih/pogrešnih podataka iz prethodnog unosa.                       | Not tested |                       |
| TPL-004 | INV-0040     | Kreirati novog testnog igrača sa validnim obaveznim podacima.                                | Igrač se uspješno snima.                                                                 | Not tested |                       |
| TPL-005 | INV-0040     | Vratiti se na listu igrača i pronaći kreiranog testnog igrača.                               | Kreirani igrač se prikazuje u listi/pretrazi.                                            | Not tested |                       |
| TPL-006 | INV-0040     | Refresh browsera i ponovno traženje/otvaranje kreiranog igrača.                              | Kreirani igrač ostaje vidljiv nakon refresha.                                            | Not tested |                       |
| TPL-007 | INV-0040     | Izmijeniti osnovne podatke igrača, npr. telefon, email, poziciju ili notes.                  | Izmjene se uspješno snimaju.                                                             | Not tested |                       |
| TPL-008 | INV-0040     | Refresh stranice i ponovno otvaranje/edit istog igrača.                                      | Izmijenjene vrijednosti ostaju ispravno snimljene.                                       | Not tested |                       |
| TPL-009 | INV-0040     | Obrisati testnog igrača ili pokušati brisanje ako dependencies/permissions blokiraju akciju. | Igrač se briše ili aplikacija prikazuje jasnu kontrolisanu dependency/permission poruku. | Not tested |                       |

---

# INV-0041 — JMBG validation

## Scope

Ova sekcija verifikuje trenutno R1 ponašanje JMBG validacije.

Trenutni očekivani nivo: 13-cifreni format i kontrola duplog JMBG-a u istom klubu.
Puna semantička checksum/date validacija nije uslov za prolaz osim ako product odluka kaže drugačije.

| Step ID  | Inventory ID | Scenario                                                                                     | Expected result                                                                                        | Result     | Actual result / Notes |
| -------- | ------------ | -------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ | ---------- | --------------------- |
| JMBG-001 | INV-0041     | Pokušati snimiti igrača bez JMBG-a ako je polje obavezno po formi/business pravilu.          | Snimanje je blokirano jasnom validacionom porukom ili aplikacija prati dokumentovano nullable pravilo. | Not tested |                       |
| JMBG-002 | INV-0041     | Pokušati snimiti igrača sa JMBG-om kraćim ili dužim od 13 cifara.                            | Snimanje je blokirano jasnom validacionom porukom.                                                     | Not tested |                       |
| JMBG-003 | INV-0041     | Pokušati snimiti igrača sa slovima ili drugim non-digit znakovima u JMBG-u.                  | Snimanje je blokirano jasnom validacionom porukom.                                                     | Not tested |                       |
| JMBG-004 | INV-0041     | Pokušati kreirati drugog igrača sa istim JMBG-om u istom klubu.                              | Duplikat je blokiran kontrolisanom porukom; nema crash-a ili raw backend greške.                       | Not tested |                       |
| JMBG-005 | INV-0041     | Provjeriti da originalni igrač sa tim JMBG-om ostaje nepromijenjen nakon pokušaja duplikata. | Postojeći podaci igrača ostaju netaknuti.                                                              | Not tested |                       |

---

# INV-0042 — Birth date handling

## Scope

Ova sekcija verifikuje da se datum rođenja ispravno snima, prikazuje, mijenja i ponovo učitava.

Auto-popuna iz JMBG-a može se zabilježiti ako postoji, ali nije uslov za prolaz ovog Inventory ID-a osim ako product pravilo kaže drugačije.

| Step ID | Inventory ID | Scenario                                                                       | Expected result                                                                                      | Result     | Actual result / Notes |
| ------- | ------------ | ------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------- | ---------- | --------------------- |
| BDT-001 | INV-0042     | Unijeti važeći datum rođenja prilikom kreiranja testnog igrača.                | Datum rođenja je prihvaćen i igrač se uspješno snima.                                                | Not tested |                       |
| BDT-002 | INV-0042     | Otvoriti detail/profile kreiranog igrača.                                      | Datum rođenja je prikazan tačno.                                                                     | Not tested |                       |
| BDT-003 | INV-0042     | Otvoriti edit formu istog igrača.                                              | Datum rođenja se prikazuje tačno u edit formi.                                                       | Not tested |                       |
| BDT-004 | INV-0042     | Promijeniti datum rođenja na drugi važeći datum i snimiti.                     | Novi datum rođenja se uspješno snima.                                                                | Not tested |                       |
| BDT-005 | INV-0042     | Refresh stranice i ponovno otvaranje detail/edit forme.                        | Ažurirani datum rođenja ostaje tačan nakon refresha.                                                 | Not tested |                       |
| BDT-006 | INV-0042     | Ako postoji auto-popuna iz JMBG-a, unijeti JMBG i posmatrati ponašanje datuma. | Auto-popuna radi ispravno ako je implementirana; ako nije, upisati “not implemented / not in scope”. | Not tested |                       |

---

# INV-0043 — Player detail profile

## Scope

Ova sekcija verifikuje da se Player detail profil otvara i prikazuje tačne osnovne podatke.

Ostali tabovi mogu biti vidljivi kao kontekst, ali se ne verifikuju ovim test orderom.

| Step ID | Inventory ID | Scenario                                                                                                                                | Expected result                                                            | Result     | Actual result / Notes |
| ------- | ------------ | --------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------- | ---------- | --------------------- |
| PDP-001 | INV-0043     | Otvoriti kreiranog igrača iz Players liste.                                                                                             | Player detail/profile stranica se otvara bez fatalne greške.               | Not tested |                       |
| PDP-002 | INV-0043     | Uporediti prikazano ime, prezime, pol, datum rođenja i kontakt podatke sa snimljenim vrijednostima.                                     | Prikazani osnovni podaci odgovaraju snimljenim podacima.                   | Not tested |                       |
| PDP-003 | INV-0043     | Refresh player detail stranice.                                                                                                         | Detail stranica se ponovo učitava uredno i prikazuje podatke igrača.       | Not tested |                       |
| PDP-004 | INV-0043     | Napustiti detail stranicu i ponovo se vratiti na istog igrača.                                                                          | Isti profil se otvara ispravno.                                            | Not tested |                       |
| PDP-005 | INV-0043     | Ako su vidljivi tabovi/sekcije za dokumente, registracije, ljekarske, ugovore ili eligibility, samo potvrditi da ne ruše detail prikaz. | Tabovi mogu biti vidljivi, ali se duboka validacija ne radi u ovom orderu. | Not tested | Context only.         |

---

## Allowed result values

U `Result` kolonama koristiti samo:

```text
Passed
Failed
Blocked
Not tested
```

---

## Pass rules per Inventory ID

| Inventory ID | Pass rule                                                                                                                                                                                  |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| INV-0040     | Prolazi ako list/search/create/edit/refresh i delete ili kontrolisana zabrana brisanja rade bez fatalnih grešaka.                                                                          |
| INV-0041     | Prolazi parcijalno ako rade 13-cifreni format i duplicate-in-club validacija. Ne označavati kao full semantic JMBG Verified ako checksum/date consistency nije potvrđen kao product scope. |
| INV-0042     | Prolazi ako se datum rođenja snima, prikazuje, mijenja i ostaje tačan nakon refresha.                                                                                                      |
| INV-0043     | Prolazi ako se detail profil otvara i prikazuje tačne osnovne podatke nakon kreiranja, izmjene i refresha.                                                                                 |

---

## Failed / Blocked details

Popuniti ovu sekciju za svaki Failed ili Blocked test.

### Issue 1

| Field                 | Value            |
| --------------------- | ---------------- |
| Step ID               |                  |
| Inventory ID          |                  |
| Status                | Failed / Blocked |
| URL                   |                  |
| Steps                 |                  |
| Expected result       |                  |
| Actual result         |                  |
| Screenshot / evidence |                  |
| Notes                 |                  |

### Issue 2

| Field                 | Value            |
| --------------------- | ---------------- |
| Step ID               |                  |
| Inventory ID          |                  |
| Status                | Failed / Blocked |
| URL                   |                  |
| Steps                 |                  |
| Expected result       |                  |
| Actual result         |                  |
| Screenshot / evidence |                  |
| Notes                 |                  |

### Issue 3

| Field                 | Value            |
| --------------------- | ---------------- |
| Step ID               |                  |
| Inventory ID          |                  |
| Status                | Failed / Blocked |
| URL                   |                  |
| Steps                 |                  |
| Expected result       |                  |
| Actual result         |                  |
| Screenshot / evidence |                  |
| Notes                 |                  |

---

## Per-Inventory result summary

Tester popunjava ovu sekciju nakon što završi sve korake.

| Inventory ID | Feature               | Result     | Passed steps | Failed steps | Blocked steps | Notes |
| ------------ | --------------------- | ---------- | -----------: | -----------: | ------------: | ----- |
| INV-0040     | Player CRUD           | Not tested |              |              |               |       |
| INV-0041     | JMBG validation       | Not tested |              |              |               |       |
| INV-0042     | Birth date handling   | Not tested |              |              |               |       |
| INV-0043     | Player detail profile | Not tested |              |              |               |       |

---

## Tester sign-off

| Field                   | Value                                          |
| ----------------------- | ---------------------------------------------- |
| Tester                  | Kemo                                           |
| Date                    |                                                |
| Environment             | DEV                                            |
| Overall result          | Not tested / Passed / Failed / Blocked / Mixed |
| Passed Inventory count  |                                                |
| Failed Inventory count  |                                                |
| Blocked Inventory count |                                                |
| Notes                   |                                                |

---

## Processing note

Nakon što tester vrati ovaj fajl:

1. Ažurirati `docs/product/module-status.md → Ready for Testing`.
2. Za svaki Ready for Testing red sa `Assignment ID = TA-2026-0002`, ažurirati:

   * `Status`
   * `Result`
   * `Notes`
3. Dodati jedan summary red u `docs/product/module-status.md → Testing Results`.
4. Ako je neki Inventory ID `Failed` ili `Blocked`, kreirati ili ažurirati odgovarajući `Needs Cleanup` red sa istim `Inventory ID`.
5. `clubmanager-inventory.md` ažurirati samo po pojedinačnom Inventory ID rezultatu.
6. Ne ažurirati nepovezane inventory redove iz ovog test ordera.
7. Ne označavati dokumente, registracije, ljekarske, ugovore, eligibility ili player photo kao Verified iz ovog assignmenta.
