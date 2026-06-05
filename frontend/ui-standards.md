# UI STANDARDS

## Player Portal — oznake za email polja

U Player Portal dijelu ne prikazivati kontakt email igrača i portal login email pod istom generičkom oznakom `Email`.

Ova dva emaila imaju različitu namjenu:

```text
players.email = kontakt email igrača
users.email   = portal login / email za prijavu
```

### Pravilo za UI

Ako se prikazuje email iz profila igrača, koristiti oznaku:

```text
Kontakt email
```

Ako se prikazuje email korisničkog računa za Player Portal, koristiti oznaku:

```text
Email za prijavu
```

ili:

```text
Portal login email
```

### Player Portal tab

U Player Portal tabu:

- `players.email` treba prikazati kao kontakt email igrača
- `portal.email` / `users.email` treba prikazati kao email za prijavu
- ako su oba prikazana, korisnik mora jasno vidjeti razliku
- ne koristiti samo oznaku `Email` ako može doći do zabune

### Primjer prikaza

```text
Kontakt email: igrac@example.com
Email za prijavu: portal@example.com
```

### Razlog

Kontakt email i portal login email ne moraju biti isti.

Primjeri:

- igrač može imati jedan kontakt email, a drugi email za prijavu
- roditelj može biti kontakt osoba
- klub može koristiti kontakt email za obavijesti
- Player Portal koristi `users.email` za login, reset lozinke i sigurnosne poruke

### Pravilo za buduće forme

Kod novih formi i ekrana ne koristiti generički label `Email` ako postoji mogućnost da se odnosi na dvije različite stvari.

Koristiti precizne oznake:

```text
Kontakt email
Email za prijavu
Portal login email
```
