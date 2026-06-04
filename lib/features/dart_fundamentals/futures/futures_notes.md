// ============================================================
// DART FUTURE — INTERVIEW NOTES
// Topic  : Asynchronous Programming / Future
// ============================================================
 
 
// ──────────────────────────────────────────────────────────────
// 7. WHAT IS A FUTURE?
// ──────────────────────────────────────────────────────────────
 
// Future → represents a value that is NOT available yet
//          but WILL be available at some point in the future
//          (either a SUCCESS value OR an ERROR)
 
// Real life analogy:
//   You order food online → you get an ORDER ID (Future)
//   Later → either food arrives ✅  OR  order cancelled ❌
 
// Future has exactly 3 states:
//   1. Uncompleted  → still waiting (pending)
//   2. Completed with VALUE  → success ✅
//   3. Completed with ERROR  → failure ❌
 
Future<String> fetchData() {
  return Future.delayed(Duration(seconds: 2), () => "Data loaded!");
}
 
// Future<String> means → this function will return a String
//                        but not right now — later (async)
 
 
// ──────────────────────────────────────────────────────────────
// 8. async & await — CLEANEST WAY TO USE FUTURE
// ──────────────────────────────────────────────────────────────
 
// async → marks a function as asynchronous
// await → PAUSES execution until the Future completes
//         (only works inside an async function)
 
Future<void> getData() async {
  String result = await fetchData();  // waits here until done
  print(result);                      // prints: Data loaded!
}
 
// ⚠️  await does NOT block the UI thread
//     It only suspends THIS function, rest of app keeps running
 
 
// ──────────────────────────────────────────────────────────────
// 9. .then() — CALLBACK STYLE
// ──────────────────────────────────────────────────────────────
 
// .then() → runs when Future completes successfully
// Alternative to async/await — older style but still used
 
fetchData().then((value) {
  print(value);  // "Data loaded!"
});
 
// Chaining multiple .then()
Future.delayed(Duration(seconds: 1), () => 10)
  .then((val) => val * 2)   // 20
  .then((val) => val + 5)   // 25
  .then((val) => print(val)); // prints: 25
 
 
// ──────────────────────────────────────────────────────────────
// 10. .catchError() — HANDLE ERRORS (callback style)
// ──────────────────────────────────────────────────────────────
 
// .catchError() → runs when Future completes with an ERROR
// Always chain after .then() to catch failures
 
fetchData()
  .then((value) => print(value))
  .catchError((error) => print("Error: $error"));  // ❌ caught here
 
 
// ──────────────────────────────────────────────────────────────
// 11. try / catch — HANDLE ERRORS (async/await style)
// ──────────────────────────────────────────────────────────────
 
// When using async/await, use try/catch instead of .catchError()
// This is the PREFERRED modern style in Flutter
 
Future<void> loadData() async {
  try {
    String result = await fetchData();
    print(result);           // ✅ success
  } catch (e) {
    print("Error: $e");      // ❌ failure caught here
  }
}
 
 
// ──────────────────────────────────────────────────────────────
// 12. .whenComplete() — RUNS ALWAYS (like finally)
// ──────────────────────────────────────────────────────────────
 
// .whenComplete() → runs whether Future succeeded OR failed
// Same as finally in try/catch
 
fetchData()
  .then((value) => print(value))
  .catchError((e) => print("Error: $e"))
  .whenComplete(() => print("Done! always runs ✅"));
 
 
// ──────────────────────────────────────────────────────────────
// 13. Future.value() — CREATE AN INSTANT FUTURE
// ──────────────────────────────────────────────────────────────
 
// Creates a Future that completes IMMEDIATELY with a value
// Useful for testing or returning a default value
 
Future<int> getNumber() {
  return Future.value(42);  // completes instantly with 42
}
 
 
// ──────────────────────────────────────────────────────────────
// 14. Future.error() — CREATE AN INSTANT ERROR FUTURE
// ──────────────────────────────────────────────────────────────
 
// Creates a Future that completes IMMEDIATELY with an error
// Useful for testing error handling
 
Future<int> getError() {
  return Future.error("Something went wrong!");
}
 
 
// ──────────────────────────────────────────────────────────────
// 15. Future.delayed() — DELAY EXECUTION
// ──────────────────────────────────────────────────────────────
 
// Runs a function after a given Duration
// Commonly used to simulate API calls in testing
 
Future.delayed(Duration(seconds: 3), () {
  print("Runs after 3 seconds");
});
 
 
// ──────────────────────────────────────────────────────────────
// 16. Future.wait() — RUN MULTIPLE FUTURES IN PARALLEL
// ──────────────────────────────────────────────────────────────
 
// Runs multiple Futures AT THE SAME TIME
// Waits for ALL of them to complete, then returns all results
// Much faster than awaiting them one by one
 
Future<void> loadAll() async {
  List<String> results = await Future.wait([
    fetchData(),                                        // runs in parallel
    Future.delayed(Duration(seconds: 1), () => "B"),   // runs in parallel
    Future.delayed(Duration(seconds: 2), () => "C"),   // runs in parallel
  ]);
  print(results); // ["Data loaded!", "B", "C"]
}
 
