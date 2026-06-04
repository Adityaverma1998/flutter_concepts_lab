/ ============================================================
// INTERVIEW QUESTIONS — FUTURE & ASYNC (BASIC TO ADVANCE)
// ============================================================
 
 
// ──────────────────────────────────────────────────────────────
// LEVEL 1 — BASIC  (fresher / 0-1 year)
// ──────────────────────────────────────────────────────────────
 
// Q1. What is a Future in Dart?
// A:  A Future represents a value that is not available yet but will
//     be available at some point — either as a success (value) or
//     failure (error). It is used for async operations like API calls,
//     file reading, database queries.
 
// Q2. What are the 3 states of a Future?
// A:  1. Uncompleted  → still waiting / pending
//     2. Completed with value  → success ✅
//     3. Completed with error  → failure ❌
 
// Q3. What is the use of async and await keywords?
// A:  async  → marks a function as asynchronous
//     await  → pauses execution of that function until the Future
//              completes. Only works inside an async function.
//     Together they make async code look and behave like sync code.
 
// Q4. What is the difference between .then() and async/await?
// A:  Both handle Future results but in different styles:
//     .then()      → callback style, can lead to nested/messy code
//     async/await  → cleaner, readable, modern — preferred in Flutter
//     Under the hood async/await compiles to .then() chains anyway.
 
// Q5. How do you handle errors in a Future?
// A:  Two ways:
//     → Callback style : .catchError((e) => print(e))
//     → async/await    : try { await future } catch(e) { print(e) }
//     try/catch with async/await is the preferred modern approach.
 
// Q6. What does .whenComplete() do?
// A:  Runs a callback whether the Future succeeded or failed.
//     It is equivalent to the finally block in try/catch.
//     Used for cleanup tasks like hiding a loading spinner.
 
// Q7. What is Future.delayed()?
// A:  Creates a Future that completes after a given Duration.
//     Commonly used to simulate API delays in testing or
//     to add intentional delays in UI transitions.
Future.delayed(Duration(seconds: 2), () => print("done"));
 
// Q8. What is Future.value()?
// A:  Creates a Future that completes immediately with a given value.
//     Useful for returning a default/cached value in a Future context.
Future<int> cached() => Future.value(42); // completes instantly
 
 
// ──────────────────────────────────────────────────────────────
// LEVEL 2 — INTERMEDIATE  (1-2 years)
// ──────────────────────────────────────────────────────────────
 
// Q9. What is the difference between Future.wait() and awaiting
//     Futures one by one?
//
// A:  Awaiting one by one → sequential, each waits for previous
//
//     // Total time = 2s + 3s = 5 seconds ❌ slow
//     String a = await Future.delayed(Duration(seconds: 2), () => "A");
//     String b = await Future.delayed(Duration(seconds: 3), () => "B");
//
//     Future.wait() → runs ALL in PARALLEL
//
//     // Total time = max(2s, 3s) = 3 seconds ✅ fast
//     List<String> results = await Future.wait([
//       Future.delayed(Duration(seconds: 2), () => "A"),
//       Future.delayed(Duration(seconds: 3), () => "B"),
//     ]);
//
//     Use Future.wait() whenever Futures are independent of each other.
 
// Q10. What happens if one Future inside Future.wait() fails?
// A:   By default, Future.wait() fails IMMEDIATELY when any one Future
//      fails and throws the error. Other Futures are ignored.
//      To collect all results even if some fail, use:
//      Future.wait([...], eagerError: false)
 
// Q11. What is Future.any()?
// A:   Returns the result of whichever Future completes FIRST.
//      All other Futures are ignored.
//      Use case: race two data sources, use whichever responds faster.
Future.any([
  Future.delayed(Duration(seconds: 3), () => "slow"),
  Future.delayed(Duration(seconds: 1), () => "fast"), // wins ✅
]).then(print); // "fast"
 
// Q12. Is Dart single-threaded? How does it handle async then?
// A:   Yes, Dart is single-threaded. It handles async using an
//      EVENT LOOP. When an async operation is called, it is handed
//      off to the Dart runtime (or OS), and the thread continues
//      running sync code. When the async work finishes, its callback
//      is placed in a queue and the Event Loop picks it up when the
//      call stack is empty. No blocking, no extra threads needed.
 
// Q13. What is the Event Loop in Dart?
// A:   The Event Loop is a continuous loop that:
//      1. Checks if the call stack is empty
//      2. Drains the MICROTASK QUEUE completely (high priority)
//      3. Picks ONE task from the EVENT QUEUE (normal priority)
//      4. Repeats
//      It is the core mechanism behind all async behavior in Dart.
 
