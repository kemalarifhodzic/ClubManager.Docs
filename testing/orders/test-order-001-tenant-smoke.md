# Test Order 001 — Tenant Smoke Test

## Basic info

| Field           | Value                                                |
| --------------- | ---------------------------------------------------- |
| Assignment ID   | TA-2026-0001                                         |
| Test order file | `docs/testing/orders/test-order-001-tenant-smoke.md` |
| Release         | R1 Tenant Production                                 |
| Area            | Tenant App                                           |
| Test type       | Smoke test                                           |
| Tester          | Kemo                                                 |
| Environment     | DEV                                                  |
| Status          | Ready                                                |
| Result          | Not tested                                           |

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

## Goal

Confirm that the Tenant App can be opened by a valid club user and that the basic shell, dashboard, branding and navigation load without fatal errors.

This is a smoke test.

Passing this test does **not** mean the full modules are Verified.

---

## Do not test

Do not test these flows in this assignment:

* creating players
* editing or deleting data
* staff CRUD
* team CRUD
* event CRUD
* attendance save/lock
* document upload
* contracts
* eligibility
* finance payments/storno
* Player Portal
* Admin App
* Platform Billing
* notifications
* password reset

---

## Test cases

| Test ID | Inventory ID | Module         | Feature                                  | Scenario                                                                         | Expected result                                                                | Result | Actual result / Notes |
| ------- | ------------ | -------------- | ---------------------------------------- | -------------------------------------------------------------------------------- | ------------------------------------------------------------------------------ | ------ | --------------------- |
| TSM-001 | INV-0003     | Auth / Account | Login                                    | Open Tenant FE login page and log in with a valid club user.                     | User enters Tenant App without error.                                          | Passed |                       |
| TSM-002 | INV-0008     | Auth / Account | Tenant FE auth guard                     | Try to access Tenant FE with a non-club user if credentials are available.       | Admin/player user is blocked or redirected; club user is allowed.              | Passed |                       |
| TSM-003 | INV-0036     | Shell          | Tenant shell/sidebar/topbar club context | After login, check sidebar, topbar, club name/logo area and main layout.         | Shell loads without fatal error; club context is visible or fallback is shown. | Passed |                       |
| TSM-004 | INV-0023     | Dashboard      | Dashboard cards/counts/summaries         | Open Dashboard page after login.                                                 | Dashboard loads without fatal error and cards/summaries are visible.           | Passed |                       |
| TSM-005 | INV-0024     | Dashboard      | Dashboard event/team/fee usage           | Click visible Dashboard navigation links/cards for teams/events/fees if present. | Correct target pages open without fatal error.                                 | Passed |                       |
| TSM-006 | INV-0026     | Branding       | Club branding                            | Check that club branding/name appears in Tenant App shell.                       | Club branding is shown, or a safe fallback is shown.                           | Passed |                       |
| TSM-007 | INV-0027     | Club logo      | Club logo display                        | Check club logo display in sidebar/topbar if configured.                         | Logo loads, or fallback initials/name are shown without broken UI.             | Passed |                       |
| TSM-008 | INV-0003     | Auth / Account | Login/session refresh                    | Refresh browser while on Dashboard.                                              | User remains authenticated or is redirected cleanly without app crash.         | Passed |                       |

---

## Allowed result values

Use only these values in the `Result` column:

```text
Passed
Failed
Blocked
Not tested
```

---

## Failed / Blocked details

Fill this section for every Failed or Blocked test.

### Issue 1

| Field                 | Value            |
| --------------------- | ---------------- |
| Test ID               |                  |
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
| Test ID               |                  |
| Inventory ID          |                  |
| Status                | Failed / Blocked |
| URL                   |                  |
| Steps                 |                  |
| Expected result       |                  |
| Actual result         |                  |
| Screenshot / evidence |                  |
| Notes                 |                  |

---

## Tester sign-off

## Tester sign-off

| Field          | Value                                                                                                                                     |
| -------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| Tester         | Kemo                                                                                                                                      |
| Date           | 2026-06-07                                                                                                                                |
| Environment    | DEV                                                                                                                                       |
| Overall result | Passed                                                                                                                                    |
| Passed count   | 8                                                                                                                                         |
| Failed count   | 0                                                                                                                                         |
| Blocked count  | 0                                                                                                                                         |
| Notes          | Tenant smoke test passed. Login, tenant guard, shell, dashboard, branding, logo display and refresh behavior passed without fatal errors. |

---

## Processing note

After tester returns this file:

1. Update `docs/product/module-status.md → Ready for Testing`.
2. Add summary to `docs/product/module-status.md → Testing Results`.
3. If Failed or Blocked, create or update a matching `Needs Cleanup` row with the same `Inventory ID`.
4. Do not update `clubmanager-inventory.md` to Verified from this smoke test alone.
5. Inventory can only be updated if the result is strong enough and there is no blocking cleanup for the same `Inventory ID`.