// ⚠️  If ANY one Future fails → Future.wait() fails entirely
//     Use Future.wait with eagerError: false to collect all results
 
 
// ──────────────────────────────────────────────────────────────
// 17. Future.any() — RETURN FIRST COMPLETED FUTURE
// ──────────────────────────────────────────────────────────────
 
// Returns the result of whichever Future completes FIRST
// Others are ignored
 
Future<void> race() async {
  String first = await Future.any([
    Future.delayed(Duration(seconds: 3), () => "Slow"),
    Future.delayed(Duration(seconds: 1), () => "Fast"),  // wins ✅
  ]);
  print(first); // "Fast"
}
 
 
// ──────────────────────────────────────────────────────────────
// 18. KEY INTERVIEW COMPARISONS
// ──────────────────────────────────────────────────────────────
 
// Future vs Stream
// ┌────────────┬──────────────────────────┬──────────────────────────┐
// │            │  Future                  │  Stream                  │
// ├────────────┼──────────────────────────┼──────────────────────────┤
// │  Values    │  ONE value (or error)    │  MULTIPLE values         │
// │  Use case  │  API call, file read     │  live data, sockets      │
// │  Listen    │  .then() / await         │  .listen() / await for   │
// │  Example   │  http.get(url)           │  WebSocket messages      │
// └────────────┴──────────────────────────┴──────────────────────────┘
 
// .then() vs async/await
// ┌─────────────────┬────────────────────────────────────────────────┐
// │  .then()        │  Callback style, can get messy (callback hell) │
// │  async/await    │  Cleaner, readable, modern — preferred ✅      │
// └─────────────────┴────────────────────────────────────────────────┘
 
 
// ──────────────────────────────────────────────────────────────
// 19. QUICK MEMORY AID — ALL FUTURE METHODS
// ──────────────────────────────────────────────────────────────
 
// Future<T>          → a value T coming in the future
// async              → marks function as asynchronous
// await              → wait for Future to complete
// .then()            → on success callback
// .catchError()      → on error callback
// .whenComplete()    → always runs (like finally)
// Future.value()     → instant success Future
// Future.error()     → instant error Future
// Future.delayed()   → run after a delay
// Future.wait()      → run multiple Futures in parallel, wait ALL
// Future.any()       → run multiple Futures, return FIRST result
 
// ONE LINE INTERVIEW ANSWER:
//   "Future in Dart represents an async operation that will complete
//    with either a value (success) or an error (failure) in the future.
//    We handle it using async/await or .then()/.catchError()." ✅
 
// ============================================================
// DART FUTURE — UNDER THE HOOD
// Topic  : How Future works internally (Event Loop, Isolates)
// Author : Aditya
// ============================================================


// ──────────────────────────────────────────────────────────────
// 1. DART IS SINGLE THREADED — but non-blocking
// ──────────────────────────────────────────────────────────────

// Most people think:  async = multiple threads  ❌ WRONG in Dart
//
// Dart truth:
//   → Runs on a SINGLE thread
//   → Never sits idle — uses an EVENT LOOP to handle async work
//   → The event loop picks up completed tasks and runs their callbacks


// ──────────────────────────────────────────────────────────────
// 2. THE EVENT LOOP — Heart of Dart async
// ──────────────────────────────────────────────────────────────

// Dart has 2 internal queues inside every Isolate:
//
// ┌─────────────────────────────────────────┐
// │            DART ISOLATE                 │
// │                                         │
// │  ┌─────────────────────────────────┐    │
// │  │       MICROTASK QUEUE           │    │  ← HIGHER priority
// │  │  (Future.value, .then(),        │    │
// │  │   Future.microtask())           │    │
// │  └─────────────────────────────────┘    │
// │                                         │
// │  ┌─────────────────────────────────┐    │
// │  │         EVENT QUEUE             │    │  ← NORMAL priority
// │  │  (Future.delayed, I/O, timers,  │    │
// │  │   user events, network)         │    │
// │  └─────────────────────────────────┘    │
// │                                         │
// │         ↕  EVENT LOOP checks both       │
// └─────────────────────────────────────────┘
//
// RULE: Microtask queue is ALWAYS fully drained FIRST
//       before Event queue gets a single turn


// ──────────────────────────────────────────────────────────────
// 3. STEP BY STEP — what happens when you call a Future
// ──────────────────────────────────────────────────────────────

void main() {
  print("1 - start");                        // runs immediately (sync)

  Future.delayed(Duration(seconds: 2), () {
    print("3 - future done");                // pushed to EVENT QUEUE
  });

  print("2 - end of main");                  // runs immediately (sync)
}

// OUTPUT:
//   1 - start
//   2 - end of main
//   (2 seconds later...)
//   3 - future done

// INTERNAL STEPS:
//   1. main() → goes onto call stack
//   2. print("1") → executes immediately
//   3. Future.delayed() → registers a TIMER with Dart runtime, moves on
//                         does NOT block — returns instantly
//   4. print("2") → executes immediately
//   5. main() finishes → call stack is EMPTY
//   6. Event loop wakes up → checks microtask queue → empty
//   7. Event loop checks event queue → timer fired! → runs callback
//   8. print("3") executes


