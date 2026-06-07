# Tenant MVP Basic Test Checklist

Area: Tenant App
Release: R1 Tenant Production MVP
Test package: Basic functional verification

---

## Test environment

| Field       | Value |
| ----------- | ----- |
| Environment | DEV   |
| Tester      |       |
| Date        |       |
| Browser     |       |
| Club user   |       |
| Club        |       |
| Notes       |       |

---

## 1. Login / Shell / Dashboard

| Test ID  | Module    | Feature              | Scenario                           | Expected result                                    | Status     | Notes |
| -------- | --------- | -------------------- | ---------------------------------- | -------------------------------------------------- | ---------- | ----- |
| TMVP-001 | Auth      | Tenant login         | Login with valid club user         | User enters Tenant App                             | Not tested |       |
| TMVP-002 | Auth      | Wrong role blocked   | Try admin/player user in Tenant FE | Access is blocked or redirected                    | Not tested |       |
| TMVP-003 | Shell     | Sidebar/topbar       | Open app shell                     | Sidebar, topbar and club context display correctly | Not tested |       |
| TMVP-004 | Dashboard | Dashboard load       | Open dashboard                     | Dashboard loads without error                      | Not tested |       |
| TMVP-005 | Dashboard | Dashboard navigation | Click dashboard links/cards        | Navigation opens correct module                    | Not tested |       |
| TMVP-006 | Session   | Refresh behavior     | Refresh dashboard                  | Session and data reload correctly                  | Not tested |       |

---

## 2. Players / Digitalni dosje igrača

| Test ID  | Module       | Feature         | Scenario                                    | Expected result                                 | Status     | Notes |
| -------- | ------------ | --------------- | ------------------------------------------- | ----------------------------------------------- | ---------- | ----- |
| TMVP-101 | Players      | Player list     | Open Players page                           | Player list loads without error                 | Not tested |       |
| TMVP-102 | Players      | Search/filter   | Search player by name/JMBG                  | Matching players are shown                      | Not tested |       |
| TMVP-103 | Players      | Create player   | Create test player with valid required data | Player is created and visible                   | Not tested |       |
| TMVP-104 | Players      | Required fields | Try create without required fields          | Validation message appears; player is not saved | Not tested |       |
| TMVP-105 | Players      | Duplicate JMBG  | Try duplicate JMBG in same club             | Duplicate is blocked with clear message         | Not tested |       |
| TMVP-106 | Players      | Detail page     | Open player detail                          | Profile and tabs load correctly                 | Not tested |       |
| TMVP-107 | Players      | Edit player     | Edit basic player data                      | Changes persist after refresh                   | Not tested |       |
| TMVP-108 | Player photo | Upload photo    | Upload player photo                         | Photo appears on list/detail/edit               | Not tested |       |
| TMVP-109 | Player photo | Delete photo    | Delete player photo                         | Fallback initials/avatar appear                 | Not tested |       |

Known notes:

| Area                     | Note                                           |
| ------------------------ | ---------------------------------------------- |
| JMBG semantic validation | Full checksum/date validation may not be final |
| Duplicate create flow    | Known cleanup candidate                        |
| Birth date auto-fill     | Known cleanup candidate if not in primary form |

---

## 3. Registrations / Medicals / Eligibility

| Test ID  | Module        | Feature                       | Scenario                                        | Expected result                           | Status     | Notes |
| -------- | ------------- | ----------------------------- | ----------------------------------------------- | ----------------------------------------- | ---------- | ----- |
| TMVP-201 | Registrations | List registrations            | Open registration tab for player                | Existing registrations load               | Not tested |       |
| TMVP-202 | Registrations | Add registration              | Add valid registration                          | Registration appears after save/refresh   | Not tested |       |
| TMVP-203 | Registrations | Duplicate active registration | Try duplicate active registration if applicable | Controlled error appears                  | Not tested |       |
| TMVP-204 | Medicals      | List medicals                 | Open medical tab                                | Medical records load                      | Not tested |       |
| TMVP-205 | Medicals      | Add medical                   | Add valid medical record                        | Medical appears after save/refresh        | Not tested |       |
| TMVP-206 | Medicals      | Expired medical               | Add or use expired medical                      | Eligibility reflects expired state        | Not tested |       |
| TMVP-207 | Eligibility   | Basic eligibility             | Player has valid registration + valid medical   | Eligibility result is logical and visible | Not tested |       |

---

## 4. Documents

| Test ID  | Module    | Feature          | Scenario                              | Expected result                                      | Status     | Notes |
| -------- | --------- | ---------------- | ------------------------------------- | ---------------------------------------------------- | ---------- | ----- |
| TMVP-301 | Documents | List documents   | Open player Documents tab             | Documents list loads                                 | Not tested |       |
| TMVP-302 | Documents | Upload document  | Upload valid player document          | Document appears in list                             | Not tested |       |
| TMVP-303 | Documents | Download/view    | Download or preview uploaded document | File opens/downloads correctly                       | Not tested |       |
| TMVP-304 | Documents | Replace document | Replace uploaded document             | New document is active; old one handled by lifecycle | Not tested |       |
| TMVP-305 | Documents | Soft delete      | Delete document                       | Document becomes deleted/inactive according to UI    | Not tested |       |
| TMVP-306 | Documents | Restore          | Restore deleted document              | Document is restored if allowed                      | Not tested |       |
| TMVP-307 | Documents | Invalid file     | Upload unsupported file type          | Upload is blocked with controlled error              | Not tested |       |

