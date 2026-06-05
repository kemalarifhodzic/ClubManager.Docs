# API STANDARDS

## Player Portal — ponašanje korisničkog računa

Player Portal koristi povezani korisnički račun.

```text
players.user_id -> users.id
```

### Aktivacija

Ako igrač nema povezan korisnički račun:

- kreira se novi korisnik
- dodjeljuje se Player rola
- korisnik se povezuje sa igračem preko `players.user_id`
- `users.is_active` se postavlja na `true`

Ako igrač već ima povezan korisnički račun:

- ne kreira se novi korisnik
- postojeći korisnik se ponovo aktivira
- `users.is_active` se postavlja na `true`
- portal login email se može ažurirati
- lozinka se može ažurirati

### Deaktivacija

Kod deaktivacije:

- korisnik se ne briše
- Player rola se ne uklanja
- `players.user_id` se ne briše
- `users.is_active` se postavlja na `false`

### Promjena lozinke

Kod promjene lozinke:

- ažurira se `users.password_hash`
- ažurira se `users.updated_at`

## Player Portal — pravilo za email

`users.email` je portal login / sigurnosni email.

`players.email` je kontakt email igrača.

Backend ne smije pretpostaviti da su ova dva emaila uvijek ista.

## API dorada — provjera emaila kod reaktivacije

Kod reaktivacije postojećeg portal računa, ako se mijenja `users.email`, backend mora provjeriti da novi email već ne koristi drugi korisnik.

Nova aktivacija već provjerava jedinstvenost emaila.

Reaktivacija treba primijeniti isto pravilo, ali uz izuzetak trenutno povezanog korisnika.

Očekivano pravilo:

```text
Nijedan drugi korisnik ne smije imati traženi portal login email.
```

Ako drugi korisnik već koristi taj email, API treba vratiti conflict odgovor.