// ──────────────────────────────────────────────────────────────
// 4. MICROTASK vs EVENT QUEUE — priority proof
// ──────────────────────────────────────────────────────────────

void priorityDemo() {
  print("1 - sync");

  Future(() => print("4 - event queue"));           // → EVENT QUEUE

  Future.microtask(() => print("3 - microtask"));   // → MICROTASK QUEUE

  Future.value("x").then((_) => print("2 - .then() is microtask"));
  // .then() callback → also goes to MICROTASK QUEUE

  print("5 - sync end");
}

// OUTPUT:
//   1 - sync
//   5 - sync end
//   2 - .then() is microtask    ← microtask runs BEFORE event queue
//   3 - microtask               ← microtask runs BEFORE event queue
//   4 - event queue             ← event runs LAST

// KEY INSIGHT:
//   .then() callbacks → MICROTASK QUEUE (high priority)
//   Future.delayed()  → EVENT QUEUE     (normal priority)
//   Future.value()    → MICROTASK QUEUE (instant, high priority)


// ──────────────────────────────────────────────────────────────
// 5. async / await — WHAT IT REALLY IS UNDER THE HOOD
// ──────────────────────────────────────────────────────────────

// async/await is just SYNTACTIC SUGAR
// Dart compiler automatically converts it into .then() chains

// What YOU write:
Future<void> load() async {
  String data = await fetchData();
  print(data);
}

// What DART actually COMPILES it to internally:
Future<void> loadCompiled() {
  return fetchData().then((data) {
    print(data);
  });
}

// await literally means:
//   "Pause THIS function here,
//    register the rest as a .then() callback,
//    go back to the event loop,
//    resume when the Future completes"
//
// ⚠️  It does NOT block the thread — it only suspends the function


// ──────────────────────────────────────────────────────────────
// 6. ISOLATES — Dart's version of threads
// ──────────────────────────────────────────────────────────────

// Isolate = its own thread + its own memory + its own event loop
//
// ┌─────────────────────┐       ┌─────────────────────┐
// │   MAIN ISOLATE      │       │   NEW ISOLATE        │
// │                     │       │                      │
// │  Flutter UI         │◄─────►│  Heavy computation   │
// │  Event Loop         │  msg  │  Image processing    │
// │  Your app code      │       │  JSON parsing        │
// └─────────────────────┘       └─────────────────────┘
//
// KEY RULES:
//   → Isolates DO NOT share memory (unlike threads in Java/Kotlin)
//   → They communicate ONLY via MESSAGES (SendPort / ReceivePort)
//   → Main isolate handles UI — never block it with heavy work

import 'dart:isolate';

// Spawning a new isolate for heavy work (won't freeze the UI)
void heavyTask(SendPort sendPort) {
  int result = 0;
  for (int i = 0; i < 1000000000; i++) result += i; // heavy loop
  sendPort.send(result);  // send result back to main isolate
}

Future<void> runHeavyWork() async {
  ReceivePort receivePort = ReceivePort();
  await Isolate.spawn(heavyTask, receivePort.sendPort);
  int result = await receivePort.first;
  print("Result: $result"); // UI stays smooth ✅
}


// ──────────────────────────────────────────────────────────────
// 7. FULL PICTURE — complete under the hood flow
// ──────────────────────────────────────────────────────────────

//   Your Code
//      ↓
//   Call Stack  (executes sync code, top to bottom)
//      ↓
//   Async operation hit (Future.delayed / http call / file I/O)
//      ↓
//   Handed off → Dart Runtime / OS  (non-blocking, returns instantly)
//      ↓
//   Call Stack continues remaining sync code
//      ↓
//   Call Stack EMPTY → Event Loop wakes up
//      ↓
//   ┌─────────────────────────────────────┐
//   │  1. Drain MICROTASK QUEUE fully     │  ← always first
//   │  2. Pick ONE task from EVENT QUEUE  │  ← then this
//   │  3. Repeat                          │
//   └─────────────────────────────────────┘
//      ↓
//   Callback runs → result returned to your code


// ──────────────────────────────────────────────────────────────
// 8. QUICK MEMORY AID
// ──────────────────────────────────────────────────────────────

// Single thread     → Dart has only ONE thread (main isolate)
// Event Loop        → keeps checking queues when call stack is empty
// Microtask Queue   → high priority (.then(), Future.value())
// Event Queue       → normal priority (Future.delayed, I/O, timers)
// await             → suspends function, registers rest as .then()
// async/await       → syntactic sugar over .then() chains
// Isolate           → separate thread with its own memory & event loop
// Message passing   → only way isolates communicate (no shared memory)

// ONE LINE INTERVIEW ANSWER:
//   "Dart is single-threaded and uses an Event Loop with two queues —
//    Microtask (high priority) and Event (normal priority). When a Future
//    is called, it registers a callback and returns immediately without
//    blocking. When the async work finishes, the callback is pushed to
//    the appropriate queue. The Event Loop picks it up when the call
//    stack is empty. async/await is just syntactic sugar over .then()." ✅

// ============================================================
// END OF NOTES
// ============================================================