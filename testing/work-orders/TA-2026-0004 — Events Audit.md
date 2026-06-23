# TA-2026-0004 — Events Audit

### INV-0064 — Event CRUD

**Scenario:** Kreirati novi događaj za tim, izmijeniti osnovne podatke, sačuvati i ponovo otvoriti događaj iz liste.

**Expected result:** Događaj se kreira, prikazuje u listi, izmjene se snimaju i ostaju vidljive nakon ponovnog otvaranja.

### INV-0065 — Event detail

**Scenario:** Otvoriti detalj događaja i provjeriti prikaz osnovnih podataka, tima, datuma/vremena, lokacije, statusa i dostupnih tabova.

**Expected result:** Detalj događaja se otvara bez greške i prikazuje tačne podatke.

### INV-0066 — Event status lifecycle

**Scenario:** Promijeniti status događaja kroz dostupne faze: Scheduled, Completed i Cancelled. Kod otkazivanja provjeriti razlog otkazivanja.

**Expected result:** Status se pravilno mijenja, razlog otkazivanja se snima kada je potreban, a UI prikazuje tačno trenutno stanje.

### INV-0067 — Event attendance

**Scenario:** Unijeti prisutnost za igrače na događaju: Present, Late, Missed ili drugi dostupni status. Sačuvati i ponovo otvoriti događaj.

**Expected result:** Prisutnost se snima, prikazuje tačno nakon refresh-a i vezana je za pravi događaj i tim.

### INV-0068 — Attendance lock/unlock

**Scenario:** Nakon unosa prisutnosti zaključati attendance. Zatim pokušati otključavanje uz unos razloga.

**Expected result:** Zaključavanje blokira izmjene, otključavanje traži razlog i nakon otključavanja izmjene su ponovo dozvoljene.

### INV-0069 — Locked attendance read-only

**Scenario:** Zaključati attendance i pokušati mijenjati prisutnost igrača.

**Expected result:** Zaključana prisutnost je read-only. Korisnik ne može mijenjati podatke dok attendance nije otključan.

### INV-0070 — Team attendance statistics

**Scenario:** Nakon unosa prisutnosti provjeriti statistiku tima za događaj i/ili panel statistike.

**Expected result:** Statistika odgovara stvarno unesenim attendance podacima i ne broji pogrešne igrače.

### INV-0071 — MatchList / lineup

**Scenario:** Kreirati match list / lineup za događaj, dodati igrače, provjeriti osnovne podatke i sačuvati.

**Expected result:** Lineup se snima, prikazuje tačan spisak igrača i ostaje dostupan nakon ponovnog otvaranja događaja.

### INV-0072 — Lineup lock/unlock

**Scenario:** Zaključati lineup, pokušati izmjene, zatim otključati lineup uz razlog.

**Expected result:** Zaključan lineup ne dozvoljava izmjene. Otključavanje traži razlog i nakon otključavanja izmjene su ponovo moguće.

### INV-0073 — Player Portal event usage

**Scenario:** Provjeriti da li događaj kreiran u Tenant aplikaciji postoji za prikaz u Player Portal dijelu, ako je Player Portal trenutno dostupan.

**Expected result:** Ako je Player Portal aktivan, igrač vidi relevantne događaje svog tima. Ako Player Portal FE nije spreman, stavka se označava kao Blocked/Not Tested uz razlog.

### INV-0074 — Dashboard/team event usage

**Scenario:** Kreirati ili izmijeniti događaj i provjeriti da li se ispravno prikazuje na dashboardu i/ili team pregledu.

**Expected result:** Dashboard i team pregled prikazuju tačne događaje, bez starih/neaktivnih ili pogrešno filtriranih zapisa.
