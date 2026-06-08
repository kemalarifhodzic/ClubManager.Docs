# Tenant Production Basic Checklist

Test package:

```text
Tenant Production Basic Flow
```

Release:

```text
R1 Tenant Production MVP
```

Source of test command:

```text
docs/product/module-status.md → Ready for Testing
```

Checklist status:

```text
Draft
```

Napomena:

```text
Ovaj checklist se ne izvršava kao zvaničan test dok module-status.md ne postavi paket na Status = Ready.
```

---

## Test environment

| Field           | Value       |
| --------------- | ----------- |
| Environment     | DEV / STAGE |
| Tester          |             |
| Date            |             |
| Browser         |             |
| Club            |             |
| User / role     |             |
| Build / version |             |
| Notes           |             |

---

## Status legenda

| Status       | Značenje                   |
| ------------ | -------------------------- |
| Not tested   | Test još nije izvršen      |
| Passed       | Test je prošao             |
| Failed       | Test nije prošao           |
| Blocked      | Test se ne može izvršiti   |
| Needs retest | Treba ponoviti nakon fix-a |
| Deferred     | Svjesno odloženo           |

---

# 1. Login / Shell / Dashboard

| Test ID | Module    | Feature              | Scenario                           | Expected result                                    | Status     | Notes |
| ------- | --------- | -------------------- | ---------------------------------- | -------------------------------------------------- | ---------- | ----- |
| TPB-001 | Auth      | Tenant login         | Login with valid club user         | User enters Tenant App                             | Not tested |       |
| TPB-002 | Auth      | Wrong role blocked   | Try admin/player user in Tenant FE | Access is blocked or redirected                    | Not tested |       |
| TPB-003 | Shell     | Sidebar/topbar       | Open app shell                     | Sidebar, topbar and club context display correctly | Not tested |       |
| TPB-004 | Dashboard | Dashboard load       | Open dashboard                     | Dashboard loads without error                      | Not tested |       |
| TPB-005 | Dashboard | Dashboard navigation | Click dashboard links/cards        | Correct module opens                               | Not tested |       |
| TPB-006 | Session   | Refresh behavior     | Refresh dashboard                  | Session and data reload correctly                  | Not tested |       |

Known notes:

| Area                         | Note                                                   |
| ---------------------------- | ------------------------------------------------------ |
| Dashboard backend capability | Known cleanup if backend `ReadOnly` cap is not aligned |
| Shell topbar actions         | Search/help/notifications may be UI-only               |
| Club summary                 | Some summary values may be placeholder until cleanup   |

---

# 2. Players

| Test ID | Module       | Feature         | Scenario                                    | Expected result                                 | Status     | Notes |
| ------- | ------------ | --------------- | ------------------------------------------- | ----------------------------------------------- | ---------- | ----- |
| TPB-101 | Players      | Player list     | Open Players page                           | Player list loads without error                 | Not tested |       |
| TPB-102 | Players      | Search/filter   | Search player by name/JMBG                  | Matching players are shown                      | Not tested |       |
| TPB-103 | Players      | Create player   | Create test player with valid required data | Player is created and visible                   | Not tested |       |
| TPB-104 | Players      | Required fields | Try create without required fields          | Validation message appears; player is not saved | Not tested |       |
| TPB-105 | Players      | Duplicate JMBG  | Try duplicate JMBG in same club             | Duplicate is blocked with clear message         | Not tested |       |
| TPB-106 | Players      | Detail page     | Open player detail                          | Profile and tabs load correctly                 | Not tested |       |
| TPB-107 | Players      | Edit player     | Edit basic player data                      | Changes persist after refresh                   | Not tested |       |
| TPB-108 | Player photo | Upload photo    | Upload player photo                         | Photo appears on list/detail/edit               | Not tested |       |
| TPB-109 | Player photo | Delete photo    | Fallback initials/avatar appears            | Not tested                                      |            |       |

Known notes:

| Area                     | Note                                           |
| ------------------------ | ---------------------------------------------- |
| JMBG semantic validation | Full checksum/date validation may not be final |
| Duplicate create flow    | Known cleanup candidate                        |
| Birth date auto-fill     | Known cleanup candidate if not in primary form |

---

# 3. Registrations / Medicals / Eligibility

