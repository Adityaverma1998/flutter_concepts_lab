
// LEVEL 4 — TRICKY / TRAP QUESTIONS  (interviewer traps ⚠️)
// ──────────────────────────────────────────────────────────────
 
// ─────────────────────────────────────
// TRAP 1 — Can we use async/await without Future?
// ─────────────────────────────────────
// Q: Can you use async and await without writing Future anywhere?
//
// ❌ TRAP ANSWER: "Yes! You don't need Future at all."
// ✅ REAL ANSWER:
//    You can HIDE the word Future but you can NEVER avoid it.
//    Dart creates a Future automatically behind the scenes.
//
//    Case 1 — async without writing Future in return type:
//      void main() async { ... }
//      → Dart silently makes it Future<void> main() async
//
//    Case 2 — await on a plain value:
//      String name = await "Aditya";  // ✅ valid
//      → Dart wraps it as Future.value("Aditya") internally
//
//    Case 3 — return plain value from async function:
//      String getName() async { return "Aditya"; }
//      → Dart wraps return as Future<String> automatically
//
//    ONE LINE: async/await is just clean syntax OVER Future.
//    You can skip writing "Future" but Dart always creates one. ✅
 
 
// ─────────────────────────────────────
// TRAP 2 — What is the OUTPUT of this code?
// ─────────────────────────────────────
void trap2() {
  print("A");
  Future(() => print("B"));
  Future.microtask(() => print("C"));
  print("D");
}
// ❌ TRAP ANSWER: A B C D   or   A C B D
// ✅ REAL OUTPUT:
//    A
//    D
//    C    ← microtask queue (high priority)
//    B    ← event queue (normal priority)
//
// WHY:
//   "A" and "D" are sync → run immediately on call stack
//   Future.microtask() → pushed to MICROTASK QUEUE
//   Future()           → pushed to EVENT QUEUE
//   Microtask drains FIRST before event queue
 
 
// ─────────────────────────────────────
// TRAP 3 — Does await block the thread?
// ─────────────────────────────────────
// Q: Does await block the main thread while waiting?
//
// ❌ TRAP ANSWER: "Yes, await pauses/blocks the thread."
// ✅ REAL ANSWER:
//    await SUSPENDS the current FUNCTION only — not the thread.
//    The event loop continues running other tasks.
//    The UI stays responsive. Nothing is blocked.
//
//    await = "pause this function, go back to event loop,
//             resume this function when Future completes"
 
 
// ─────────────────────────────────────
// TRAP 4 — What is the OUTPUT of this code?
// ─────────────────────────────────────
Future<void> trap4() async {
  print("1");
  await Future.delayed(Duration(seconds: 0)); // zero delay!
  print("2");
}
void runTrap4() {
  trap4();
  print("3");
}
// ❌ TRAP ANSWER: 1 2 3
// ✅ REAL OUTPUT:
//    1
//    3    ← runs before "2" even though delay is ZERO
//    2
//
// WHY:
//   Even Duration(seconds: 0) pushes callback to EVENT QUEUE
//   "3" is sync code — runs before event queue is processed
//   await always yields control back to event loop, even with 0 delay
 
 
// ─────────────────────────────────────
// TRAP 5 — What happens if you don't await a Future?
// ─────────────────────────────────────
Future<void> trap5() async {
  fetchData();        // ⚠️ forgot await
  print("done");      // prints immediately
}
// ❌ TRAP ANSWER: "It throws an error"
// ✅ REAL ANSWER:
//    NO error is thrown. The Future runs in the background silently.
//    → The result is LOST
//    → Any ERROR inside fetchData() is SWALLOWED silently
//    → "done" prints before fetchData() finishes
//    This is one of the most dangerous bugs in Flutter — no crash,
//    no warning, just wrong behavior.
 
 
// ─────────────────────────────────────
// TRAP 6 — Are these two the same?
// ─────────────────────────────────────
// VERSION A:
Future<void> versionA() async {
  await Future.wait([
    Future.delayed(Duration(seconds: 2), () => print("A")),
    Future.delayed(Duration(seconds: 3), () => print("B")),
  ]);
} // total time = 3 seconds ✅
 
// VERSION B:
Future<void> versionB() async {
  await Future.delayed(Duration(seconds: 2), () => print("A"));
  await Future.delayed(Duration(seconds: 3), () => print("B"));
} // total time = 5 seconds ❌ slow
 
// ❌ TRAP ANSWER: "Both are the same, just different syntax"
// ✅ REAL ANSWER:
//    VERSION A → runs in PARALLEL  → 3 seconds total
//    VERSION B → runs SEQUENTIALLY → 5 seconds total
//    Future.wait() runs all Futures at the same time.
//    Sequential await waits for each one to finish before starting next.
 
 
// ─────────────────────────────────────
// TRAP 7 — Can an async function return void?
// ─────────────────────────────────────
// Q: What is the difference between Future<void> and void in async?
//
// ❌ TRAP ANSWER: "They are the same — both return nothing"
// ✅ REAL ANSWER:
//    void getName() async { ... }
//    → return type is technically Future<void> but caller CANNOT await it
//    → errors thrown inside are UNCATCHABLE by the caller
//
//    Future<void> getName() async { ... }
//    → caller CAN await it
//    → errors can be caught with try/catch
//
//    RULE: Always use Future<void> for async functions
//          so errors don't get silently swallowed ✅
 
 
// ─────────────────────────────────────
// TRAP 8 — What is the OUTPUT of this code?
// ─────────────────────────────────────
Future<void> trap8() async {
  print("1");
 
  Future(() {
    print("2");
    Future.microtask(() => print("3"));
  });
 
  Future.microtask(() => print("4"));
 
  print("5");
}
// ❌ TRAP ANSWER: most people guess wrong order
// ✅ REAL OUTPUT:
//    1    ← sync
//    5    ← sync
//    4    ← microtask queue (before event queue)
//    2    ← event queue runs
//    3    ← microtask spawned INSIDE event, runs before next event
//
// WHY:
//   After "2" runs (event queue), a NEW microtask "3" is added.
//   Microtask queue is checked AGAIN before next event queue item.
//   So "3" runs immediately after "2", before any other event.
 
 
// ─────────────────────────────────────
// TRAP 9 — Do Isolates share memory?
// ─────────────────────────────────────
// Q: Can two Isolates access the same variable?
//
// ❌ TRAP ANSWER: "Yes, like threads in Java they share heap memory"
// ✅ REAL ANSWER:
//    NO. Isolates in Dart have COMPLETELY SEPARATE memory heaps.
//    They CANNOT share variables, objects, or state.
//    They can ONLY communicate by passing MESSAGES via
//    SendPort and ReceivePort.
//    This is by design — eliminates race conditions and deadlocks.
 
 
// ─────────────────────────────────────
// TRAP 10 — then() vs await — which is faster?
// ─────────────────────────────────────
// Q: Is .then() faster than await since await/async adds overhead?
//
// ❌ TRAP ANSWER: "Yes .then() is faster — no async overhead"
// ✅ REAL ANSWER:
//    They are IDENTICAL in performance.
//    await/async compiles DOWN to .then() chains.
//    The compiler generates the exact same bytecode.
//    Choose based on READABILITY not performance.
//    async/await wins on readability every time. ✅
 
