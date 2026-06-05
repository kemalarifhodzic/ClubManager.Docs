# ClubManager Architecture Decisions

## ADR — Kontakt email igrača i portal login email su odvojeni

ClubManager namjerno razdvaja kontakt email igrača od emaila za prijavu na Player Portal.

```text
players.email = kontakt email igrača
users.email   = portal login / sigurnosni email
```

### Odluka

`players.email` i `users.email` ne moraju biti isti.

Ova dva polja imaju različitu poslovnu i tehničku namjenu.

### `players.email`

`players.email` je kontakt email igrača u profilu.

Koristi se za:

- klupske obavijesti
- kontakt sa igračem ili roditeljem/starateljem
- poruke vezane za treninge, događaje, članarine i dokumente
- opštu komunikaciju kluba prema igraču

### `users.email`

`users.email` je email korisničkog računa.

Koristi se za:

- prijavu na Player Portal
- promjenu ili reset lozinke
- sigurnosne poruke vezane za korisnički račun
- aktivaciju i reaktivaciju Player Portala
- sistemske Player Portal poruke

### Razlog odluke

Kontakt email i portal login email mogu biti različiti u stvarnom radu kluba.

Primjeri:

- igrač ima jedan kontakt email, a drugi email koristi za prijavu
- roditelj/staratelj je kontakt osoba
- klub želi slati opšte obavijesti na kontakt email
- Player Portal mora koristiti email koji je vezan za korisnički račun
- sigurnosne poruke ne smiju zavisiti od kontakt emaila iz profila igrača

Zbog toga se ova dva emaila ne smiju automatski izjednačavati.

### Pravila za slanje obavijesti

| Tip obavijesti                   | Email primaoca                             |
| -------------------------------- | ------------------------------------------ |
| Login, sigurnost i reset lozinke | `users.email`                              |
| Sistemske Player Portal poruke   | `users.email`                              |
| Klupske i kontakt obavijesti     | `players.email`                            |
| Događaji, prisustvo i članarine  | `players.email`, fallback na `users.email` |
| Ako `players.email` nije unesen  | fallback na `users.email`                  |

### UI pravilo

Kada se oba emaila prikazuju u aplikaciji, ne koristiti generičku oznaku `Email`.

Koristiti jasne oznake:

```text
Kontakt email
Email za prijavu
Portal login email
```

U Player Portal tabu:

- `players.email` prikazati kao kontakt email
- `users.email` / `portal.email` prikazati kao email za prijavu
- korisnik mora jasno vidjeti razliku između ova dva polja

### Backend pravilo

Backend ne smije pretpostaviti da su `players.email` i `users.email` isti.

Kod aktivacije Player Portala:

- ako igrač nema povezan korisnički račun, kreira se novi `users` zapis
- `users.email` postaje email za prijavu
- igrač se povezuje sa korisnikom preko `players.user_id`

Kod deaktivacije Player Portala:

- korisnik se ne briše
- Player rola se ne uklanja
- `players.user_id` se ne briše
- `users.is_active` se postavlja na `false`

Kod reaktivacije Player Portala:

- koristi se postojeći povezani korisnik
- `users.is_active` se postavlja na `true`
- portal login email i lozinka se mogu ažurirati

### API dorada za kasnije

Kod reaktivacije postojećeg portal računa, ako se mijenja `users.email`, backend mora provjeriti da novi email već ne koristi drugi korisnik.

Nova aktivacija već provjerava jedinstvenost emaila.

Reaktivacija treba primijeniti isto pravilo, ali uz izuzetak trenutno povezanog korisnika.

Očekivano pravilo:

```text
Nijedan drugi korisnik ne smije imati traženi portal login email.
```

Ako drugi korisnik već koristi taj email, API treba vratiti conflict odgovor.

### Status

```text
Accepted
```