| Test ID | Module        | Feature                       | Scenario                                        | Expected result                           | Status     | Notes |
| ------- | ------------- | ----------------------------- | ----------------------------------------------- | ----------------------------------------- | ---------- | ----- |
| TPB-201 | Registrations | List registrations            | Open registration tab for player                | Existing registrations load               | Not tested |       |
| TPB-202 | Registrations | Add registration              | Add valid registration                          | Registration appears after save/refresh   | Not tested |       |
| TPB-203 | Registrations | Duplicate active registration | Try duplicate active registration if applicable | Controlled error appears                  | Not tested |       |
| TPB-204 | Medicals      | List medicals                 | Open medical tab                                | Medical records load                      | Not tested |       |
| TPB-205 | Medicals      | Add medical                   | Add valid medical record                        | Medical appears after save/refresh        | Not tested |       |
| TPB-206 | Medicals      | Expired medical               | Add or use expired medical                      | Eligibility reflects expired state        | Not tested |       |
| TPB-207 | Eligibility   | Basic eligibility             | Player has valid registration + valid medical   | Eligibility result is logical and visible | Not tested |       |

---

# 4. Documents

| Test ID | Module    | Feature               | Scenario                                                | Expected result                                              | Status     | Notes |
| ------- | --------- | --------------------- | ------------------------------------------------------- | ------------------------------------------------------------ | ---------- | ----- |
| TPB-301 | Documents | List documents        | Open player Documents tab                               | Documents list loads                                         | Not tested |       |
| TPB-302 | Documents | Upload valid document | Upload valid player document                            | Document appears in list                                     | Not tested |       |
| TPB-303 | Documents | Download/view         | Download or preview uploaded document                   | File opens/downloads correctly                               | Not tested |       |
| TPB-304 | Documents | Replace document      | Replace uploaded document                               | New document is active; old document is handled by lifecycle | Not tested |       |
| TPB-305 | Documents | Soft delete           | Delete document                                         | Document becomes deleted/inactive according to UI            | Not tested |       |
| TPB-306 | Documents | Restore               | Restore deleted document                                | Document is restored if allowed                              | Not tested |       |
| TPB-307 | Documents | Invalid file          | Upload unsupported file type                            | Upload is blocked with controlled error                      | Not tested |       |
| TPB-308 | Documents | Duplicate active type | Upload duplicate active document type where not allowed | Controlled error appears                                     | Not tested |       |

Known exclusions:

| Area                                        | Reason                                                     |
| ------------------------------------------- | ---------------------------------------------------------- |
| Club documents                              | Not R1 feature until schema/service decision               |
| `LicenseDocument` / `QualificationDocument` | Known cleanup item; mark Blocked if encountered before fix |
| Staff documents UI                          | Not R1 final target unless explicitly activated            |

---

# 5. Contracts

| Test ID | Module    | Feature         | Scenario                               | Expected result                                 | Status     | Notes |
| ------- | --------- | --------------- | -------------------------------------- | ----------------------------------------------- | ---------- | ----- |
| TPB-401 | Contracts | List contracts  | Open Contracts tab                     | Contracts load without error                    | Not tested |       |
| TPB-402 | Contracts | Create contract | Create valid player contract           | Contract appears in list                        | Not tested |       |
| TPB-403 | Contracts | Edit contract   | Edit unverified contract               | Changes persist                                 | Not tested |       |
| TPB-404 | Contracts | Delete contract | Delete unverified test contract        | Contract is removed or controlled error appears | Not tested |       |
| TPB-405 | Contracts | Verify contract | Verify contract if action is available | Contract becomes verified                       | Not tested |       |
| TPB-406 | Contracts | Verified lock   | Try edit/delete verified contract      | Action is blocked with clear message            | Not tested |       |

Known notes:

| Area                 | Note                                         |
| -------------------- | -------------------------------------------- |
| Contract debug alert | Known cleanup item if raw JSON alert appears |

---

# 6. Staff

| Test ID | Module | Feature            | Scenario                            | Expected result                                           | Status     | Notes |
| ------- | ------ | ------------------ | ----------------------------------- | --------------------------------------------------------- | ---------- | ----- |
| TPB-501 | Staff  | Staff list         | Open Staff page                     | Staff list loads without error                            | Not tested |       |
| TPB-502 | Staff  | Create staff       | Create staff member with valid data | Staff appears in list/detail                              | Not tested |       |
| TPB-503 | Staff  | Edit staff         | Edit staff data                     | Changes persist after refresh                             | Not tested |       |
| TPB-504 | Staff  | Staff photo upload | Upload staff photo                  | Photo appears correctly                                   | Not tested |       |
| TPB-505 | Staff  | Staff photo delete | Delete staff photo                  | Fallback avatar appears                                   | Not tested |       |
| TPB-506 | Staff  | Delete/deactivate  | Delete staff if action exists       | Staff is removed or controlled dependency message appears | Not tested |       |

