# 2816. Double a Number Represented as a Linked List

**Difficulty:** Medium
**Tags:** Linked List, Math, Stack
**Acceptance Rate:** 61.3%
**Access:** Free
**URL:** https://leetcode.com/problems/double-a-number-represented-as-a-linked-list/

---

You are given the `head` of a **non-empty** linked list representing a non-negative integer without leading zeroes.

Return the `head` of the linked list after **doubling** it.

 

**Example 1:**

**Input:** head = [1,8,9]
**Output:** [3,7,8]
**Explanation:** The figure above corresponds to the given linked list which represents the number 189. Hence, the returned linked list represents the number 189 * 2 = 378.

**Example 2:**

**Input:** head = [9,9,9]
**Output:** [1,9,9,8]
**Explanation:** The figure above corresponds to the given linked list which represents the number 999. Hence, the returned linked list reprersents the number 999 * 2 = 1998. 

 

**Constraints:**

	
The number of nodes in the list is in the range `[1, 104]`

	
`0 <= Node.val <= 9`

	
The input is generated such that the list represents a number that does not have leading zeros, except the number `0` itself.

**Hints:**
1. Traverse the linked list from the least significant digit to the most significant digit and multiply each node's value by 2
2. Handle any carry-over digits that may arise during the doubling process.
3. If there is a carry-over digit on the most significant digit, create a new node with that value and point it to the start of the given linked list and return it.

---

## Solution

```python

```
