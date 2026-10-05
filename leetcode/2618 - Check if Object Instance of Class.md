# 2618. Check if Object Instance of Class

**Difficulty:** Medium
**Tags:** N/A
**Acceptance Rate:** 29.5%
**Access:** Free
**URL:** https://leetcode.com/problems/check-if-object-instance-of-class/

---

Write a function that checks if a given value is an instance of a given class or superclass. For this problem, an object is considered an instance of a given class if that object has access to that class's methods.

There are no constraints on the data types that can be passed to the function. For example, the value or the class could be `undefined`.

 

**Example 1:**

**Input:** func = () => checkIfInstanceOf(new Date(), Date)
**Output:** true
**Explanation: **The object returned by the Date constructor is, by definition, an instance of Date.

**Example 2:**

**Input:** func = () => { class Animal {}; class Dog extends Animal {}; return checkIfInstanceOf(new Dog(), Animal); }
**Output:** true
**Explanation:**
class Animal {};
class Dog extends Animal {};
checkIfInstanceOf(new Dog(), Animal); // true

Dog is a subclass of Animal. Therefore, a Dog object is an instance of both Dog and Animal.

**Example 3:**

**Input:** func = () => checkIfInstanceOf(Date, Date)
**Output:** false
**Explanation: **A date constructor cannot logically be an instance of itself.

**Example 4:**

**Input:** func = () => checkIfInstanceOf(5, Number)
**Output:** true
**Explanation: **5 is a Number. Note that the "instanceof" keyword would return false. However, it is still considered an instance of Number because it accesses the Number methods. For example "toFixed()".

**Hints:**
1. In Javascript, inheritance is achieved with the prototype chain.
2. You can get the prototype of an object with the Object.getPrototypeOf(obj) function. Alternatively, you can code obj['__proto__'].
3. You can compare an object's __proto__ with classFunction.prototype.
4. Traverse the entire prototype chain until you find a match.

---

## Solution

```python

```
