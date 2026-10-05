# Approval and After
_Approved, declined, or pending. Design the tables that say so._

- **Domain:** data_modeling
- **Difficulty:** Medium
- **Est. time:** 20 min
- **URL:** https://datadriven.io/problems/approval_and_after

## Problem

We run a consumer lending platform. A customer can apply many times, but each application follows one path: our risk team approves or declines it, an approval produces exactly one offer, and that offer is either accepted (funding a single loan) or left to lapse. Because a customer's credit profile drifts over time, the analytics team wants approval rates broken down by the segment the applicant was in when they applied. Design the data model.

**Concepts tested:** `dmConstraints`, `dmDataTypes`, `dmDenormalization`, `dmEntities`, `dmFirstNormalForm`, `dmForeignKeys`, `dmOneToMany`, `dmOneToOne`, `dmPrimaryKeys`, `dmSecondNormalForm`, `dmSurrogateKeys`, `dmThirdNormalForm`

## Solution walkthrough


### What this really is

Under the lending story this is a grain problem with a time-travel trap inside it. Two things are being probed. Can you keep applied, approved, offered and funded as separate events instead of one wide row? And can you freeze the applicant's segment on the application rather than reading it off the live customer? Anyone can draw four boxes. What separates candidates is where `credit_score_at_apply` lives. Join today's `customers` row instead, and **every historical approval rate quietly rewrites itself** the next time a score moves. Merge approval with funding and conversion inflates the same quiet way.

> **Freeze the segment where the decision happened**
>
> The segment is a fact about the application, not the customer. Copy the underwriting inputs onto `loan_applications` at submit time. Then the approval rate for last March is still last March's number a year from now.

### Building it

**Step 1: Give each funnel event its own table**

`loan_applications`, `loan_offers` and `funded_loans` each get a surrogate `BIGINT` key at their own grain. A merged table carries nullable offer and funding columns on every declined row. That breaks 3NF, and the drop-off math turns into counting `NULL`s.

**Step 2: Snapshot the segment on `loan_applications`**

`credit_score_at_apply` and `stated_income_at_apply` sit on the application row. It looks like denormalization, but it is not a transitive dependency. The value depends on `application_id`, because it was true at that moment, and not on `customer_id`.

**Step 3: Put the foreign key on the child**

`loan_applications.customer_id` is many-to-one. `loan_offers.application_id` and `funded_loans.offer_id` are one-to-one, enforced by a unique constraint on each FK. A declined application or a lapsed offer simply has no child row, so nothing is nullable to fake it.

**Step 4: Let `status` carry the decision**

Constrain `status` to 'pending', 'approved' and 'declined' with a CHECK. Fill `decline_reason` only when the status is 'declined'. Approval is a state of the application. Funding is a row in its own table.

```mermaid
flowchart LR
    loan_applications --> customers
    loan_offers --> loan_applications
    funded_loans --> loan_offers
```
**customers**

| column | type | key |
|---|---|---|
| customer_id | BIGINT | PK |
| email | TEXT |  |
| dob | DATE |  |
| signup_date | DATE |  |

**loan_applications**

| column | type | key |
|---|---|---|
| application_id | BIGINT | PK |
| customer_id | BIGINT | FK |
| applied_at | TIMESTAMP |  |
| requested_amount | DECIMAL |  |
| credit_score_at_apply | INT |  |
| stated_income_at_apply | DECIMAL |  |
| status | TEXT |  |
| decline_reason | TEXT |  |

**loan_offers**

| column | type | key |
|---|---|---|
| offer_id | BIGINT | PK |
| application_id | BIGINT | FK |
| offered_amount | DECIMAL |  |
| apr | DECIMAL |  |
| term_months | INT |  |
| expires_at | TIMESTAMP |  |

**funded_loans**

| column | type | key |
|---|---|---|
| funded_loan_id | BIGINT | PK |
| offer_id | BIGINT | FK |
| funded_at | TIMESTAMP |  |
| principal | DECIMAL |  |
| rate | DECIMAL |  |


> **Approved is not funded**
>
> A customer who is approved but never signs is approved for funnel math and never funded. Put `funded_at` on the application row and that customer disappears into a `NULL`, so the approved-to-funded drop-off you were hired to measure goes with it.

> **Offered amount and funded principal are different facts**
>
> Senior candidates keep `offered_amount` on `loan_offers` and `principal` on `funded_loans`, because borrowers often take less than offered. Collapsing them hides that, and it gets noticed.

### Proving the model answers the question

**Funnel by credit tier at application time**

```sql
SELECT
    CASE
        WHEN a.credit_score_at_apply >= 740 THEN 'prime'
        WHEN a.credit_score_at_apply >= 670 THEN 'near_prime'
        ELSE 'subprime'
    END AS tier,
    COUNT(*) AS applications,
    COUNT(*) FILTER (WHERE a.status = 'approved') AS approved,
    COUNT(f.funded_loan_id) AS funded
FROM loan_applications a
LEFT JOIN loan_offers o ON o.application_id = a.application_id
LEFT JOIN funded_loans f ON f.offer_id = o.offer_id
WHERE a.applied_at >= NOW() - INTERVAL '90 days'
GROUP BY tier
ORDER BY tier
```

The query works only because the joins are one-to-one. The `LEFT JOIN`s keep declined and lapsed rows, so `COUNT(*)` stays at application grain while `COUNT(f.funded_loan_id)` counts only the rows that reached funding. Allow two offers per application and `applications` double-counts silently.

| Snapshot on the application | Type 2 customer dimension |
|---|---|
| `credit_score_at_apply` is frozen on the row. Backtests are deterministic and the query needs no temporal join. The cost is one copied column per input. | A history table with `valid_from` and `valid_to`. You get one source of customer state, but every funnel query needs a range join on `applied_at`, and a late correction rewrites history. |

- **A regulator wants the exact score used to approve one funded loan. Walk the path.**
  - _Tests that `funded_loans` reaches `credit_score_at_apply` through FKs alone._
- **An offer can now be re-issued after expiry. What breaks?**
  - _Tests that the 1:1 on `loan_offers.application_id` becomes 1:N and the funnel query must pick one offer._
- **How would you add co-applicants?**
  - _Tests a bridge table between `loan_applications` and `customers` that carries per-applicant snapshots._
