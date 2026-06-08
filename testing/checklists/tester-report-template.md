# Tester Report Template

Ovaj template se koristi za svaki `Failed`, `Blocked` ili sporni test rezultat.

Tester rezultat se vraća u:

```text
docs/product/module-status.md
```

Developer ne dobija nalog direktno od testera. `module-status.md` odlučuje da li nalaz ide u cleanup-backlog.

---

## 1. Basic info

| Field           | Value                           |
| --------------- | ------------------------------- |
| Test ID         |                                 |
| Test package    |                                 |
| Status          | Failed / Blocked / Needs retest |
| Environment     | DEV / STAGE                     |
| Tester          |                                 |
| Date            |                                 |
| Browser         |                                 |
| User / role     |                                 |
| Club            |                                 |
| URL             |                                 |
| Build / version |                                 |

---

## 2. Steps to reproduce

```text
1.
2.
3.
4.
```

---

## 3. Expected result

```text
```

---

## 4. Actual result

```text
```

---

## 5. Screenshot / evidence

```text
Paste screenshot path, filename, video link, log reference or note here.
```

---

## 6. Severity

| Severity | Meaning                                |
| -------- | -------------------------------------- |
| Critical | Blokira osnovni rad ili sigurnost      |
| High     | Blokira važan korisnički tok           |
| Medium   | Problem u toku, ali postoji workaround |
| Low      | Vizuelni/tekstualni/polish problem     |

Selected severity:

```text
```

---

## 7. Suggested classification

| Classification    | Meaning                                                |
| ----------------- | ------------------------------------------------------ |
| Bug               | Funkcionalnost ne radi kako treba                      |
| UX issue          | Funkcionalnost radi, ali korisnički tok nije dobar     |
| Permission issue  | Problem sa rolama/capability ponašanjem                |
| Data issue        | Problem sa podacima, statusom, refreshom ili izračunom |
| Known cleanup     | Već postoji u cleanup backlogu                         |
| Product decision  | Treba odluka, nije čisti bug                           |
| Environment issue | Problem je vezan za DEV/STAGE/setup                    |

Selected classification:

```text
```

---

## 8. Known cleanup reference

Ako tester misli da je problem već poznat, navesti cleanup ID ili module-status stavku.

| Field                 | Value                                                         |
| --------------------- | ------------------------------------------------------------- |
| Cleanup ID            |                                                               |
| Module-status section | Needs Cleanup / Blocked / Ready for Testing / Testing Results |
| Notes                 |                                                               |

---

## 9. Notes

```text
```

---

## 10. Triage result

Ovaj dio popunjava osoba koja vodi module-status.

| Field                    | Value                                |
| ------------------------ | ------------------------------------ |
| Accepted as bug?         | Yes / No                             |
| Existing cleanup item?   | Yes / No                             |
| New cleanup needed?      | Yes / No                             |
| Product decision needed? | Yes / No                             |
| module-status update     |                                      |
| cleanup-backlog update   |                                      |
| inventory update needed? | No / After retest / Product decision |

---

## 11. Retest

| Field                 | Value                     |
| --------------------- | ------------------------- |
| Fix reference         |                           |
| Ready for retest date |                           |
| Retest date           |                           |
| Retest result         | Passed / Failed / Blocked |
| Retest notes          |                           |
