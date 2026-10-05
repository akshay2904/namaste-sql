# 2621. Sleep

**Difficulty:** Easy
**Tags:** N/A
**Acceptance Rate:** 87.4%
**Access:** Free
**URL:** https://leetcode.com/problems/sleep/

---

Given a positive integer `millis`, write an asynchronous function that sleeps for `millis` milliseconds. It can resolve any value.

**Note** that minor deviation from `millis` in the actual sleep duration is acceptable.

 

**Example 1:**

**Input:** millis = 100
**Output:** 100
**Explanation:** It should return a promise that resolves after 100ms.
let t = Date.now();
sleep(100).then(() => {
  console.log(Date.now() - t); // 100
});

**Example 2:**

**Input:** millis = 200
**Output:** 200
**Explanation:** It should return a promise that resolves after 200ms.

 

**Constraints:**

	
`1 <= millis <= 1000`

**Hints:**
1. In Javascript, you can execute code after some delay with the setTimeout(fn, sleepTime) function.
2. An async function is defined as function which returns a Promise.
3. To create a Promise, you can code new Promise((resolve, reject) => {}). When you want the function to return a value, code resolve(value) inside the callback.

---

## Solution

```python

```
