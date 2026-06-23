# TA-2026-0001 — People Audit – Players

## INV-0041 — Players — JMBG validation

### Scenario

Kreirati ili izmijeniti igrača sa ispravnim i neispravnim JMBG unosom. Provjeriti dužinu od 13 cifara, validaciju formata i duplikat unutar istog kluba.

### Expected result

Sistem prihvata validan JMBG. Neispravan ili dupliran JMBG se odbija uz jasnu poruku o grešci.

---

## INV-0042 — Players — Birth date handling

### Scenario

Unijeti datum rođenja ručno i kroz JMBG ako postoji automatsko popunjavanje. Sačuvati igrača i ponovo otvoriti profil.

### Expected result

Datum rođenja se ispravno snima, prikazuje i ostaje nepromijenjen nakon ponovnog otvaranja.

---

## INV-0043 — Players — Player detail profile

### Scenario

Otvoriti profil igrača iz liste i provjeriti osnovne podatke, tabove i navigaciju.

### Expected result

Profil se otvara bez greške i prikazuje tačne podatke igrača.

---

## INV-0044 — Players — Player photo

### Scenario

Uploadovati fotografiju igrača, provjeriti prikaz u listi i detalju, zatim izvršiti zamjenu ili brisanje fotografije.

### Expected result

Fotografija se prikazuje ispravno na svim ekranima. Zamjena i brisanje rade bez problema sa cache-om.

---

## INV-0045 — Players — Player registrations

### Scenario

Dodati registraciju, izmijeniti je i provjeriti aktivnu registraciju. Testirati pokušaj kreiranja konfliktnog aktivnog zapisa.

### Expected result

Registracija se snima i prikazuje ispravno. Sistem sprječava nedozvoljene konflikte.

---

## INV-0046 — Players — Player medical records

### Scenario

Dodati ljekarski pregled sa datumom isteka i provjeriti izmjene i prikaz statusa.

### Expected result

Ljekarski zapis se ispravno snima i koristi u obračunu prava nastupa.

---

## INV-0047 — Players — Player documents tab

### Scenario

Uploadovati dokument, izvršiti pregled, preuzimanje i zamjenu dokumenta.

### Expected result

Dokumenti se pravilno prikazuju i sve lifecycle akcije rade bez greške.

---

## INV-0048 — Players — Contracts module

### Scenario

Kreirati ugovor, popuniti obavezna polja i provjeriti prikaz u profilu igrača.

### Expected result

Ugovor se uspješno snima i prikazuje bez grešaka.

---

## INV-0049 — Players — Contract verification

### Scenario

Verifikovati ugovor i pokušati izmijeniti zaključane podatke nakon verifikacije.

### Expected result

Verifikacija radi ispravno i primjenjuje odgovarajuća ograničenja.

---

## INV-0050 — Players — Eligibility Lite

### Scenario

Testirati kombinacije validne registracije, nevažećeg ljekarskog pregleda i nedostajuće registracije.

### Expected result

Sistem prikazuje tačan eligibility status i jasan razlog kada pravo nastupa nije ispunjeno.
