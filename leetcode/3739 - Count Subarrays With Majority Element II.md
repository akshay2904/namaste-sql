# 3739. Count Subarrays With Majority Element II

**Difficulty:** Hard
**Tags:** Array, Hash Table, Divide and Conquer, Segment Tree, Merge Sort, Prefix Sum
**Acceptance Rate:** 45.5%
**Access:** Free
**URL:** https://leetcode.com/problems/count-subarrays-with-majority-element-ii/

---

You are given an integer array `nums` and an integer `target`.

Return the number of **subarrays** of `nums` in which `target` is the **majority element**.

The **majority element** of a subarray is the element that appears **strictly more than half** of the times in that subarray.

 

**Example 1:**

**Input:** nums = [1,2,2,3], target = 2

**Output:** 5

**Explanation:**

Valid subarrays with `target = 2` as the majority element:

	
`nums[1..1] = [2]`

	
`nums[2..2] = [2]`

	
`nums[1..2] = [2,2]`

	
`nums[0..2] = [1,2,2]`

	
`nums[1..3] = [2,2,3]`

So there are 5 such subarrays.

**Example 2:**

**Input:** nums = [1,1,1,1], target = 1

**Output:** 10

**Explanation: **

**​​​​​​​**All 10 subarrays have 1 as the majority element.

**Example 3:**

**Input:** nums = [1,2,3], target = 4

**Output:** 0

**Explanation:**

`target = 4` does not appear in `nums` at all. Therefore, there cannot be any subarray where 4 is the majority element. Hence the answer is 0.

 

**Constraints:**

	
`1 <= nums.length <= 10​​​​​​​5`

	
`1 <= nums[i] <= 10​​​​​​​9`

	
`1 <= target <= 109`

**Hints:**
1. Convert to +1/-1: let `arr[i] = 1` if `nums[i] == target` else `-1`.
2. Build prefix sums: `pref[0]=0`, `pref[k] = pref[k - 1] + arr[k - 1]` for `k=1..n`.
3. Count pairs `(i < j)` with `pref[j] > pref[i]` (these correspond to subarrays where `target` is majority).
4. Use coordinate compression on all `pref` values and a Fenwick tree / ordered map: iterate `k` from `0..n`, query how many previous `pref` are < current, add to `ans`, then update.
5. If `target` never appears return `0`.

---

## Solution

```python

```