Known exclusions:

| Area                                        | Reason                                           |
| ------------------------------------------- | ------------------------------------------------ |
| Club documents                              | Not R1 feature; service/schema mismatch          |
| `LicenseDocument` / `QualificationDocument` | Known cleanup item; if encountered, mark Blocked |
| Staff documents UI                          | Not R1 final target unless explicitly enabled    |

---

## 5. Contracts

| Test ID  | Module    | Feature         | Scenario                               | Expected result                                 | Status     | Notes |
| -------- | --------- | --------------- | -------------------------------------- | ----------------------------------------------- | ---------- | ----- |
| TMVP-401 | Contracts | List contracts  | Open Contracts tab                     | Contracts load without error                    | Not tested |       |
| TMVP-402 | Contracts | Create contract | Create valid player contract           | Contract appears in list                        | Not tested |       |
| TMVP-403 | Contracts | Edit contract   | Edit unverified contract               | Changes persist                                 | Not tested |       |
| TMVP-404 | Contracts | Delete contract | Delete unverified test contract        | Contract is removed or controlled error appears | Not tested |       |
| TMVP-405 | Contracts | Verify contract | Verify contract if action is available | Contract becomes verified                       | Not tested |       |
| TMVP-406 | Contracts | Verified lock   | Try edit/delete verified contract      | Action is blocked with clear message            | Not tested |       |

Known note:

| Area                 | Note                                         |
| -------------------- | -------------------------------------------- |
| Contract debug alert | Known cleanup item if raw JSON alert appears |

---

## 6. Staff

| Test ID  | Module | Feature            | Scenario                            | Expected result                                           | Status     | Notes |
| -------- | ------ | ------------------ | ----------------------------------- | --------------------------------------------------------- | ---------- | ----- |
| TMVP-501 | Staff  | Staff list         | Open Staff page                     | Staff list loads without error                            | Not tested |       |
| TMVP-502 | Staff  | Create staff       | Create staff member with valid data | Staff appears in list/detail                              | Not tested |       |
| TMVP-503 | Staff  | Edit staff         | Edit staff data                     | Changes persist after refresh                             | Not tested |       |
| TMVP-504 | Staff  | Staff photo upload | Upload staff photo                  | Photo appears correctly                                   | Not tested |       |
| TMVP-505 | Staff  | Staff photo delete | Delete staff photo                  | Fallback avatar appears                                   | Not tested |       |
| TMVP-506 | Staff  | Delete/deactivate  | Delete staff if action exists       | Staff is removed or controlled dependency message appears | Not tested |       |

Known notes:

| Area                                    | Note                                        |
| --------------------------------------- | ------------------------------------------- |
| Staff permissions                       | `ManageStaff` cleanup pending               |
| Staff JMBG                              | DB/DTO rule needs final decision            |
| Staff team assignment from Staff detail | Known placeholder; real flow is Team detail |

---

## 7. Teams / Memberships

| Test ID  | Module | Feature               | Scenario                    | Expected result                  | Status     | Notes |
| -------- | ------ | --------------------- | --------------------------- | -------------------------------- | ---------- | ----- |
| TMVP-601 | Teams  | Team list             | Open Teams page             | Team list loads                  | Not tested |       |
| TMVP-602 | Teams  | Create team           | Create team with valid data | Team appears in list             | Not tested |       |
| TMVP-603 | Teams  | Duplicate team        | Try duplicate team name     | Controlled error appears         | Not tested |       |
| TMVP-604 | Teams  | Team detail           | Open team detail            | Detail page loads with panels    | Not tested |       |
| TMVP-605 | Teams  | Add player membership | Add player to team          | Player appears in team roster    | Not tested |       |
| TMVP-606 | Teams  | Add staff membership  | Add staff to team           | Staff appears in team staff list | Not tested |       |
| TMVP-607 | Teams  | Refresh behavior      | Refresh team detail         | Memberships remain visible       | Not tested |       |

Known notes:

| Area                        | Note                                                     |
| --------------------------- | -------------------------------------------------------- |
| Duplicate team validation   | Known cleanup if DB exception appears                    |
| Staff membership validation | Known cleanup if 500 appears instead of controlled error |

---

## 8. Events / Attendance / Lineup

