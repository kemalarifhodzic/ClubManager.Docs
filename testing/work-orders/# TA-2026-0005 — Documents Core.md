# TA-2026-0005 — Documents Core

#### INV-0095 — Documents list/search/filter

**Scenario:** Otvoriti dokumente za igrača. Provjeriti listu, filter po tipu/statusu i pretragu po nazivu.
**Expected result:** Lista prikazuje samo dokumente tog igrača. Filteri i pretraga vraćaju tačne rezultate.

#### INV-0097 — Document upload

**Scenario:** Uploadovati validan PDF/sliku sa tipom dokumenta, nazivom, datumom isteka i napomenom.
**Expected result:** Dokument se uspješno snima i pojavljuje u listi sa tačnim metapodacima.

#### INV-0098 — Document download/view

**Scenario:** Otvoriti ili preuzeti uploadovan dokument.
**Expected result:** Otvara/preuzima se isti fajl koji je uploadovan, bez greške i bez pogrešnog dokumenta.

#### INV-0099 — Document replace

**Scenario:** Zamijeniti postojeći dokument novim fajlom.
**Expected result:** Novi dokument postaje aktivan, stari više nije aktivan, a historija zamjene ostaje jasna.

#### INV-0100 — Document soft delete

**Scenario:** Soft-delete aktivan dokument.
**Expected result:** Dokument više nije aktivan, ali nije fizički obrisan i može se eventualno vratiti.

#### INV-0101 — Document restore

**Scenario:** Vratiti prethodno obrisan dokument.
**Expected result:** Dokument se ponovo prikazuje kao aktivan ili vraćen prema pravilima lifecycle-a.

#### INV-0102 — Document purge

**Scenario:** Trajno obrisati dokument koji je prethodno soft-deleted.
**Expected result:** Dokument se više ne može vratiti i fajl/metapodaci su uklonjeni prema pravilima sistema.

#### INV-0103 — Document lifecycle/status

**Scenario:** Proći tok: upload → replace → soft delete → restore → purge.
**Expected result:** Status dokumenta se pravilno mijenja kroz cijeli lifecycle i UI jasno prikazuje trenutno stanje.

#### INV-0104 — Document type handling

**Scenario:** Uploadovati različite tipove dokumenata, npr. rodni list, registracija, ljekarski, ugovor, ostalo.
**Expected result:** Tip dokumenta se ispravno snima, prikazuje i koristi u filterima.

#### INV-0105 — Document title handling

**Scenario:** Uploadovati dokument sa korisničkim nazivom i provjeriti prikaz. Pokušati promijeniti naziv ako UI to dozvoljava.
**Expected result:** Naziv dokumenta se prikazuje jasno. Ako izmjena naziva nije podržana, UI to ne smije prikazati kao dozvoljenu akciju.

#### INV-0106 — File validation

**Scenario:** Pokušati upload validnog PDF/JPG/PNG fajla i nevalidnog fajla ili prevelikog fajla.
**Expected result:** Validni fajlovi prolaze. Nevalidni/preveliki fajlovi se odbijaju jasnom greškom.