// Q14. What is the Microtask Queue? How is it different from Event Queue?
// A:
// ┌──────────────────┬──────────────────────────┬──────────────────────────┐
// │                  │  Microtask Queue          │  Event Queue             │
// ├──────────────────┼──────────────────────────┼──────────────────────────┤
// │  Priority        │  HIGH — runs first        │  NORMAL — runs after     │
// │  Drained         │  Fully before event queue │  One task at a time      │
// │  Sources         │  .then(), Future.value()  │  Future.delayed(), I/O   │
// │                  │  Future.microtask()       │  timers, user events     │
// └──────────────────┴──────────────────────────┴──────────────────────────┘
 
 
// ──────────────────────────────────────────────────────────────
// LEVEL 3 — ADVANCED  (2+ years / senior)
// ──────────────────────────────────────────────────────────────
 
// Q15. What is async/await under the hood?
// A:   async/await is SYNTACTIC SUGAR. The Dart compiler transforms it
//      into .then() chains at compile time. The await keyword suspends
//      the current function, registers the remaining code as a .then()
//      callback in the microtask queue, and returns control to the
//      event loop until the Future completes.
//
//      You write:
//        String data = await fetchData();
//        print(data);
//
//      Dart compiles to:
//        fetchData().then((data) { print(data); });
 
// Q16. What is an Isolate in Dart?
// A:   An Isolate is Dart's version of a thread. Each Isolate has:
//      → Its own thread
//      → Its own memory heap (NO shared memory)
//      → Its own event loop
//      Isolates communicate ONLY via message passing (SendPort/ReceivePort).
//      The main isolate runs Flutter UI. Spawn new isolates for heavy
//      tasks like image processing or large JSON parsing to avoid
//      freezing the UI.
 
// Q17. What is the difference between Future and Stream?
// A:
// ┌────────────────┬──────────────────────────┬──────────────────────────┐
// │                │  Future                  │  Stream                  │
// ├────────────────┼──────────────────────────┼──────────────────────────┤
// │  Values        │  ONE value or error      │  MULTIPLE values         │
// │  Use case      │  API call, file read     │  WebSocket, live data    │
// │  Listen        │  .then() / await         │  .listen() / await for   │
// │  Completion    │  Completes once          │  Can be ongoing          │
// └────────────────┴──────────────────────────┴──────────────────────────┘
 
// Q18. Can you await inside a for loop? What is the risk?
// A:   Yes, you can — but it runs Futures SEQUENTIALLY which is slow.
//
//     // ❌ Sequential — waits for each one before next
//     for (var url in urls) {
//       await http.get(url);  // total time = sum of all durations
//     }
//
//     // ✅ Parallel — run all at once
//     await Future.wait(urls.map((url) => http.get(url)));
 
// Q19. What happens if you forget await on a Future?
// A:   The Future is created but NOT awaited — it runs in the background
//      and you lose the result. Errors are also swallowed silently.
//      The function continues executing without waiting for it.
//
//     Future<void> bad() async {
//       fetchData();        // ⚠️  forgot await — result lost
//       print("done");      // prints immediately, before fetchData finishes
//     }
 
// Q20. What is a Completer in Dart?
// A:   A Completer lets you manually control when a Future completes.
//      Useful when you need to create a Future from a callback-based API.
//
//     Completer<String> completer = Completer();
//
//     someCallbackApi(onSuccess: (data) {
//       completer.complete(data);       // manually complete with value
//     }, onError: (e) {
//       completer.completeError(e);     // manually complete with error
//     });
//
//     String result = await completer.future; // wait for manual completion
 
// Q21. What is the difference between compute() and Isolate.spawn()?
// A:   compute()       → Flutter helper, simpler API, spawns a new isolate,
//                        runs a function, returns result, then kills isolate.
//                        Best for one-off heavy tasks.
//
//      Isolate.spawn() → lower level, full control, isolate stays alive,
//                        can send multiple messages back and forth.
//                        Best for long-running background tasks.
 
// Q22. What is FutureOr<T> in Dart?
// A:   FutureOr<T> means a value can be EITHER a T directly OR a Future<T>.
//      Useful in APIs that can work both sync and async.
//
//     FutureOr<String> getName(bool cached) {
//       if (cached) return "Aditya";              // returns String directly
//       return Future.delayed(Duration(seconds: 1), () => "Aditya"); // Future
//     }
 



 
 
// ──────────────────────────────────────────────────────────────
// QUICK REFERENCE — most asked in interviews
// ──────────────────────────────────────────────────────────────
 
// ⭐  What is Future?               → async value, success or error
// ⭐  3 states of Future?           → uncompleted, value, error
// ⭐  async/await vs .then()?       → sugar over .then(), cleaner style
// ⭐  How to handle errors?         → try/catch with async/await
// ⭐  Future.wait() vs sequential?  → parallel vs one-by-one
// ⭐  Is Dart single-threaded?      → YES, uses Event Loop
// ⭐  Microtask vs Event Queue?     → microtask = high priority
// ⭐  What is an Isolate?           → own thread + memory + event loop
// ⭐  Future vs Stream?             → one value vs multiple values
// ⭐  What is Completer?            → manually control Future completion
// ⭐  What is FutureOr<T>?          → value is T or Future<T>
 
// ============================================================
// END OF NOTES
// ============================================================
 