| Test ID  | Module             | Feature              | Scenario                                           | Expected result                                | Status     | Notes |
| -------- | ------------------ | -------------------- | -------------------------------------------------- | ---------------------------------------------- | ---------- | ----- |
| TMVP-701 | Events             | Event list           | Open Events page                                   | Events load without error                      | Not tested |       |
| TMVP-702 | Events             | Create event         | Create training event                              | Event appears in list                          | Not tested |       |
| TMVP-703 | Events             | Event detail         | Open event detail                                  | Detail loads correctly                         | Not tested |       |
| TMVP-704 | Events             | Edit event           | Edit basic event info                              | Changes persist                                | Not tested |       |
| TMVP-705 | Events             | Delete event         | Delete event without attendance/lineup             | Event is deleted or controlled message appears | Not tested |       |
| TMVP-706 | Attendance         | Attendance panel     | Open attendance tab                                | Roster/attendance loads                        | Not tested |       |
| TMVP-707 | Attendance         | Save attendance      | Mark attendance and save                           | Attendance persists after refresh              | Not tested |       |
| TMVP-708 | Attendance         | Lock after event end | Lock attendance after event end                    | Attendance becomes read-only                   | Not tested |       |
| TMVP-709 | Attendance         | Locked read-only     | Try editing locked attendance                      | Edit is blocked                                | Not tested |       |
| TMVP-710 | Lineup / MatchList | MatchList panel      | Open MatchList for match event                     | MatchList UI loads                             | Not tested |       |
| TMVP-711 | Lineup / MatchList | Save lineup          | Add lineup items and save                          | Lineup persists after refresh                  | Not tested |       |
| TMVP-712 | Lineup / MatchList | Print                | Print MatchList if available                       | Print flow opens correctly                     | Not tested |       |
| TMVP-713 | Team attendance    | Team stats           | Open Team attendance panel after locked attendance | Stats reflect locked attendance                | Not tested |       |

Known notes:

| Area                               | Note                               |
| ---------------------------------- | ---------------------------------- |
| Complete endpoint                  | Cleanup pending                    |
| Attendance lock on cancelled event | Cleanup pending                    |
| Prompt/alert UX                    | Known polish issue                 |
| MatchList export                   | Print exists; export not confirmed |

---

## 9. Tenant Finance / Članarine

| Test ID  | Module | Feature              | Scenario                         | Expected result                                | Status     | Notes |
| -------- | ------ | -------------------- | -------------------------------- | ---------------------------------------------- | ---------- | ----- |
| TMVP-801 | Fees   | Fees page            | Open Fees page                   | Page loads with summaries/list                 | Not tested |       |
| TMVP-802 | Fees   | Bulk invoice preview | Open bulk invoice wizard preview | Preview loads correctly                        | Not tested |       |
| TMVP-803 | Fees   | Bulk invoice create  | Create invoices from wizard      | Invoices appear in list                        | Not tested |       |
| TMVP-804 | Fees   | Quick payment        | Add payment to invoice           | Payment is recorded and balance updates        | Not tested |       |
| TMVP-805 | Fees   | Partial payment      | Add partial payment              | Invoice remains partial/open logically         | Not tested |       |
| TMVP-806 | Fees   | Full payment         | Pay remaining balance            | Invoice becomes paid logically                 | Not tested |       |
| TMVP-807 | Fees   | Storno payment       | Storno payment                   | Payment is voided/reversed and balance updates | Not tested |       |
| TMVP-808 | Fees   | Refresh behavior     | Refresh after payment/storno     | Status and balance remain correct              | Not tested |       |

Known notes:

| Area                      | Note                                               |
| ------------------------- | -------------------------------------------------- |
| Fee invoice status source | Known cleanup; watch for status drift              |
| Payment method            | Known cleanup if method is shown but not persisted |
| Exports                   | Backend-only unless UI exists                      |

---

## 10. Tenant Users / Permissions

| Test ID  | Module      | Feature            | Scenario                                        | Expected result                   | Status     | Notes |
| -------- | ----------- | ------------------ | ----------------------------------------------- | --------------------------------- | ---------- | ----- |
| TMVP-901 | Users       | Users page access  | Open Users page as manager/admin-like club user | Page loads if user has permission | Not tested |       |
| TMVP-902 | Users       | Create user        | Create tenant user if UI exists                 | User appears in list              | Not tested |       |
| TMVP-903 | Users       | Set password       | Set password for tenant user                    | User can login with new password  | Not tested |       |
| TMVP-904 | Users       | Deactivate user    | Deactivate test user                            | User becomes inactive             | Not tested |       |
| TMVP-905 | Permissions | Missing permission | Try Users page/action without `ManageUsers`     | UI/API blocks access              | Not tested |       |

Known notes:

| Area                             | Note                             |
| -------------------------------- | -------------------------------- |
| `GET /api/users` backend cap     | P0 cleanup item                  |
| User detail endpoint             | Placeholder in audit             |
| Self-deactivation / last manager | Cleanup/product decision pending |

---

## Summary

| Result       | Count |
| ------------ | ----: |
| Passed       |     0 |
| Failed       |     0 |
| Blocked      |     0 |
| Needs retest |     0 |
| Not tested   |    79 |

---

## Test result notes

Use this section for short notes after test execution.

```text
Date:
Tester:
Summary:
Main failures:
Blocked tests:
Recommended retest:
```