Known notes:

| Area                                    | Note                                        |
| --------------------------------------- | ------------------------------------------- |
| Staff permissions                       | `ManageStaff` cleanup pending               |
| Staff JMBG                              | DB/DTO rule needs final decision            |
| Staff team assignment from Staff detail | Known placeholder; real flow is Team detail |

---

# 7. Teams / Memberships

| Test ID | Module | Feature               | Scenario                                  | Expected result                               | Status     | Notes |
| ------- | ------ | --------------------- | ----------------------------------------- | --------------------------------------------- | ---------- | ----- |
| TPB-601 | Teams  | Team list             | Open Teams page                           | Team list loads                               | Not tested |       |
| TPB-602 | Teams  | Create team           | Create team with valid data               | Team appears in list                          | Not tested |       |
| TPB-603 | Teams  | Duplicate team        | Try duplicate team name                   | Controlled error appears                      | Not tested |       |
| TPB-604 | Teams  | Team detail           | Open team detail                          | Detail page loads with panels                 | Not tested |       |
| TPB-605 | Teams  | Add player membership | Add player to team                        | Player appears in team roster                 | Not tested |       |
| TPB-606 | Teams  | Add staff membership  | Add staff to team                         | Staff appears in team staff list              | Not tested |       |
| TPB-607 | Teams  | Update membership     | Update jersey/role/date if UI supports it | Change persists or controlled message appears | Not tested |       |
| TPB-608 | Teams  | End membership        | End/remove player or staff membership     | Membership is ended/removed correctly         | Not tested |       |
| TPB-609 | Teams  | Refresh behavior      | Refresh team detail                       | Memberships remain visible                    | Not tested |       |

Known notes:

| Area                        | Note                                                     |
| --------------------------- | -------------------------------------------------------- |
| Duplicate team validation   | Known cleanup if DB exception appears                    |
| Staff membership validation | Known cleanup if 500 appears instead of controlled error |
| `/teams/:id/edit` guard     | Known cleanup candidate                                  |

---

# 8. Events / Attendance / Lineup

| Test ID | Module             | Feature               | Scenario                                           | Expected result                                          | Status     | Notes |
| ------- | ------------------ | --------------------- | -------------------------------------------------- | -------------------------------------------------------- | ---------- | ----- |
| TPB-701 | Events             | Event list            | Open Events page                                   | Events load without error                                | Not tested |       |
| TPB-702 | Events             | Create event          | Create training event                              | Event appears in list                                    | Not tested |       |
| TPB-703 | Events             | Event detail          | Open event detail                                  | Detail loads correctly                                   | Not tested |       |
| TPB-704 | Events             | Edit event            | Edit basic event info                              | Changes persist                                          | Not tested |       |
| TPB-705 | Events             | Delete event          | Delete event without attendance/lineup             | Event is deleted or controlled message appears           | Not tested |       |
| TPB-706 | Events             | Cancel event          | Cancel event if action exists                      | Event becomes cancelled and blocked from invalid actions | Not tested |       |
| TPB-707 | Attendance         | Attendance panel      | Open attendance tab                                | Roster/attendance loads                                  | Not tested |       |
| TPB-708 | Attendance         | Save attendance       | Mark attendance and save                           | Attendance persists after refresh                        | Not tested |       |
| TPB-709 | Attendance         | Lock before event end | Try lock before event ends                         | Lock is blocked with clear message                       | Not tested |       |
| TPB-710 | Attendance         | Lock after event end  | Lock attendance after event end                    | Attendance becomes read-only                             | Not tested |       |
| TPB-711 | Attendance         | Locked read-only      | Try editing locked attendance                      | Edit is blocked                                          | Not tested |       |
| TPB-712 | Lineup / MatchList | MatchList panel       | Open MatchList for match event                     | MatchList UI loads                                       | Not tested |       |
| TPB-713 | Lineup / MatchList | Save lineup           | Add lineup items and save                          | Lineup persists after refresh                            | Not tested |       |
| TPB-714 | Lineup / MatchList | Lock lineup           | Lock lineup if action exists                       | Lineup becomes read-only                                 | Not tested |       |
| TPB-715 | Lineup / MatchList | Print                 | Print MatchList if available                       | Print flow opens correctly                               | Not tested |       |
| TPB-716 | Team attendance    | Team stats            | Open Team attendance panel after locked attendance | Stats reflect locked attendance                          | Not tested |       |

Known notes:

