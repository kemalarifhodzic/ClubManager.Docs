# ClubManager Product Inventory

```text
Evo starter scenariji za preostalih 10 stavki. Kopiraj u Scenario / Expected result, a ti kao tester popunjavaš Actual result.
```

## TA-2026-0001-002 · WorkOrder: TA-2026-0001 — People Audit – Players

#### INV-0041 — JMBG validation

Scenario: Kreirati/izmijeniti igrača sa ispravnim i neispravnim JMBG unosom. Provjeriti obaveznost, dužinu 13 cifara i duplikat u istom klubu.
Expected result: Sistem prihvata validan JMBG, odbija nevalidan/duplikat i jasno prikazuje grešku.

#### INV-0042 — Birth date handling

Scenario: Unijeti datum rođenja ručno i kroz JMBG ako postoji auto-fill. Sačuvati igrača i ponovo otvoriti profil.
Expected result: Datum rođenja se ispravno snima, prikazuje i ne mijenja format pogrešno.

#### INV-0043 — Player detail profile

Scenario: Otvoriti profil igrača iz liste. Provjeriti osnovne podatke, tabove i povratak na listu.
Expected result: Detalj igrača se otvara bez greške i prikazuje tačne podatke.

#### INV-0044 — Player photo

Scenario: Uploadovati sliku igrača, provjeriti prikaz u listi/detalju, zatim obrisati ili zamijeniti sliku.
Expected result: Slika se prikazuje tačno, cache se osvježava, delete/replace radi bez stare slike.

#### INV-0045 — Player registrations

Scenario: Dodati registraciju igraču, izmijeniti je i provjeriti prikaz aktivne registracije. Testirati konflikt ako postoji već aktivna registracija.
Expected result: Registracija se snima, prikazuje i validacije sprječavaju neispravne/duple aktivne zapise.

#### INV-0046 — Player medical records

Scenario: Dodati ljekarski pregled sa datumom važenja. Provjeriti izmjenu i prikaz statusa/uticaj na pravo nastupa.
Expected result: Ljekarski zapis se snima, prikazuje i pravilno utiče na eligibility gdje je primjenjivo.

#### INV-0047 — Player documents tab

Scenario: Uploadovati dokument, provjeriti pregled/preuzimanje, zamjenu, deaktivaciju/brisanje gdje je dostupno.
Expected result: Dokumenti se ispravno snimaju, prikazuju i lifecycle akcije rade bez gubitka pogrešnog fajla.

#### INV-0048 — Contracts module

Scenario: Dodati ugovor igraču, provjeriti obavezna polja, tip ugovora, izmjenu i prikaz u listi/profilu.
Expected result: Ugovor se snima i prikazuje ispravno, bez debug poruka ili nejasnih grešaka.

#### INV-0049 — Contract verification

Scenario: Verifikovati ugovor i pokušati izmjenu nakon verifikacije. Provjeriti ko smije verifikovati.
Expected result: Verifikovan ugovor dobija ispravan status i zaključava kritične izmjene prema pravilima.

#### INV-0050 — Eligibility Lite

Scenario: Provjeriti pravo nastupa za igrača sa kombinacijama: validna registracija + validan ljekarski, bez registracije, istekao ljekarski.
Expected result: Eligibility jasno prikazuje valid/invalid stanje i razlog zbog kojeg igrač nema pravo nastupa.
