# ClubManager Docs

Centralna dokumentacija za ClubManager projekat.

Ovaj folder služi kao zajedničko mjesto za potvrđene informacije o proizvodu, arhitekturi, standardima, roadmapu, deploymentu i statusu modula.

## Lokacija

```text
/home/kemo/ClubManager/docs
```

## Svrha

Dokumentacija u ovom folderu koristi se za:

* product inventory
* status modula
* roadmap
* arhitektonske odluke
* frontend/backend standarde
* DEV/STAGE i deployment bilješke
* release status
* tehničke i poslovne odluke koje ne smijemo stalno ponovo izmišljati

## Pravilo korištenja

ClubManager koristi tri nivoa dokumentovanja:

```text
OneNote = radna tabla, pregled, ideje i planiranje
docs folder = potvrđena centralna dokumentacija
Chat = radionica za analizu, pripremu i dorade
```

Ako je nešto samo ideja ili radna bilješka, prvo ide u OneNote.

Ako je nešto potvrđeno kroz kod, bazu, Swagger, aplikaciju ili dogovorenu odluku, upisuje se u ovaj `docs` folder.

## Struktura

```text
docs/
  README.md

  product/
    clubmanager-inventory.md
    module-status.md
    roadmap.md

  architecture/
    architecture-decisions.md
    data-standards.md

  frontend/
    ui-standards.md

  backend/
    api-standards.md

  devops/
    deployment-checklist.md

  releases/
    stage-status.md
```

## Glavni dokumenti

### `product/clubmanager-inventory.md`

Glavni pregled ClubManager modula i funkcionalnosti.

Koristi se za evidenciju šta postoji, šta je djelimično urađeno, šta je testirano i šta je planirano.

Osnovni format:

```text
Module | Feature | BE | FE | DB | Tested | Status | Notes
```

### `product/module-status.md`

Kratki operativni status modula.

Sadrži:

* Done
* In Progress
* Next
* Blocked
* Needs verification

### `product/roadmap.md`

Plan razvoja po prioritetima.

Sadrži:

* Now
* Next
* Later
* Premium ideas
* Risks / technical debt

### `architecture/architecture-decisions.md`

Mjesto za važne odluke koje utiču na cijeli projekat.

Primjeri:

* ne koristimo DB ENUM tipove
* API datumi su UTC sa `Z`
* FE ne koristi `any`
* QR payload ne sadrži lične podatke
* dokumentacija se vodi centralno u ovom folderu

### `architecture/data-standards.md`

Standardi za podatke.

Primjeri:

* DateTime format
* UTC pravila
* `timestamptz`
* string vrijednosti umjesto enum tipova
* TypeScript contract pravila

### `frontend/ui-standards.md`

Frontend i UX pravila.

Primjeri:

* light theme
* sidebar navigacija
* modal pravila
* inline validacije
* status chipovi
* Player FE mobile-first pristup

### `backend/api-standards.md`

Backend i API pravila.

Primjeri:

* endpoint naming
* error handling
* validation
* audit log
* tenant scope
* permission checks

### `devops/deployment-checklist.md`

Deployment i okruženja.

Primjeri:

* DEV/STAGE razdvajanje
* Docker
* nginx
* env varijable
* build/deploy checklist

### `releases/stage-status.md`

Stanje STAGE okruženja.

Sadrži:

* šta je deployano
* šta je testirano
* poznati bugovi
* verzije API/FE aplikacija
* šta nije spremno za produkciju

## Status legenda

Za inventory i module status koristiti ove statuse:

```text
Planned
Backend only
Frontend only
Implemented
Verified
Polished
Needs cleanup
Deprecated
```

### Planned

Dogovoreno, ali nije implementirano.

### Backend only

Backend/API postoji, ali frontend nije završen.

### Frontend only

UI postoji, ali backend nije povezan ili nije gotov.

### Implemented

Kod postoji i funkcionalnost osnovno radi.

### Verified

Funkcionalnost je provjerena kroz aplikaciju.

### Polished

Funkcionalnost je testirana, UX sređen i spremna je za normalnu upotrebu.

### Needs cleanup

Radi, ali ima tehničkog duga, UX problema ili nedovršene logike.

### Deprecated

Postojalo je, ali se više ne koristi.

## Pravilo za potvrdu inventory-ja

Inventory se ne potvrđuje iz sjećanja.

Svaka stavka se potvrđuje kroz najmanje jedan od ovih izvora:

* backend kod
* frontend kod
* baza / migracije
* Swagger / API test
* ručni test u aplikaciji
* deploy stanje na DEV/STAGE

## Trenutni prioritet dokumentacije

Prvo popuniti:

1. `product/clubmanager-inventory.md`
2. `product/module-status.md`
3. `product/roadmap.md`
4. `architecture/architecture-decisions.md`
5. `architecture/data-standards.md`

Prva verifikacija inventory-ja kreće od:

```text
Photo / Avatar pipeline
```

Razlog: taj dio je ranije bio označen kao potreban za cleanup, ali je naknadno sređivan i treba formalno potvrditi stvarni status.

## Kratko pravilo

```text
Ako je ideja — OneNote.
Ako je potvrđena činjenica — docs.
Ako je u toku rasprava — Chat.
```