| Area                               | Note                               |
| ---------------------------------- | ---------------------------------- |
| Complete endpoint                  | Cleanup pending                    |
| Attendance lock on cancelled event | Cleanup pending                    |
| Prompt/alert UX                    | Known polish issue                 |
| MatchList export                   | Print exists; export not confirmed |

---

# 9. Tenant Finance / Članarine

| Test ID | Module | Feature              | Scenario                         | Expected result                                | Status     | Notes |
| ------- | ------ | -------------------- | -------------------------------- | ---------------------------------------------- | ---------- | ----- |
| TPB-801 | Fees   | Fees page            | Open Fees page                   | Page loads with summaries/list                 | Not tested |       |
| TPB-802 | Fees   | Bulk invoice preview | Open bulk invoice wizard preview | Preview loads correctly                        | Not tested |       |
| TPB-803 | Fees   | Bulk invoice create  | Create invoices from wizard      | Invoices appear in list                        | Not tested |       |
| TPB-804 | Fees   | Quick payment        | Add payment to invoice           | Payment is recorded and balance updates        | Not tested |       |
| TPB-805 | Fees   | Partial payment      | Add partial payment              | Invoice remains partial/open logically         | Not tested |       |
| TPB-806 | Fees   | Full payment         | Pay remaining balance            | Invoice becomes paid logically                 | Not tested |       |
| TPB-807 | Fees   | Storno payment       | Storno payment                   | Payment is voided/reversed and balance updates | Not tested |       |
| TPB-808 | Fees   | Refresh behavior     | Refresh after payment/storno     | Status and balance remain correct              | Not tested |       |

Known notes:

| Area                      | Note                                               |
| ------------------------- | -------------------------------------------------- |
| Fee invoice status source | Known cleanup; watch for status drift              |
| Payment method            | Known cleanup if method is shown but not persisted |
| Exports                   | Backend-only unless UI exists                      |

---

# 10. General Finance

| Test ID | Module          | Feature             | Scenario                                    | Expected result                       | Status     | Notes |
| ------- | --------------- | ------------------- | ------------------------------------------- | ------------------------------------- | ---------- | ----- |
| TPB-851 | General Finance | Categories list     | Open finance categories if available        | Categories load                       | Not tested |       |
| TPB-852 | General Finance | Create category     | Create category with valid data             | Category appears in list              | Not tested |       |
| TPB-853 | General Finance | Transactions list   | Open transactions ledger                    | Transactions load                     | Not tested |       |
| TPB-854 | General Finance | Create transaction  | Create valid transaction                    | Transaction appears in ledger         | Not tested |       |
| TPB-855 | General Finance | Storno transaction  | Storno transaction if action exists         | Reversal is created and totals update | Not tested |       |
| TPB-856 | General Finance | Permission behavior | Try write action without finance permission | Action is blocked                     | Not tested |       |

Known notes:

| Area                    | Note                          |
| ----------------------- | ----------------------------- |
| Category FE permissions | Known cleanup                 |
| Category code behavior  | Known cleanup                 |
| Transaction export      | Backend-only unless UI exists |

---

# 11. Tenant Users / Permissions

| Test ID | Module      | Feature            | Scenario                                        | Expected result                   | Status     | Notes |
| ------- | ----------- | ------------------ | ----------------------------------------------- | --------------------------------- | ---------- | ----- |
| TPB-901 | Users       | Users page access  | Open Users page as manager/admin-like club user | Page loads if user has permission | Not tested |       |
| TPB-902 | Users       | Create user        | Create tenant user if UI exists                 | User appears in list              | Not tested |       |
| TPB-903 | Users       | Set password       | Set password for tenant user                    | User can login with new password  | Not tested |       |
| TPB-904 | Users       | Deactivate user    | Deactivate test user                            | User becomes inactive             | Not tested |       |
| TPB-905 | Permissions | Missing permission | Try Users page/action without `ManageUsers`     | UI/API blocks access              | Not tested |       |

Known notes:

| Area                             | Note                             |
| -------------------------------- | -------------------------------- |
| `GET /api/users` backend cap     | P0 cleanup item                  |
| User detail endpoint             | Placeholder in audit             |
| Self-deactivation / last manager | Cleanup/product decision pending |

---

# 12. Result summary

| Result       | Count |
| ------------ | ----: |
| Passed       |     0 |
| Failed       |     0 |
| Blocked      |     0 |
| Needs retest |     0 |
| Deferred     |     0 |
| Not tested   |     0 |

---

# 13. Test result notes

Use this section for short execution summary.

```text
Date:
Tester:
Environment:
Test package:
Summary:
Passed:
Failed:
Blocked:
Needs retest:
Recommended follow-up:
```
